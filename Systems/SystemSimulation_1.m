clear all
close all
clc

% Overall simulation for the optimization for one drone
%Can calculate the acceleration after the rotor function is called
%Only include power requirement for most costly sensor in sensor package during cruise

%% Sensor Type Data. Different sensor types are designated with different input values
% 1 = Hyperspectral Camera - run during cruise
% 2 = Camera - run during cruise
% 3 - Short range comm - run during recharge time

pwrdraw = [ 13, 45.54, ];           %watts of power per sensor type
fov = [62.2, 48.8, 0];               %degrees for field of view for sensor type
maxrange = [ 0, 0, 4000];          %meters that sensor type can be functional
datarate = [ 7.5*1000/2, 7.5*1000/2, ];          %kb/sol of data transferred for each sensor type
sensmass = [.5, 1, ];              %kg of mass per sensor type
Qdotground = 20;                                %watts required electrical for electrical heating when in recharge mode
T_motor_max = 100;                              % [C] Maximum motor operational temperature
T_motor_min = 0;                                % [C] Minimum motor operational temperature
T_batt_max = 30;                                % [C] Maximum battery operational temperature
T_batt_min = 0;                                 % [C] Minimum battery operational temperature

%% Mars enviornmental conditions

rho = .02;              %kg/m^3 density at surface
a = 240;                %m/s speed of sound
mu = 1.422*10^(-5);     %kg/(m*s) kinematic viscocity
g = 3.71;               %m/s^2 gravity on martian surface
Sflux = [];             %solar flux on the martian surface
sollength = 88620;      %sol of mars in seconds
%% Iterated Values

OMass = 10:.5:60;               %Overall mass assumed for one drone - optimal 20 kg
Chargetime = 1:1:5;             %Sols of charge time between flights - optimal 1 sol
Maxflttime = 60:2:900;          %Maximum flight time for drone in seconds (1 min to 15 min) - optimal 420 s
Altitude = 10:1:300;            %Altitudes the drone will cruise - optimal is 100 m

%% Other designated constants

MaxMissionArea = 120;           %Mission designated area km^2
MaxMissionTime = 145;           %Sols of mission time
SF = 1.25;                      %Safety Factor inherent in design
verticlefltspeed = 10;          %m/s Verticle flight speed

%% Given  rotor data for rotor function
solidity = .32;             %total solidity of the rotor
k = ;                       %aerodynamic correction factor
tipMach = ;                 %mach speed of tip of rotor
Cd_blade_avg_hover = ;      %drag factor for hover
Cd_blade_avg_climb = ;      %drag factor during climb
Cd_blade_avg_cruise = ;     %drag factor for cruise
A_body = 2;                 %frontal area of vehicle
Cd_body = 2;                %estimated drag factor of body
motor_eff = .85;            %motor estimated efficiency

%% Avionics funtion provides power draw for systems watts

%% Iteration for all given values for main portion of code

for ovmass = OMass
    %Rotor only requires mass
    if bladeradi > 0 && bladeradi <= .45
        for Alt = Altitude
            %Acceleration speed verticle/horizontal
            %Motor only requires motor
            for MFT = Maxflttime
                %Battery requires Rotor, Motor, Avionics, Altitude, Max Flight Time
                if battmass > 0 && battmass < ovmass
                    for CT = Chargetime
                        ct = CT*88620-MFT;              %charge time allowed in seconds
                        %Solar Panel/Recharge battery requries battery
                        %Structures requires everything
                        [mass_best, Alt_best, MFT_best, CT_best, flag] = DecisionMatrix(mass_prev, Alt_prev, MFT_prev, CT_prev,mass_curr, Alt_curr,MFT_curr, CT_curr)  %Decision Matrix for code
                        if flag = 1;
                            %keep new data
                        end
                    end
                end
            end
        end
    end
end

%% Grading Criterion for each iteration (1-5: 5 being most important)
% Lower mass systems 5
% Charge time lower 3
% Area covered in single flight 3
% Altitude for risk avoidance (lower is better generally) 2
% Minimize the maximum linear dimension (can determine # of drones and wether secondary or primary mission) 4




