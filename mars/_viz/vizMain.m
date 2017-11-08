%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi Agent Robotic Simulator (MARS)
%
%  vizMain.m
%
%  Setup the main visualization object.
%
%-------------------------------------------------------------------------%
%
%  (c) 2009-2017 - Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function viz = vizMain(SimCore)
%% MARS Function Header
global VIZ DEBUG LOG SAVE;
namespace = '_viz';


%% Window/World Parameters initialization
%-------------------------------------------------------------------------%

winPosX  = 200;
winPosY  = 100;

winSizeX = 800;
winSizeY = 800;

xmin = -SimCore.World.L/2;
xmax = SimCore.World.L/2;
ymin = -SimCore.World.L/2;
ymax = SimCore.World.L/2;


%% Figure set up
%-------------------------------------------------------------------------%

viz.f = figure(); clf;
set(viz.f,'name','MARS','numbertitle','off')
set(viz.f,'doublebuffer','on','position',[winPosX winPosY winSizeX winSizeY],'color',[1 1 1]);

viz.axs = axes('position',[.1 .1 .8 .8]);
set(viz.axs,'box','on','nextplot','add','xlim',[xmin xmax],'ylim',[ymin ymax],...
  'xtick',[],'ytick',[],'plotboxaspectratio',[(xmax-xmin) (ymax-ymin) 1]);

return

