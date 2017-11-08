%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi Agent Robotic Simulator (MARS)
%
%  vizConn.m
%
%  Visualization agents connections given the connection graph
%
%-------------------------------------------------------------------------%
%
%  (c) 2009-2017 - Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function viz = vizConn(viz, Agents)

%% MARS Function Header
global VIZ DEBUG LOG SAVE;
namespace = '_viz';

%% Parameters initialization
%-------------------------------------------------------------------------%
n = length(Agents);

%% Viz Connections
%-------------------------------------------------------------------------%
for i = 1 : n
  for k = 1 : n
    if (i~=k) && (Agents(i).Tc.G(k) == 1)
      plot(viz.axs,[Agents(i).State.x,Agents(k).State.x],...
        [Agents(i).State.y,Agents(k).State.y],'color',[0 1 0]','linewidth',1)
    end
  end
end

return

