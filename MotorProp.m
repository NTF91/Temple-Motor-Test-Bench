% This application will import the APC propeller data from a 
% PROP_DATA.mat file type.
% The user will be prompted to select the propeller size from the 
% list. Each propeller is named length by pitch for easy identification. 
% Once selected, the application will pull the data from the selected 
% propeller and assign each column to the variables RPM, thrust, power, 
% torque, power coefficient, and, thrust coefficient. The variables’ units 
% will be converted into standard SI units so there is no unit mismatch 
% and then used to calculate the propellers efficiency versus RPM. 
% The next function will take several user inputs and to determine the 
% properties of a BLDC motor. The variables, Kv (motor constant), 
% motor voltage, and motor resistance will be entered by the user and used 
% to calculate the torque the motor produces at varying RPMs. 

clc;
clear;

rho = 1.225;
userKv = 930;
userVoltage = 16;
userResistence = 27;

propNames = who('-file','PROP_DATA.mat');
[indx,tf] = listdlg('PromptString','Select a Propeller Size:',...
            'SelectionMode','single','ListString',propNames);

userSelection = load("PROP_DATA.mat", propNames{indx});
selectedPropData = struct2cell(userSelection);

%Imports RPM, Thrust, etc. into seperate variables
RPM = selectedPropData{1}(:,1);
Thrust = selectedPropData{1}(:,2);
Power = selectedPropData{1}(:,3);
Torque = selectedPropData{1}(:,4);
Cp = selectedPropData{1}(:,5);
Ct = selectedPropData{1}(:,6);
PropDiaMeter = selectedPropData{1}(1,7);

[Kv,Voltage,Resistence] = userMotorInputs(userKv,userVoltage,userResistence);

[RPS,ThrustSI,PowerSI,TorqueSI,PropDiaMeterSI] = convert2SI(RPM,Thrust,Power,Torque,PropDiaMeter);

[RotorArea,Qmotor,Qprop] = calculation(PropDiaMeterSI,Voltage,Resistence,RPS,Kv,Cp,rho);

function  [Kv,Voltage,Resistence] = userMotorInputs(userKv,userVoltage,UserResistence)
    Kv = userKv;
    Voltage = userVoltage;
    Resistence = UserResistence;
end

function [RPS,ThrustSI,PowerSI,TorqueSI,PropDiaMeterSI] = convert2SI...
    (RPM,Thrust,Power,Torque,PropDiaMeter)
    RPS = RPM./60;
    ThrustSI = Thrust.*4.44822;
    PowerSI = Power.*745.7;
    TorqueSI = Torque.*0.112984;
    PropDiaMeterSI = PropDiaMeter.*0.0254;
end

function [RotorArea,Qmotor,Qprop] = calculation...
    (PropDiaMeterSI,Voltage,Resistence,RPS,Kv,Cp,rho)
    RotorArea = 2*pi*(PropDiaMeterSI/2.)^2;
    Qmotor = ((Voltage - (RPS/Kv))*(1/Resistence))*(1/Kv);
    Qprop = 0.5*rho.*((RPS.*RotorArea).^2).*pi.*RotorArea.^3.*Cp;
end

% function plot
% figure(1);
% scatter(RPS,Qmotor);
% hold on
% figure(2);
% scatter(RPS,Qprop);
% hold off