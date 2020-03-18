clc;
clear;

load("PROP_DATA.mat");

% function userMotorParameters = motorParamters(Kv,Voltage,Resistence)
%     
% end

propNames = who('-file','PROP_DATA.mat');
[indx,tf] = listdlg('PromptString','Select a Propeller Size:',...
                'SelectionMode','single','ListString',propNames);

userSelection = load("PROP_DATA.mat", propNames{indx});
selectedPropData = struct2cell(userSelection);
%Imports RPM, Thrust, etc. into seperate variables
RadsPerSecond = (selectedPropData{1}(:,1)).*(pi/30);
ThrustNewtons = (selectedPropData{1}(:,2)).*(4.4482216);
PowerWatts = (selectedPropData{1}(:,3)).*(745.7);
TorqueNM = (selectedPropData{1}(:,4)).*(113/1000);
Cp = selectedPropData{1}(:,5);
Ct = selectedPropData{1}(:,6);

