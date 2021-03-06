function [inertia] = inertiaRotor(D, d, m)
    %% Calculate inertia of a rotationally symmetric body
    % Inputs:
    % D  =  Outer diameter  / m
    % d  =  Inner diameter  / m
    % m  =  Mass            / kg
    %
    % Outputs:
    % inertia               / kgm^2
    %
    %% Callum Morrison, 2019
    
    % Convert diameter to radii
    R = D / 2;
    r = d / 2;
    
    % Calculate intertia
    inertia = 0.5 * m * (R^2 + r^2);