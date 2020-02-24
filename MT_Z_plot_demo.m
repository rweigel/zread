%% MT_Z_plot_demo.m
% Script to demonstrate the use of the functions read_ide.m and MT_Z_plot.m
% 
% Pierre Cilliers, SANSA Space Science 2020-02-24
close all
clear

%% Inputs to MT_Z_plot
script_path='C:\Users\pjcilliers\Documents\Research\Geomagnetics\MT';
ide_data_path='c:\Users\pjcilliers\Documents\Research\Geomagnetics\MT\Data\Middelpos\';
ide_file='MT_Middelpos_20120712.ide';
addpath(script_path);
set(0,'DefaultAxesFontSize',18);

%% Read ide file(s) in data_path
[fpath,fname,fext] = fileparts(ide_file);
fnamein = sprintf('%s%s.ide',ide_data_path,fname);
fprintf('[MT_Z_plot_demo] Reading ide-file %s in %s ...\n',ide_file, ide_data_path);
S = read_ide(fnamein);

% Derive input parameters from filename
fu2=strfind(ide_file,'_');
MT_site=ide_file(fu2(1)+1:fu2(2)-1);

fp=strfind(ide_file,'.ide');
date_str1=ide_file(fu2(2)+1:fp-1);

% Parameters to use in Z-plots
xvar='period';
units='MT';
save_plot_flag='true';

%% call MT_ide_plot
MT_Z_plot(MT_site,date_str1,S,xvar,units,save_plot_flag,ide_data_path);
