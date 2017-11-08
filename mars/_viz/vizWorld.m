%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi Agent Robotic Simulator (MARS)
%
%  vizAgents.m
%
%  Visualization of agents in the environment.
%
%-------------------------------------------------------------------------%
%  
% (c) 2009-2017 - Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function SimEnv = vizWorld(SimEnv, Agents)

%% MARS Function Header
global VIZ DEBUG LOG SAVE;
namespace = '_viz';


if (VIZ)
  viz = vizClean(SimEnv.viz);
  viz = vizAgents(SimEnv.viz,Agents,'off');
  pause(SimEnv.vizPause);
end

return

