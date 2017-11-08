%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi Agent Robotic Simulator (MARS)
%
%  getPackage.m
%
%  get package strucutre from Packages vector given the package name
%
%-------------------------------------------------------------------------%
%
%  (c) 2009-2017 - Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function package = getPackage(package_name)

%% MARS Function Header
global VIZ DEBUG LOG SAVE;
global Packages;

namespace = '_core';

for i = 1 : length(Packages)
  if( strcmp(Packages(i).name,package_name) )
    package = Packages(i);
  end
end

return