%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi Agent Robotic Simulator (MARS)
%
%  vizAgents.m
%
%  Visualization of agents in the environment.
%
%-------------------------------------------------------------------------%
%
%  (c) 2009-2017 - Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function viz = vizAgents(viz, Agents, sensorFlag)

%% MARS Function Header
global VIZ DEBUG LOG SAVE;
namespace = '_viz';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


n = length(Agents);
acc = 100;   % plot accuracy of circles

params_SENS_MODE = 'iso';


%% Sensing Areas
%-------------------------------------------------------------------------%
if strcmp(sensorFlag,'on')
  sens_area_color= [.8 .8 .8];
  
  if( strcmp(params_SENS_MODE,'iso') )
    for i = 1 : n
      q = Agents(i).State.Odom.x + 1i * Agents(i).State.Odom.y;
      r = Agents(i).Params.sensing_range;
      h = q + r * exp(1i*(0:pi/acc:2*pi));
      
      plot(viz.axs,real(h), imag(h), 'color',sens_area_color,'linewidth',1);
    end
  elseif( strcmp(params_SENS_MODE,'sector') )
    
    for i = 1 : n
      
      theta_s = Agents(i).State.Omom.yaw - (Agents(i).Params.sensing_angle/2) + Agents(i).Sens.Params.sensing_orientation;
      
      % Define the sector polygon
      th = 0: 2*pi/acc : Agents(i).Params.sensing_angle;
      xunit = Agents(i).Params.sensing_range * cos(th) + Agents(i).State.Odom.x;
      yunit = Agents(i).Params.sensing_range * sin(th) + Agents(i).State.Odom.y;
      P = [Agents(i).State.Odom.x xunit; Agents(i).State.Odom.y yunit];
      
      % Rotation Matrix
      R = [ cos(theta_s) -sin(theta_s); ...
        sin(theta_s) cos(theta_s)];
      % Apply the rotation to the polygon
      P = R*P;
      
      % Traslation Matrix
      T = [ones(1, size(P,2)) * Agents(i).State.Odom.x - P(1,1); ...
        ones(1, size(P,2)) * Agents(i).State.Odom.y - P(2,1)];
      % Apply the traslation to the polygon
      P = P + T;
      
      p = patch(P(1,:), P(2,:),'w', 'Parent', viz.axs);
      set(p,'FaceColor', [.95 .95 .95]);
      set(p,'FaceAlpha', .3);
      set(p,'EdgeColor',sens_area_color);
    end
  else
    dispText('error','No valid Sensing Type [SENS_MODE] value', namespace,'', mfilename());
  end
end

%% Agents as triangular vehicles
%-------------------------------------------------------------------------%
for i = 1 : n
  
  % Define the vehicle polygon
  
  % Arrow-Shape
  %   a = [-0.3536 -0.3536]';
  %   b = [.5 0]';
  %   c = [-0.3536 0.3536]';
  %   d = [-0.2 0]';
  
  % Wing-Shape
  a = [-0.4 -0.7]';
  b = [0 -0.7]';
  c = [0.7 0]';
  d = [0 0.7]';
  e = [-0.4 0.7]';
  f = [0 0]';
  
  % Scale the polygon
  P = Agents(i).Params.dim*[a b c d e f];
  
  % Rotation Matrix
  R = [ cos(Agents(i).State.Odom.yaw) -sin(Agents(i).State.Odom.yaw); ...
    sin(Agents(i).State.Odom.yaw) cos(Agents(i).State.Odom.yaw)];
  % Traslation Matrix
  T = [ones(1,size(P,2))*Agents(i).State.Odom.x; ones(1,size(P,2))*Agents(i).State.Odom.y];
  
  % Apply the roto-traslation to the polygon
  P = R*P + T;
  
  if(DEBUG)
    square_side = 1;
    AgentLabel = text(Agents(i).State.Odom.x + square_side, Agents(i).State.Odom.y - square_side, num2str(Agents(i).id));
    set(AgentLabel,'Color','k');
    set(AgentLabel,'FontSize',18);
    set(AgentLabel,'FontWeight','bold');
  end
  
  %   imPose = agents(k).State.Odom.x + 1i * agents(k).State.Odom.y;
  %   h = imPose + agents(k).Params.dim * exp(1i*(0:pi/acc:2*pi));
  %   patch(real(h), imag(h), [1 1 1], 'Parent', viz.axs);
  
  if( strcmp(Agents(i).status,'ACTIVE'))
    patch(P(1,:), P(2,:), Agents(i).Params.color, 'Parent', viz.axs);
  elseif( strcmp(Agents(i).status,'DEAD'))
    patch(P(1,:), P(2,:), [0 0 0], 'Parent', viz.axs);
  else
    patch(P(1,:), P(2,:), [0.9 0.9 0.9], 'Parent', viz.axs);
  end
end

return

