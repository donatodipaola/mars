%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi Agent Robotic Simulator (MARS)
%
%  createAgents.m
%
%  Create the network of agents
%
%-------------------------------------------------------------------------%
%
%  (c) 2009-2017 - Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Agents = createAgents(SimCore)

%% MARS Function Header
global VIZ DEBUG LOG SAVE;
namespace = '_core';

%% Create Agents structures
%
disp(' ');
dispText('msg','*** Create Agents structure ... ');

if(DEBUG)
  dispText('info',['Creating agent strutures for ', num2str(SimCore.Params.n_a), ' agents'], namespace,'', mfilename());
end


for i = 1 : SimCore.Params.n_a
  %% Set the agent Parameters
  %-----------------------------------------------------------------------%  
  Agents(i) = agent('id',i);  % Create a new agent with an identifier
  
  Agents(i).Params.color = [rand rand rand];
  
  Agents(i).Params.dim = 2;                 % agent diameter [units]  

  % Setup the communication system
  %
  if ( strcmp(SimCore.Params.comm_mode,'default') )
    Agents(i).Params.comm_range = SimCore.World.L * 2;
  else
    dispText('error','No valid Communication Mode [comm_mode] value', namespace, mfilename());
  end
  
  
  % Setup the sensing system
  %
  % Common Parameters for omogeneous robots
  Agents(i).Params.sensing_range = Agents(i).Params.dim*7;
  Agents(i).Params.sensing_angle = pi;           % Sensor's field of view
  Agents(i).Params.sensing_orientation = 0;             % FOV = [orientation - angle/2; orientation + angle/2] w.r.t. agent' frame
  
  
  if( strcmp(SimCore.Params.sens_mode,'iso') )
    Agents(i).Params.sensing_angle = 2*pi;
  elseif( strcmp(SimCore.Params.sens_mode,'sector') )
    % do nothing - maintain common parameters
  else
    dispText('error','No valid Sensing Mode [sens_mode] value', namespace, mfilename());
  end
  
  if( strcmp(SimCore.Params.sens_type,'homo') )
    % do nothing
  elseif( strcmp(SimCore.Params.sens_type,'hetero') )
    Agents(i).Params.sensing_range = Agents(i).Params.sensing_range + Agents(i).Params.sensing_range*.5*rand;
    Agents(i).Params.sensing_angle = Agents(i).Sens.sensing_angle + pi/4*randn;
    Agents(i).Params.sensing_orientation = 0; %agents(i).Sens.orientation + pi/4*randn;
  else
    dispText('error','No valid Sensing Type [sens_type] value', namespace, mfilename());
  end
  
    
  %% Set the agent State
  %-----------------------------------------------------------------------%
  Agents(i).status = 'ACTIVE';
  
  % Set the agent time
  %
  Agents(i).State.time = 0;
  
  % Set the agent odometry
  %
  Agents(i).State.Odom.x = 0;                 % x coordinate
  Agents(i).State.Odom.y = 0;                 % y coordinate
  Agents(i).State.Odom.yaw = -pi + 2*pi*rand();     % yaw
  
  if( strcmp(SimCore.Params.pos_mode,'random') ||  strcmp(SimCore.Params.pos_mode,'grid') )
    [Agents(i).State.Odom.x, Agents(i).State.Odom.y] = agentPositions(SimCore.Params.n_a, SimCore.World, Agents, SimCore.Params.pos_mode);
  else
    dispText('error','No valid Positioning Mode [pos_mode] value', namespace, mfilename());
  end
  
    
  % Set the agent velocities
  %
  Agents(i).State.CmdVel.linear =  0;                 
  Agents(i).State.CmdVel.angular = 0;                 
  
  
  % Copy the world info
  Agents(i).World = SimCore.World;

end

return


function [x_coord, y_coord] = agentPositions(n_a, World, Agents, mode)
%% Agents positioning function
%
agent_id = numel(Agents);
agent_diam = Agents(agent_id).Params.dim;
area_perc_red = 12;     % percent reduction of the positioning area

L_min = -(World.L/2) + (World.L/100*area_perc_red);
L_max = World.L/2 - (World.L/100*area_perc_red);

if( strcmp(mode,'random') )
  % Random positioning
  x_coord = L_min + (L_max - L_min)*rand;
  y_coord = L_min + (L_max - L_min)*rand;
  
  if( agent_id > 1 )
    free_position = false;
    while(free_position == false);
      x_coord = L_min + (L_max - L_min)*rand;
      y_coord = L_min + (L_max - L_min)*rand;
      
      for i = 1 : (agent_id-1)
        dist = sqrt((x_coord - Agents(i).State.Odom.x)^2 + (y_coord - Agents(i).State.Odom.y)^2);
        if dist > 7 * agent_diam
          free_position = true;
        else
          free_position = false;
          break;
        end
      end
    end
  end
elseif( strcmp(mode,'grid') )
  % Grid-like positioning
  envL_augm = World.L + 10*agent_diam;
  n_L = round(sqrt(n_a));
  agent_l = envL_augm/(n_L +1);
  
  if( mod(agent_id, n_L) == 0 )
    x_row=n_L;
    y_row=agent_id/n_L;
  else
    x_row=mod(agent_id, n_L);
    y_row=ceil(agent_id/n_L);
  end
  
  x_coord = x_row*agent_l - envL_augm/2;
  y_coord = y_row*agent_l - envL_augm/2;
  
  
end

return
