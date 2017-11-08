%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi-Agent Robotic Simulator (MARS)
%
%  agent.m
%
%  Agent structure declaration
%
%-------------------------------------------------------------------------%
%
%  (c) 2009-2017
%
%  Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function a = agent(varargin)

%% MARS Function Header
global VIZ DEBUG LOG SAVE;
namespace = '_core';

%% Agent struct
%
a = struct('id'        , -1,...        
  'status'             , 'IDLE',...
  'Params'             , [],...       % Agent's parameters
  'State'              , [],...      % Agent's dynamic variables
  'World'              , []);
%% Inputs Handler
%
if mod(nargin,2) == 0
  % even # of inputs, given as ('param','value') pairs
  % e.g. 'name', '14QB', 'id', 11 ...
  ii = 1;
  while ii < nargin
    try
      a = setfield(a,varargin{ii},varargin{ii+1});
    catch
      dispText('error',['Invalid pair: (' varargin{ii} ', ' varargin{ii+1} ')'], namespace, mfilename());
    end
    ii = ii + 2;
  end
else
  dispText('error','Inputs must be paired, e.g. a = agent(''name'', ''James'', ''id'', 007)', namespace, mfilename());
end

return
