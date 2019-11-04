function [] = calculate()
%% Calculations script for motors coursework
%% Callum Morrison, 2019

% Load variables from other file
fprintf("Loading variables...\n")
variables
fprintf("Variables loaded\n")

% Output separator
sz = get(0, 'CommandWindowSize');
br = "\n" + join(repmat("-", sz(1), 1), "") + "\n\n";
clear sz

fprintf(br)

%% Inertia Calculations

% For rotors
if exist('D','var')
    for x = 1:1:size(D,2)
        fprintf("Rotor no. " + x + " uses variables:\n")
        fprintf("D = %d \n", D(x))
        fprintf("d = %d \n", d(x))
        fprintf("m = %d \n", m(x))
        
        % 'inertia' variable is affected by gearbox
        inertia(x) = inertiaRotor(D(x), d(x), m(x));
        
        fprintf("Inertia for rotor %d was calculated as %d kgm^s\n", x, inertia(x))
    end
else
    fprintf("No rotors detected... continuing\n")
end

fprintf(br)

% For linear inertia
if exist('mL','var')
    for x = 1:1:size(mL,2)
        fprintf("Linear 'inertia' source found: m = " + mL(x) + "kg\n")
        
        % Approximate linear inertia as point mass at driven roller radius
        % 'inertia' variable is affected by gearbox
        inertia = [inertia, mL(x) * r^2];
    end
else
    fprintf("No linear 'inertia' sources detected... continuing\n")
end

fprintf(br)

% Calculate inertia before and after bearbox
fprintf('Converting inertia after gearbox to inertia before gearbox...\n')
inertia = sum(inertia);
fprintf('Total inertia after gearbox calculated as %d\n', inertia)
inertiaMotor = inertia / gr^2;
fprintf('Total inertia before gearbox calculated as %d, using a gear ratio of %.0f\n', inertiaMotor, gr)

fprintf(br)

% Additional inertia not affected by gearbox (i.e. motor)
if exist('iC','var')
    for x = 1:1:size(iC,2)
        fprintf("Constant inertia source found: i = %d kgm^s \n", iC(x))
        fprintf('This will not be affected by gear ratio!\n')
        
        inertiaMotor = inertiaMotor + iC(x);
        
        fprintf('\n')
    end
else
    fprintf("No constant inertia sources detected... continuing\n")
end

fprintf('Total inertia seen by the motor is now %d kgm^s \n', inertiaMotor)

fprintf(br)

%% Basic Power Calculation
% Check for constant linear friction, convert to torque
if exist('f','var')
    for x = 1:1:size(f,2)
        fprintf("Constant linear force found: f = " + f(x) + "N\n")
        
        torque(x) = linearToRotary(f(x),r(x));
        
        fprintf("Constant torque for constant force " + x + " was calculated as " + torque(x) + "Nm\n")
    end
else
    fprintf("No constant linear force detected... continuing\n")
end

fprintf(br)

% Check for constant torque friction
if exist('tC','var')
    for x = 1:1:size(tC,2)
        fprintf("Constant torque found: t = " + tC(x) + "Nm\n")
        
        torque = [torque,tC(x)];
    end
else
    fprintf("No constant linear force detected... continuing\n")
end

% Throw error if no friction (power would be zero)
if ~exist("torque","var")
    error("No constant torque calculated... something went wrong\n")
end

fprintf(br)

% Calculate total torque acting on motor
torque = sum(torque) / gr;
fprintf("Total torque acting on motor calculated as %dNm \n", torque)

% Calculate total power required to overcome torque
motorvmax = vmaxrad * gr;
fprintf("Maximum motor velocity %d rad^s-1 \n", motorvmax)

power = motorvmax * torque;
fprintf("Initial motor power calculation = %dW \n", power)

fprintf(br)

%% Motor Selection
% Initial motor speed
happy = 0;
while happy ~= 1
    motorSpeed = input("Please enter an initial motor speed to test (rpm): ");
    motorTorque = input("Please enter the stall torque for this motor (Nm): ");
    
    motorPower = motorSpeed * 2 * pi() / 30 * motorTorque;
    
    if motorPower > power
        fprintf("Motor (%dW) is more powerful than required power %dW \n", round(motorPower), power)
        fprintf("Using motor speed of %.0frpm \n", motorSpeed)
        fprintf("Using motor stall torque of %.2fNm \n", motorTorque)
        
        happy = input("Are you happy with the above selection? Y/N: ", "s");
        
        % Convert to logical, sets anything not "Y" as false
        happy = lower(happy) == "y";
        
        if happy == 0
            fprintf("Returning to motor selection...\n")
        end
        
    elseif motorPower <= power
        fprintf("\nERROR: Motor (%dW) is not powerful enough (required %dW) \n", round(motorPower), power)
        fprintf("ERROR: Returning to motor selection...\n")
        
        fprintf(br)
        
    end
end

fprintf("Motor selected successfully: %dW, %drpm, %.2fNm stall torque\n", round(motorPower), motorSpeed, motorTorque)

fprintf(br)

motorName = input("Please enter an identifying name for the selected motor: ", 's');
fprintf("Motor name set as %s \n", motorName)

fprintf(br)
