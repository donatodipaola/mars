%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi Agent Robotic Simulator (MARS)
%
%  initPackages.m
%
%  Initialized selected packages
%
%-------------------------------------------------------------------------%
%
%  (c) 2009-2017 - Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Agents] = initPackages(Agents, SimCore)

%% MARS Function Header
global VIZ DEBUG LOG SAVE;

global Packages;
namespace = '_core';

disp(' ');
dispText('msg','*** Create Packages structure ... ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Packages Selection

% Obtain the package directories list
cd ('./_packages/');
dirs = dir(pwd);
isub = [dirs(:).isdir]; %# returns logical vector
dirList = {dirs(isub).name}';
dirList(ismember(dirList,{'.','..'})) = [];


% Build the Package structure
Packages = [];

for i = 1 : length(dirList)
  
  cd(dirList{i});
  
  % Search for the MARS_BUILD file
  if( ~isempty(dir('MARS_BUILD')) )
    
    % Initialize Packages Structure
    Pkg = [];
    Pkg.name = dirList{i};
    Pkg.id = i;
    
    Pkg.DEBUG = DEBUG;
    Pkg.LOG = LOG;
    
    Packages = [Packages Pkg];
  end
  
  cd('..');
end

cd('..');


%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Packages Initialization
for i = 1 : length(Packages)
  
  if(DEBUG)
    dispText('info',['Initialization of ', Packages(i).name, ' package ...'], namespace, '', mfilename());
  end
  
  cd(['./_packages/' Packages(i).name '/']);
  addpath(genpath(pwd));
  [Agents, Packages(i).Params] = initPackage(Agents, SimCore);
  cd('..');
  cd('..')
  
end

if(DEBUG)
  dispText('info',['N.', num2str(length(Packages)) ,' packages loaded. '], namespace, '', mfilename());
end

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


return

