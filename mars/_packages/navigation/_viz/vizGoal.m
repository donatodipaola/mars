%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi Agent Robotic Simulator (MARS)
%
%  vizGoals.m
%
%  Visualization of goals in the environment.
%
%-------------------------------------------------------------------------%
%
%  (c) 2009-2017 - Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function viz = vizGoal(viz, Agents)

%% MARS Function Header
global VIZ DEBUG LOG SAVE;
namespace = '_viz';
package_name = 'navigation';

%% Inherit package configuration
Package = getPackage(package_name);
if(DEBUG)
  PKG_DEBUG = Package.DEBUG;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if(VIZ)
  %% Set parameters
  %-------------------------------------------------------------------------%
  viz_acc = 100;   % visualization accuracy of circles
  viz_goal_diam = .5;   % visualization diameter of the goal
  
  %% Visualization of goal as a circle
  %-------------------------------------------------------------------------%
  for i = 1 : length(Agents)
    goal = Agents(i).Navigation.currentGoal;
    
    if(goal.isSet)
      imPose = goal.Pose.x + 1i * goal.Pose.y;
      h = imPose + viz_goal_diam * exp(1i*(0:pi/viz_acc:2*pi));
      
      patch(real(h), imag(h), Agents(i).Params.color, 'Parent', viz.axs);
    end
  end
end

return

