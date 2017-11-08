%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi-Agent Robotic Simulator (MARS)
%
%  updateSimEnv.m
%
%  Update the simulaiton variables
%
%-------------------------------------------------------------------------%
%
%  (c) 2009-2017
%
%  Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [SimEnv] = updateSimEnv(SimEnv)

%% MASS Function Header
global VIZ DEBUG LOG SAVE;
namespace = '_core';

%% Update time
%-------------------------------------------------------------------------%
SimEnv.time = SimEnv.time + 1;


%% Update data
%-------------------------------------------------------------------------%

return
