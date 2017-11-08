%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi Agent Robotic Simulator (MARS)
%
%  vizRefFrame.m
%
%  Visualization of the reference frame in the enrivonment
%
%-------------------------------------------------------------------------%
%
%  (c) 2009-2017 - Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function viz = vizRefFrame(viz)

%% MARS Function Header
global VIZ DEBUG LOG SAVE;
namespace = '_viz';

vector_length = 5;

plot_arrow( 0,0,0,vector_length,'linewidth',2,'color',[1 0 0] );
plot_arrow( 0,0,vector_length,0,'linewidth',2,'color',[0 1 0] );

return

function handles = plot_arrow( x1,y1,x2,y2,varargin )

if (nargin==0)
    figure;
    axis;
    set( gca,'nextplot','add' );
    for x = 0:0.3:2*pi
        color = [rand rand rand];
        h = plot_arrow( 1,1,50*rand*cos(x),50*rand*sin(x),...
            'color',color,'facecolor',color,'edgecolor',color );
        set( h,'linewidth',2 );
    end
    hold off;
    return
end


alpha       = 0.15;   % head length
beta        = 0.07;   % head width
max_length  = 22;
max_width   = 10;

if ~isempty( varargin )
    for c = 1:floor(length(varargin)/2)
        try
            switch lower(varargin{c*2-1})
                % head properties - do nothing, since handled above already
            case 'headheight',alpha = max( min( varargin{c*2},1 ),0.01 );
            case 'headwidth', beta = max( min( varargin{c*2},1 ),0.01 );
            end
        catch
            fprintf( 'unrecognized property or value for: %s\n',varargin{c*2-1} );
        end
    end
end

den         = x2 - x1 + eps;                                % make sure no devision by zero occurs
teta        = atan( (y2-y1)/den ) + pi*(x2<x1) - pi/2;      % angle of arrow
cs          = cos(teta);                                    % rotation matrix
ss          = sin(teta);
R           = [cs -ss;ss cs];
line_length = sqrt( (y2-y1)^2 + (x2-x1)^2 );                % sizes
head_length = min( line_length*alpha,max_length );
head_width  = min( line_length*beta,max_length );
x0          = x2*cs + y2*ss;                                % build head coordinats
y0          = -x2*ss + y2*cs;
coords      = R*[x0 x0+head_width/2 x0-head_width/2; y0 y0-head_length y0-head_length];


h1          = plot( [x1,x2],[y1,y2],'k' );
h2          = patch( coords(1,:),coords(2,:),[0 0 0] );
    

handles = [h1 h2];


% if no styling, this section can be removed!
if ~isempty( varargin )
    for c = 1:floor(length(varargin)/2)
        try
            switch lower(varargin{c*2-1})

             % only patch properties    
            case 'edgecolor',   set( h2,'EdgeColor',varargin{c*2} );
            case 'facecolor',   set( h2,'FaceColor',varargin{c*2} );
            case 'facelighting',set( h2,'FaceLighting',varargin{c*2} );
            case 'edgelighting',set( h2,'EdgeLighting',varargin{c*2} );
                
            % only line properties    
            case 'color'    , set( h1,'Color',varargin{c*2} );
               
            % shared properties    
            case 'linestyle', set( handles,'LineStyle',varargin{c*2} );
            case 'linewidth', set( handles,'LineWidth',varargin{c*2} );
            case 'parent',    set( handles,'parent',varargin{c*2} );
                
            % head properties - do nothing, since handled above already
            case 'headwidth',;
            case 'headheight',;
                
            end
        catch
            fprintf( 'unrecognized property or value for: %s\n',varargin{c*2-1} );
        end
    end
end
