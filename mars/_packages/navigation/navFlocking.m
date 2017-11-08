%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi Agent Robotic Simulator (MARS)
%
%  navFlocking.m
%
%  update the agent's velocities to obtain flocking behavior
%
%-------------------------------------------------------------------------%
%
%  (c) 2009-2017 - Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function agent = navFlocking(agent)

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


%% flocking with virtual potential field navigation
%-------------------------------------------------------------------------%

Vx = agent.State.CmdVel.linear*cos(agent.State.Odom.yaw);
Vy = agent.State.CmdVel.linear*sin(agent.State.Odom.yaw);

%-----------------------------------------------------------------------%
% Mean of neighbooring headings (vicsek-like model)

omega_mean=0;

if  ~isempty(agent.Navigation.Neigh)
  meanYaw = agent.State.Odom.yaw;
  for j = 1 : length(agent.Navigation.Neigh)
    
    meanYaw = meanYaw + agent.Navigation.Neigh(j).Pose.yaw ;
  end
  noise = 0;
  omega_mean = getAnglePI((meanYaw/(length(agent.Navigation.Neigh) + 1)) + noise);
  
end

%-----------------------------------------------------------------------%
% Repulsion forces

Fx_rep =0;
Fy_rep =0;

k = 80000;
p = 4;

for j = 1:length(agent.Navigation.Neigh)
  dist_ij= sqrt((agent.State.Odom.x - agent.Navigation.Neigh(j).Pose.x)^2 + (agent.State.Odom.y -agent.Navigation.Neigh(j).Pose.y)^2);
  if(dist_ij < 4*agent.Params.dim )
    f_rep = k / dist_ij^p;
    
    theta = pi + atan2(agent.Navigation.Neigh(j).Pose.y - agent.State.Odom.y, agent.Navigation.Neigh(j).Pose.x - agent.State.Odom.x);
    if( theta > pi)
      theta =  theta - 2 * pi;
    end
    
    f_x_rep = f_rep * cos(theta);
    f_y_rep = f_rep * sin(theta);
    
    Fx_rep = Fx_rep + f_x_rep;
    Fy_rep = Fy_rep + f_y_rep;
  end
end


%-----------------------------------------------------------------------%
% Border forces

Fx_bor =0;
Fy_bor =0;

B =20;
lambda = 8;
k = 80000;

x_min = -agent.World.L/2;
x_max = agent.World.L/2;
y_min = -agent.World.H/2;
y_max = agent.World.H/2;


if agent.State.Odom.x > x_max - B
  dist_r = abs(agent.State.Odom.x - x_max);
  fr_bor = k /(dist_r)^lambda;
  Fx_bor = Fx_bor - fr_bor;
end
if agent.State.Odom.x < x_min + B
  dist_l = abs(agent.State.Odom.x - x_min);
  fl_bor = k / (dist_l)^lambda;
  Fx_bor = Fx_bor + fl_bor;
end

if agent.State.Odom.y > y_max - B
  dist_t = abs(agent.State.Odom.y - y_max);
  ft_bor = k / (dist_t)^lambda;
  Fy_bor = Fy_bor - ft_bor;
end
if agent.State.Odom.y < y_min + B
  dist_b = abs(agent.State.Odom.y - y_min);
  fb_bor = k / (dist_b)^lambda;
  Fy_bor = Fy_bor + fb_bor;
end



%-----------------------------------------------------------------------%
% Global forces

Fx = Fx_rep + Fx_bor;
Fy = Fy_rep + Fy_bor;

Vx_1 = Vx;
Vy_1 = Vy;

Vx = Vx + Fx*agent.Navigation.Params.dt;
Vy = Vy + Fy*agent.Navigation.Params.dt;

agent.State.CmdVel.linear = agent.Navigation.Params.max_vel_linear;
agent.State.CmdVel.angular = 0;

% Vicsek
if (~isempty(agent.Navigation.Neigh))
  agent.State.CmdVel.angular = (omega_mean - agent.State.Odom.yaw)/ agent.Navigation.Params.dt;
end

% Virtual Potential
if (Fx ~= 0 || Fy ~= 0 )
  agent.State.CmdVel.linear = sqrt(Vx^2+Vy^2);
  omega =  getAnglePI(atan2(Vy-Vy_1,Vx-Vx_1) - agent.State.Odom.yaw);
  agent.State.CmdVel.angular = omega/ agent.Navigation.Params.dt;
end

% Velocities saturation
if ( agent.State.CmdVel.linear > agent.Navigation.Params.max_vel_linear )
  agent.State.CmdVel.linear = agent.Navigation.Params.max_vel_linear;
end

if ( abs(agent.State.CmdVel.angular) > agent.Navigation.Params.max_vel_angular )
  agent.State.CmdVel.angular =  sign(agent.State.CmdVel.angular)*agent.Navigation.Params.max_vel_angular;
end

return

function angle = getAnglePI(angle)

while( angle > pi )
  angle = angle - 2*pi;
end

while( angle < -pi )
  angle = angle + 2*pi;
end

return
