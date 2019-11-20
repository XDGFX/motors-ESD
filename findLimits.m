%% IMPORTANT! Edit calculate.mlx in the following two ways otherwise this function will not work
% line 1          |  inputs to function become > 'accelTime, decelTime'
% lines 92 & 95   |  comment out
% line 246 to 278 |  comment out

% System parameters
motorPeak = 8.5;
motorStall = 1.27;

% Initial guesses for accel and decel time
accelTime = 0.01:0.01:0.5;
decelTime = 0.01:0.01:0.5;

% First tune the acceleration
for n = 1:1:length(accelTime)
    [accelTorque(n), ~, torqueRMS(n)] = calculate(accelTime(n), 0.2);
end

for n = 1:length(accelTorque)
    diff(n) = min([(motorPeak - abs(accelTorque(n))), (4 * abs(torqueRMS(n)) - abs(accelTorque(n)))]);
end

clf

hold on
plot(accelTime, diff)
accelTime = interp1(diff, accelTime, 0);

% Then the deceleration
for n = 1:1:length(decelTime)
    [~, decelTorque(n), torqueRMS(n)] = calculate(accelTime, decelTime(n));
end

for n = 1:length(accelTorque)
    diff(n) = min([(motorPeak - abs(decelTorque(n))), (4 * abs(torqueRMS(n)) - abs(decelTorque(n)))]);
end

plot(decelTime, diff)
decelTime = interp1(diff, decelTime, 0);

if peakTorque > 4 * torqueRMS
    error("Peak torque larger than 4 x RMS torque")
elseif peakTorque > motorPeak
    error("Peak torque larger than motor can supply") 
end

while torqueRMS > motorStall
    fprintf("RMS Torque too high! Trying to correct...")
    accelTime = accelTime + 0.01;
    decelTime = decelTime + 0.01;
    [accelTorque, decelTorque, torqueRMS] = calculate(accelTime, decelTime);
end

ylabel("Distance from limit torque (due to motor peak or 4 * rms)")

ylim([-5 10])

legend(["Acceleration Torque / Nm", "Deceleration Torque / Nm"])
xlabel("time / s")

grid minor

[accelTorque, decelTorque, torqueRMS] = calculate(accelTime, decelTime);

peakTorque = max([accelTorque decelTorque]);