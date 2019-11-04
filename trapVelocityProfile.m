function [vp] = trapVelocityProfile(dt, t1, t2, t3, vmax)
%% Create trapezoidal velocity profile based on inputs
% Inputs:
%      x
% vmax |.. __________
%      |  /.        .\
%      | / .        . \
%    0 |/__.________.__\__ t
%       0  t1      t2  t3
%
% dt    =  timestep      / s
% t1    =  end of accel  / s
% t2    =  end of const  / s
% t3    =  end of decel  / s
% vmax  =  max velocity  / ms^-1
%
% Outputs:
% vp = time       0 ... t1 ... t2 ... t3
%      velcity    0 ...... vmax ...... 0
%
% e.g. plot(vp(1,:), vp(2,:))
%
%% Callum Morrison, 2019

t = [0, t1, t2, t3];
v = [0, vmax, vmax, 0];

vp(1,:) = [0:dt:t3];
vp(2,:) = interp1(t, v, vp(1,:));