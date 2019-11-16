function [] = calculate(mt)
%% Calculations script for motors coursework
%
% Takes input in form of motors table to select most sutable motor
%
%% Callum Morrison, 2019

%% --- VARIABLES ---

%% INERTIA

%% Rotors
% D, d  /  m
% m     /  kg

% Driving roller radius
r = 0.075;

% Transmission Pulley
D(1) = 0;
d(1) = 0;
m(1) = 0;

% Driving Roller
D(2) = 0.15;
d(2) = 0.15; %% Unknown
m(2) = 3.57;

% Driven Roller
D(3) = 0.15;
d(3) = 0.15; %% Unknown
m(3) = 3.57;

% Tension Roller
D(4) = 0.1;
d(4) = 0.1; %% Unknown
m(4) = 2.04;

%% Linear momentum
% mL    /  kg

% Belt
mL(1) = 27.23;

% Box empty
mL(2) = 0.545;

% Box full
mL(3) = 7.645;

%% Constant sources of inertia
% iC    /  kgm^2

% Motor
iC(1) = 0;


%% FRICTION
%% Constant linear
% f     /  N
% r     /  m

% Belt
f(1) = 250;

%% Constant rotary
% tC     /  Nm


%% VELOCITY PROFILE
% Max speed of driving rotor
% v = r * omega
linmax = 1; %v                           % ms^-1

% --- DO NOT EDIT ---
vmaxrad = linmax / r; % omega            % rads^-1
vmax = vmaxrad * 60 / (2 * pi());        % rpm
clear linmax
% -------------------

% Time variables in the form
% [startAccel, stopAccel, startDecel, stopDecel]
t = [0, 2, 5, 7];

%% GEARBOX
% Initial gear ratio
gr = 18.9;

%% --- END OF VARIABLES ---
%% NO NEED TO EDIT BELOW THIS LINE

% Output separator
sz = get(0, 'CommandWindowSize');
br = "\n" + join(repmat("-", sz(1), 1), "") + "\n\n";
clear sz

fprintf(br)

% Check for input table
if ~exist("mt", "var")
    error("No motors table detected, please use form 'calculate(motorsTable)'")
end

%% Initialise nested variables
inertiaAtMotor = 0;
constTorque = 0;
power = 0;

%% Inertia Calculations
inertiaCalc

%% Basic Power Calculation
powerCalc

%% Motor Selection
% Initial motor speed
motorSuitable = zeros(height(mt), 1);

% Loop through all motors
for x = 1:height(mt)
    
    fprintf("Testing motor %d\n", x)
    
    %    motorSpeed = input("Please enter an initial motor speed to test (rpm): ");
    %    motorTorque = input("Please enter the stall torque for this motor (Nm): ");
    
    motorPower(x) = mt.("rpm")(x) * 2 * pi() / 30 * mt.("torqueStall")(x);
    
    fprintf("Using motor speed of %.0frpm \n", mt.("rpm")(x))
    fprintf("Using motor stall torque of %.2fNm \n", mt.("torqueStall")(x))
    
    if motorPower(x) > power
        fprintf("Motor (%dW) IS more powerful than required power %dW \n", round(motorPower(x)), power)
        motorSuitable(x) = 1;
        
        fprintf(br)
        
    elseif motorPower(x) <= power
        fprintf("ERROR: Motor (%dW) IS NOT powerful enough (required %dW) \n", round(motorPower(x)), power)
        motorSuitable(x) = 0;
        
        fprintf(br)
        
    end
end

if motorSuitable ~= 1
    error("No suitable motors!")
end

fprintf("%d motors are suitable from the table of %d", sum(motorSuitable), height(mt))

fprintf(br)

fprintf("Converting motor table inertia from kgcm^2 to kgm^2")
mt.("inertia")(:) = mt.("inertia")(:) / 10000;

fprintf(br)

% if ~exist("motorPeakTorque", "var")
%     motorPeakTorque = input("Please enter the peak torque for this motor in Nm: ");
% end
% 
% fprintf("Motor peak torque set as %d \n", motorPeakTorque)
% 
% if ~exist("motorName", "var")
%     motorName = input("Please enter an identifying name for the selected motor: ", 's');
% end
% fprintf("Motor name set as %s \n", motorName)

fprintf(br)

% Calculate required gear ratio using selected motor
gr = motorSpeed / vmax;

fprintf("New required gear ratio calculated as %.2f\n", gr)

% Assume 100% efficiency until otherwise specified
mechEfficiency = 1;

if lower(input("Would you like to find a suitable gearbox at this time? Y/N: ", "s")) == "y"
    
    inertiaOfGearbox = input("Please enter the inertia for this gearbox in kgcm^s: ");
    inertiaOfGearbox = inertiaOfGearbox / 10000;
    fprintf("Gearbox inertia set as %d kgm^2 \n", inertiaOfGearbox)
    
    iC = [iC, inertiaOfGearbox];
    
    mechEfficiency = mechEfficiency*input("Please enter the efficiency for this gearbox (0% 0-1 100%): ");
    fprintf("Mechanical efficiency now set as %d\n", mechEfficiency)
    
else
    fprintf("Not adding gearbox values at this time... \n")
end

fprintf("Re-calculating inertia using new gear ratio... \n")

% Inertia will change with a different gear ratio
inertiaCalc

% Conversely, power will not change. Although gr is now different, speed is
% different proportionally, resulting in the same amount of work done (this
% makes sense; the output is the same as before)

%% Calculate non-steady state torque!
% Constant torque is assumed to be 100% at any speed - as this is worst
% case scenario

fprintf("Assume constant torque %.2fNm is 100%% at any speed!\n\n", constTorque)
fprintf("Using inertia at motor as %dkgm^2\n", inertiaAtMotor)

% Case 1: Acceleration
dt = t(2) - t(1);

fprintf("Acceleration: change in angular velocity of %drads^-1 in %ds \n", vmaxrad, dt)
accelTorque = (constTorque + inertiaAtMotor * (vmaxrad / dt)) / mechEfficiency;
fprintf("Required acceleration torque calculated as %.2fNm \n", accelTorque)

% Case 2: Deceleration
dt = t(4) - t(3);

fprintf("Deceleration: change in angular velocity of -%drads^-1 in %ds \n", vmaxrad, dt)
decelTorque = (constTorque + inertiaAtMotor * (-vmaxrad / dt)) / mechEfficiency;
fprintf("Required deceleration torque calculated as %.2fNm \n", decelTorque)

%% Calculate RMS and Peak Torque

if motorPeakTorque > max([accelTorque, decelTorque])
    fprintf("Motor peak torque (%.2f) is greater than required peak (%.2f)\n", motorPeakTorque, max([accelTorque, decelTorque]))
else
    fprintf("Motor peak torque (%.2f) is LOWER than required peak (%.2f)\n", motorPeakTorque, max([accelTorque, decelTorque]))
    error("Restart with a new motor...")
end

% Calculate RMS torque, where Tcycle = t(4)
torqueRMS = sqrt(1 / t(4) * (t(2) * accelTorque^2 + (t(3) - t(2)) * constTorque^2 + (t(4) - t(3)) * decelTorque ) );
fprintf("RMS Torque calculated as %.2f", torqueRMS)

%% NESTED FUNCTIONS

%% Inertia Calculations
    function inertiaCalc
        inertia = [];
        
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
                
                fprintf(br)
            end
        else
            fprintf("No rotors detected... continuing\n")
            
            fprintf(br)
        end
        
        
        
        % For linear inertia
        if exist('mL','var')
            for x = 1:1:size(mL,2)
                fprintf("Linear 'inertia' source found: m = " + mL(x) + "kg\n")
                fprintf("Using driving radius: %d\n", r)
                fprintf("Converting to inertia: I = %.2f", mL(x) * r^2)
                
                fprintf(br)
                
                % Approximate linear inertia as point mass at driven roller radius
                % I = mr^2
                % 'inertia' variable is affected by gearbox
                
                inertia = [inertia, mL(x) * r^2];
            end
        else
            fprintf("No linear 'inertia' sources detected... continuing\n")
            
            fprintf(br)
        end
        
        
        
        % Calculate inertia before and after bearbox
        fprintf('Converting inertia after gearbox to inertia before gearbox...\n')
        inertia = sum(inertia);
        fprintf('Total inertia after gearbox (opposite side to motor) calculated as %d\n', inertia)
        inertiaAtMotor = inertia / gr^2;
        fprintf('Total inertia before gearbox (same side as motor) calculated as %d, using a gear ratio of %.0f\n', inertiaAtMotor, gr)
        
        fprintf(br)
        
        % Additional inertia not affected by gearbox (i.e. motor)
        if exist('iC','var')
            for x = 1:1:size(iC,2)
                fprintf("Constant inertia source found: i = %d kgm^s \n", iC(x))
                fprintf('This will not be affected by gear ratio!\n')
                
                inertiaAtMotor = inertiaAtMotor + iC(x);
                
                fprintf(br)
            end
        else
            fprintf("No constant inertia sources detected... continuing\n")
            fprintf(br)
        end
        
        fprintf('Total inertia seen by the motor is now %d kgm^s \n', inertiaAtMotor)
        fprintf(br)
        
        
    end

%% Power Calculations
    function powerCalc
        % Check for constant linear friction, convert to torque
        
        constTorque = [];
        if exist('f', 'var')
            for x = 1:1:size(f,2)
                fprintf("Constant linear force found: f = " + f(x) + "N\n")
                
                constTorque(x) = linearToRotary(f(x),r(x));
                
                fprintf("Constant torque for constant force " + x + " was calculated as " + constTorque(x) + "Nm\n")
                
                fprintf(br)
            end
        else
            fprintf("No constant linear force detected... continuing\n")
            
            fprintf(br)
        end
        
        
        
        % Check for constant torque friction
        if exist('tC', 'var')
            for x = 1:1:size(tC,2)
                fprintf("Constant torque found: t = " + tC(x) + "Nm\n")
                
                constTorque = [constTorque, tC(x)];
                
                fprintf(br)
            end
        else
            fprintf("No constant linear force detected... continuing\n")
            
            fprintf(br)
        end
        
        % Throw error if no friction (power would be zero)
        if ~exist("constTorque","var")
            error("No constant torque calculated... something went wrong\n")
        end
        
        
        % Calculate total torque acting on motor
        constTorque = sum(constTorque) / gr;
        fprintf("Total torque acting on motor calculated as %dNm, using gear ratio %d \n", constTorque, gr)
        
        fprintf(br)
        
        % Calculate total power required to overcome torque
        motorvmax = vmaxrad * gr;
        fprintf("Maximum driving roller velocity %d rad^s-1\n", vmaxrad)
        fprintf("Maximum motor velocity %d rad^s-1, using gear rato %d \n", motorvmax, gr)
        
        fprintf(br)
        
        power = motorvmax * constTorque;
        fprintf("Initial motor power calculation = %.2fW \n", power)
        
        fprintf(br)
    end

end
