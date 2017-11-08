%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi Agent Robotic Simulator (MARS)
%
%  initDEMO_Flocking.m
%
%  Updates packages variables with the DEMO configuration
%
%-------------------------------------------------------------------------%
%
%  (c) 2009-2017 - Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Agents = initDEMO_Flocking(Agents)

%% MARS Function Header
global VIZ DEBUG LOG SAVE;
global Packages;
namespace = '_demo';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% core
dispText('info','Set ''core'' parameters...', namespace, '', mfilename());

for i = 1 : length(Agents)
  Agents(i).State.CmdVel.linear = 10;
  Agents(i).State.CmdVel.angular = 0;
end


%% navigation
dispText('info',['Set ''navigation'' package parameters...'], namespace, '', mfilename());
Package = getPackage('navigation');
Package.DEBUG = 0;
Packages = setPackage(Package,Packages);

for i = 1 : length(Agents)
  Agents(i).Navigation.mode = 'flocking';
end


return