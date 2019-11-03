function [] = calculate()
%% Calculations script for motors coursework
%% Callum Morrison, 2019

% Load variables from other file
disp("Loading variables...")
variables
disp("Variables loaded")
fprintf('\n')

%% Inertia Calculations
if exist('D','var')
    for x = 1:1:size(D,2)
        disp("Rotor no. " + x + " uses variables:")
        disp("D = " + D(x))
        disp("d = " + d(x))
        disp("m = " + m(x))
        
        inertia(x) = inertiaRotor(D(x), d(x), m(x));
        
        disp("Inertia for rotor " + x + " was calculated as " + inertia(x) + "kgm^s")
        fprintf('\n')
    end
else
    disp("No rotors detected... continuing")
    fprintf('\n')
end

if exist('mL','var')
    for x = 1:1:size(mL,2)
        disp("Linear 'inertia' source found: m = " + mL(x) + "kg")
        
        fprintf('\n')
    end
else
    disp("No linear 'inertia' sources detected... continuing")
    fprintf('\n')
end

if exist('iC','var')
    for x = 1:1:size(iC,2)
        disp("Constant inertia source found: i = " + iC(x) + "kgm^s")
        
        inertia = [inertia, iC(x)];
        
        fprintf('\n')
    end
else
    disp("No constant inertia sources detected... continuing")
    fprintf('\n')
end

%% Basic Power Calculation

% Check for constant linear friction, convert to torque
if exist('f','var')
    for x = 1:1:size(f,2)
        disp("Constant linear force found: f = " + f(x) + "N")
        
        torque(x) = linearToRotary(f(x),r(x));
        
        disp("Constant torque for constant force " + x + " was calculated as " + torque(x) + "Nm")
        fprintf('\n')
    end
else
    disp("No constant linear force detected... continuing")
    fprintf('\n')
end

% Check for constant torque friction
if exist('tC','var')
    for x = 1:1:size(tC,2)
        disp("Constant torque found: t = " + tC(x) + "Nm")
        
        torque = [torque,tC(x)];
        fprintf('\n')
    end
else
    disp("No constant linear force detected... continuing")
    fprintf('\n')
end

% Throw error if no friction (power would be zero)
if ~exist("torque","var")
    error("No constant torque calculated... something went wrong")
end

% Calculate total torque acting on motor
torque = sum(torque) / gr;
fprintf("Total torque acting on motor calculated as %dNm \n", torque)

% Calculate total power required to overcome torque
motorvmax = vmaxrad * gr;
fprintf("Maximum motor velocity %d rad^s-1 \n", motorvmax)

power = motorvmax * torque;
fprintf("Initial motor power calculation = %dW \n", power)

%% Total Inertia Calculation

