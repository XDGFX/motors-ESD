%% INERTIA

%% Rotors
% D, d  /  m
% m     /  kg

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
r = 0.075;

%% Constant rotary
% tC     /  Nm

%% MOTOR
% Max speed
linmax = 1;                              % ms^-1
vmaxrad = (linmax / r);                  % rads^-1
vmax = (linmax / r) / (2 * pi()) * 60;   % rpm

clear linmax

%% GEARBOX
% Gear ratio
gr = 18.9;
