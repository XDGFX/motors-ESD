function [torque] = linearToRotary(force, r, gr)
%% Convert linear force to rotary torque
% Inputs:
% force  =  force to convert              / N
% r      =  distance at which force acts  / m
% gr     =  gear ratio                    / unitless
%
% Outputs:
% torque                                  / Nm
%
%% Callum Morrison, 2019

if ~exist("gr", "var")
    gr = 1;
end

torque = force * r / gr;