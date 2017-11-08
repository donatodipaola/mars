%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi Agent Robotic Simulator (MARS)
%
%  navWandering.m
%
%  update the agent's velocities for random directions
%
%-------------------------------------------------------------------------%
%
%  (c) 2009-2017 - Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function agent = navWandering(agent)

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


%% wandering navigation
%-------------------------------------------------------------------------%
x = getRandState(agent);
k = 0.5;

agent.State.CmdVel.linear = sqrt(x(2)^2 + x(4)^2);
agent.State.CmdVel.angular = k*(atan2(x(4), x(2)) - agent.State.Odom.yaw)/agent.Navigation.Params.dt;

if( abs(agent.State.CmdVel.angular) > agent.Navigation.Params.max_vel_angular )
  agent.State.CmdVel.angular = sign(agent.State.CmdVel.angular) * agent.Navigation.Params.max_vel_angular;
end

return

function x = getRandState(agent)

%% Olfati-Saber paper motion model
sigma_0 = 5;
dt = agent.Navigation.Params.dt;

c1 = 0.75;
c2 = 1;
a = 18;

w = sigma_0*randn(2,1);

x = [agent.State.Odom.x  agent.State.CmdVel.linear*cos(agent.State.Odom.yaw) agent.State.Odom.y  agent.State.CmdVel.linear*sin(agent.State.Odom.yaw)]';

M = [mu(x(1), a) 0; 0 mu(x(3), a)];
F1 = [1 dt; 0 1];
F2 = [1 dt; -dt*c1 1-dt*c2];

Gi = [ (dt^2*sigma_0)/2; dt*sigma_0];
zero = [0; 0];

A = [M(1,1)*F1 M(1,2)*F1; M(2,1)*F1 M(2,2)*F1] + [(1-M(1,1))*F2  (-M(1,2))*F2; (-M(2,1))*F2 (1-M(2,2))*F2];
B = [Gi zero; zero Gi];

x = A*x + B*w;

return

function y =  mu(z,a)

y = (sigma(a+z) + sigma(a-z)) / 2;

return

function y = sigma(z)

if z >= 0
  
  y = 1;
  
else
  
  y = -1;
  
end


return

