%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi Agent Robotic Simulator (MARS)
%
%  simLoop.m
%
%  Simulation Loop: contains all updates for world and agents
%
%-------------------------------------------------------------------------%
%
%  (c) 2009-2017 - Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [SimEnv, Agents] = simLoop(SimEnv, Agents)

%% MARS Function Header
global VIZ DEBUG LOG SAVE;
namespace = '_core';

%% Timed loop
%-------------------------------------------------------------------------%
disp(' ');
dispText('msg','*** Starting INF loop ... ');
while (1) %( SimEnv.time ~= SimEnv.end_time )
  
  
  %% Centralized functions
  %-----------------------------------------------------------------------%
  Agents = centralizedUpdate(Agents);
  
  %% Decentralized functions
  %-----------------------------------------------------------------------%
  for i = 1 : length(Agents) % for each agent
    Agents(i) = decentralizedUpdate(Agents(i));
  end
  
  
  % Update the simulator status
  SimEnv = updateSimEnv(SimEnv);
  
  % Visualization Functions
  SimEnv = vizWorld(SimEnv,Agents);
  
end

return


function Agents = centralizedUpdate(Agents)

 Agents = updateNeigh(Agents);
 
return


function agent = decentralizedUpdate(agent)

if( strcmp(agent.status,'ACTIVE') )
  
  %% Update the agent strucuture
 
  agent = updateNavigation(agent);
  
  %% Move the agent in the simulated environment
  agent = moveAgent(agent);
  
  %% Update agent time
  agent.State.time = agent.State.time + 1;
  
end

return



