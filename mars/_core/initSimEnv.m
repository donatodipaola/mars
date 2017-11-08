%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi Agent Robotic Simulator (MARS)
%
%  initSimEnv.m
%
%  Initialize the Simulation Environment
%
%-------------------------------------------------------------------------%
%
%  (c) 2009-2017 - Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function SimEnv = initSimEnv(SimCore)

%% MARS Function Header
global VIZ DEBUG LOG SAVE;
namespace = '_core';

%% Set simulation time
%-------------------------------------------------------------------------%
SimEnv.time = 0;
SimEnv.end_time = SimCore.Params.time_duration;


%% Set visualization structure
%-------------------------------------------------------------------------%
if (VIZ)
  SimEnv.viz = vizMain(SimCore);  % init the main window
  SimEnv.vizPause = 0.01;         % visualization pause inside the mai loop
end

%%  Initialize the data structures
%-------------------------------------------------------------------------%

% Initialization of TimeTrace Structure
for i = 1:SimCore.Params.n_a
  SimEnv.timetrace(i).t = [];
end


return