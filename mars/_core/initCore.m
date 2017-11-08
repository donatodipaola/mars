%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi Agent Robotic Simulator (MARS)
%
%  initCore.m
%
%  Initialize the core structures of the simulator
%
%-------------------------------------------------------------------------%
%
%  (c) 2009-2017 - Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function SimCore = initCore(sim_mode, user_param_name, user_param_value)

%% MARS Function Header
global VIZ DEBUG LOG SAVE;
namespace = '_core';



%% Core Setup
%-------------------------------------------------------------------------%

% Setup the simulation mode
if ( strcmp(sim_mode,'demo') )
  VIZ = 1;
  DEBUG = 0;
  LOG = 0;
  SAVE = 0;
elseif ( strcmp(sim_mode,'debug') )
  VIZ = 1;
  DEBUG = 1;
  LOG = 1;
  SAVE= 0;
elseif ( strcmp(sim_mode,'mc') )
  VIZ = 0;
  DEBUG = 0;
  LOG = 0;
  SAVE = 1;
end

% Setup paths
addpath([pwd, '/_core']);
addpath([pwd, '/_packages']);

% Setup pahts for the simulation mode
if (VIZ)
  addpath([pwd,'/_viz']);
end



%% Initialize the SimCore structure
%-------------------------------------------------------------------------%

dispText('title');
dispText('msg','*** Initialization the MARS core ... ');

% Init Structure
%
SimCore = [];

% Simulation Params
%
SimCore.Params.n_a = 7;               % Number of agents

SimCore.Params.n_exps = 50;           % Number of experiments
SimCore.Params.time_duration = 5000;   % Duration of each experiment (time iters)


SimCore.Params.eval_param_name = '#agent_fault';
SimCore.Params.eval_param_init = 1;
SimCore.Params.eval_param_delta = 1;
SimCore.Params.eval_param_final = SimCore.Params.n_a;

% User-defined parameter
%
if( nargin == 1 )
  dispText('info','No user-defined parameters init ... ', namespace,'', mfilename());
elseif( nargin == 2 )
  dispText('error','Invalid number of parameters', namespace,'', mfilename());
elseif( nargin == 3 )
  % Number of agents
  if strcmp(user_param_name, 'n_agents')
    SimCore.Params.n_a = user_param_value;
    % Number of tasks
  elseif strcmp(user_param_name, 'n_tasks')
    SimCore.Params.n_t = user_param_value;
  else
    dispText('error',['Invalid pair: (' user_param_name ', ' num2str(user_param_value) ')'], namespace,'', mfilename());
  end
end



%% Initialize agents parameters
%-------------------------------------------------------------------------%

% Agents Positioning Mode
% random    = random free position in the environment
% grid      = grid-like pattern position in the environment
%
SimCore.Params.pos_mode = 'random';

% Communication System Mode
% default   = isotropic communication area defined by a range
% os        = Olfati-Saber paper range definition
%
SimCore.Params.comm_mode = 'default';

% Sensing System Mode
% iso       = isotropic sensing area (FOV = 360??)
% sector    = sector sensing area (FOV defined by range and angle)
%
SimCore.Params.sens_mode = 'sector';

% Sensing System Type
% homo      = homogeneous angles and ranges
% hetero    = heterogeneous angles and ranges
%
SimCore.Params.sens_type = 'homo';

% Sensing System Model
% rb        = range bearing sensor model
% standard  = standard KF-model
%
SimCore.Params.sens_model = 'rb';



%% Initialize the world parameters
%-------------------------------------------------------------------------%

SimCore.World.W = 100;          % Environment dimension
SimCore.World.H = 100;
SimCore.World.L = max([SimCore.World.W SimCore.World.H]);
SimCore.World.mode = 'closed'; % closed / toroid

SimCore.World.obstacles = 0;   % 1 (on) / 0 (off)



%% Initialize the visualization parameters
%-------------------------------------------------------------------------%
SimCore.Params.viz.plotTarget = 'off';
SimCore.Params.viz.plotSensors = 'on';

return