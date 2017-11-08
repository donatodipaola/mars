%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi Agent Robotic Simulator (MARS)
%
%  appendConfig.m
%
%  Append package configuration to the Agents strucuture
%
%-------------------------------------------------------------------------%
%
%  (c) 2009-2017 - Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function Agents = appendConfig(Agents, PkgParams)

%% MARS Function Header
global VIZ DEBUG LOG SAVE;
namespace = '_packages';
package_name = 'navigation';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Setup global objects
%-------------------------------------------------%




%% Setup package structure
%-------------------------------------------------%

Navigation.Params = PkgParams;

Navigation.mode ='flocking';

Navigation.Path = [];

Navigation.currentGoal.id = 0;
Navigation.currentGoal.isSet = 0; % 0=not set | 1=set

Navigation.currentGoal.Pose.x = 0;
Navigation.currentGoal.Pose.y = 0;
Navigation.currentGoal.Pose.yaw = 0;

Navigation.currentGoal.isReached = 0; % 0=not reached yet | 1=reached | -1 =unreachable

Navigation.Neigh = [];

%% Update Agent structure
%-------------------------------------------------%

for i=1:length(Agents)
  Agents(i).Navigation = Navigation;
end

return