%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi Agent Robotic Simulator (MARS)
%
%  setPackage.m
%
%  set package strucutre in the Packages vector
%
%-------------------------------------------------------------------------%
%
%  (c) 2009-2017 - Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Packages = setPackage(package, Packages)

%% MARS Function Header
global VIZ DEBUG LOG SAVE;

namespace = '_core';

for i = 1 : length(Packages)
  if( strcmp(Packages(i).name,package.name) )
    Packages(i) = package;
  end
end

return