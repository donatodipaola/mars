%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi Agent Robotic Simulator (MARS)
%
%  updateNavigation.m
%
%  update the agent's velocities according to the navigation mode
%
%-------------------------------------------------------------------------%
%
%  (c) 2009-2017 - Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function agent = updateNavigation(agent)

%% MARS Function Header
global VIZ DEBUG LOG SAVE;
namespace = '_packages';
package_name = 'navigation';

%% Inherit package configuration
Package = getPackage(package_name);
if(DEBUG)
  PKG_DEBUG = Package.DEBUG;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if( strcmp(agent.Navigation.mode,'goal'))
  agent = navGoal(agent);

elseif( strcmp(agent.Navigation.mode,'goal_sim'))
  agent = navGoalSim(agent);
elseif( strcmp(agent.Navigation.mode,'wandering'))
  agent = navWandering(agent);
  
elseif( strcmp(agent.Navigation.mode,'flocking'))
  agent = navFlocking(agent);
  
elseif( strcmp(agent.Navigation.mode,'custom'))
  agent.State.CmdVel.linear = 5;
  agent.State.CmdVel.angular = .5;
  
else
  if(PKG_DEBUG)
    dispText('info','Navigation mode not set properly', namespace, package_name, mfilename());
  end
end



return




