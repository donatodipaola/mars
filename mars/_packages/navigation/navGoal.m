%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi Agent Robotic Simulator (MARS)
%
%  navGoal.m
%
%  update the agent's velocities towards a goal
%
%-------------------------------------------------------------------------%
%
%  (c) 2009-2017 - Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function agent = navGoal(agent)

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


%% goal-base navigation
%-------------------------------------------------------------------------%
goal = agent.Navigation.currentGoal;

if( goal.isSet )
  
  % TODO: determin if the goal is reachable
  
  % Determine goal distance and angle
  goal_dist = norm([goal.Pose.x-agent.State.Odom.x goal.Pose.y-agent.State.Odom.y]);
  theta = atan2(goal.Pose.y-agent.State.Odom.y,goal.Pose.x-agent.State.Odom.x);
  
  %
  
  theta_goal = abs(agent.State.Odom.yaw - theta);
  k_b = sign(agent.State.Odom.yaw - theta);
  
  thetaThreshold = 0.05;
  if( theta_goal > thetaThreshold )
    % Bearing adjustment
    if( theta_goal > pi)
      agent.State.CmdVel.linear = 0;
      agent.State.CmdVel.angular = k_b*agent.Navigation.Params.max_vel_angular;
      return
    else
      agent.State.CmdVel.linear = 0;
      agent.State.CmdVel.angular = -k_b*agent.Navigation.Params.max_vel_angular;
      return
    end
  else
    if(PKG_DEBUG)
      dispText('info','Bearing reached', namespace, package_name, mfilename());
    end
  end
  
  
  % Linear motion
  % Goal is not reached
  if( goal_dist > agent.Navigation.Params.goalThreshold )
    agent.State.CmdVel.linear = agent.Navigation.Params.max_vel_linear;
    agent.State.CmdVel.angular = 0;
  else
    agent.Navigation.currentGoal.isReached = 1;
    agent.Navigation.currentGoal.isSet = 0;
    agent.State.CmdVel.linear = 0;
    agent.State.CmdVel.angular = 0;
    if(PKG_DEBUG)
      dispText('info','Goal reached', namespace, package_name, mfilename());
    end
  end
  
else
  if(DEBUG)
    %  dispText('info',['No goal set for agent ' agent.id], namespace, package_name, mfilename());
  end
  
end

return
