%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Multi-Agent Robotic Simulator (MARS)
%
%  dispText.m
%
%  Display a text within the MARS framework
%
%-------------------------------------------------------------------------%
%
%  (c) 2009-2017
%
%  Donato Di Paola
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dispText(text_type, text, name_space, package_name, file_name)

%% MARS Function Header
global VIZ DEBUG LOG SAVE;
namespace = '_core';

%% Text Display
%-------------------------------------------------------------------------%

if( strcmp(text_type,'title') )
  disp('-----------------------------------------------------------');
  disp('|           Multi-Agent System Simulator (MARS)           |');
  disp('-----------------------------------------------------------');
  disp(' ');
  
elseif( strcmp(text_type,'msg') )
  disp(text);
  
elseif( strcmp(text_type,'info') )
  disp(['MARS/', name_space,'/',package_name, ' :: ', file_name, ' | ', text]);
  
elseif( strcmp(text_type,'error') )
  error(['MARS/', name_space,'/',package_name, ' :: ', file_name, ' | ',text]);
  
else
  error(['MARS/',namespace,':: ', mfilename(), ' - No valid text selection [text_type]']);
end


%% Log line save
%-------------------------------------------------------------------------%

if(LOG)
  % write the line to file
end

end

