%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi Agent Robotic Simulator (MARS)
%
%  updateNeigh.m
%
%  update information about agent's neighboors
%
%-------------------------------------------------------------------------%
%
%  (c) 2009-2017 - Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Agents = updateNeigh(Agents)

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


radius =  1.5*Agents(1).Params.sensing_range;

for i = 1 : length(Agents) 
  Agents(i).Navigation.Neigh = [];
  for j = 1 : length(Agents) 
    if (i~= j)
      dist= sqrt((Agents(i).State.Odom.x - Agents(j).State.Odom.x)^2 + (Agents(i).State.Odom.y - Agents(j).State.Odom.y)^2);
      if( dist < radius)
        Neigh.id = Agents(j).id;
        Neigh.Pose.x = Agents(j).State.Odom.x;
        Neigh.Pose.y = Agents(j).State.Odom.y;
        Neigh.Pose.yaw = Agents(j).State.Odom.yaw;
        Agents(i).Navigation.Neigh = [Agents(i).Navigation.Neigh Neigh];
      end
    end
  end
end

return
