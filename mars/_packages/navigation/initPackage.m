%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi Agent Robotic Simulator (MARS)
%
%  initPackage.m
%
%  Initialize the package 
%
%-------------------------------------------------------------------------%
%
%  (c) 2009-2017 - Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [Agents, PkgParams] = initPackage(Agents, SimCore)

%% MARS Function Header
global VIZ DEBUG LOG SAVE;

global Packages;
namespace = '_packages';
package_name = 'navigation';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Package configuration 
%-----------------------------------%
cd('..');
Package = getPackage(package_name);
Package.DEBUG = 0;
Package.LOG = 0;
Packages = setPackage(Package,Packages);
cd(package_name);


%% Package parameters setup
%-----------------------------------%

% goal-based navigation params
PkgParams.goalThreshold= 1;    % Inner radius of the goal

% motion control params
PkgParams.max_vel_linear = 5;      % Agent max linear velocity [units/s]
PkgParams.max_vel_angular = 2;      % Agent max angular velocity [rad/s]
PkgParams.dt = 0.04;                % Motion controller time Step


%% Append package configuration to the Agents strucuture
%-----------------------------------%
Agents = appendConfig(Agents, PkgParams);  

return


