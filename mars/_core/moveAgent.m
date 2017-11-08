%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi Agent Robotic Simulator (MARS)
%
%  moveAgent.m
%
%  Move the agent according to its velocities
%
%-------------------------------------------------------------------------%
%
%  (c) 2009-2017 - Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function agent = moveAgent(agent)

%% MARS Function Header
global VIZ DEBUG LOG SAVE;
namespace = '_core';


%% Move each agent according to its velocities
%-------------------------------------------------------------------------%
    
  v = agent.State.CmdVel.linear;
  omega = agent.State.CmdVel.angular;
   
  vel_x = v*cos(agent.State.Odom.yaw);
  vel_y = v*sin(agent.State.Odom.yaw);
  dx = vel_x*agent.Navigation.Params.dt;
  dy = vel_y*agent.Navigation.Params.dt;
  
  % Position vector
  P =  [agent.State.Odom.x; agent.State.Odom.y];
  % Rotation Matrix
  R = [ cos(omega*agent.Navigation.Params.dt) -sin(omega*agent.Navigation.Params.dt); ...
    sin(omega*agent.Navigation.Params.dt) cos(omega*agent.Navigation.Params.dt)];
  % Traslation Matrix
  T = [dx; dy];
  
  % Apply the roto-traslation to the traslation velocity vector
  P = P + R*T;
  
  agent.State.Odom.x = P(1);
  agent.State.Odom.y = P(2);
  
  agent.State.Odom.yaw = mod(agent.State.Odom.yaw + omega*agent.Navigation.Params.dt, 2*pi);
  if( agent.State.Odom.yaw > pi)
     agent.State.Odom.yaw =  agent.State.Odom.yaw - 2 * pi;
  end

return