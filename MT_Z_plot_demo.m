%% MT_Z_plot_demo.m
% Script to demonstrate the use of the functions read_ide.m and MT_Z_plot.m
% 
% Pierre Cilliers, SANSA Space Science 2020-02-24
close all
clear

%% Inputs to MT_Z_plot
script_path='C:\Users\pjcilliers\Documents\Research\Geomagnetics\MT';
% Z_file_path='c:\Users\pjcilliers\Documents\Research\Geomagnetics\MT\Data\Middelpos\';
Z_file_path='c:\Users\pjcilliers\Documents\Research\Geomagnetics\MT\Data\SAMTEX\';
% Z_file='MT_Middelpos_20120712.ide';
Z_file='kap025.edi';
addpath(script_path);
set(0,'DefaultAxesFontSize',18);

%% Read ide or edi file(s) in data_path
fp=strfind(Z_file,'.');
ext=Z_file(fp+1:end);
[fpath,fname,fext] = fileparts(Z_file);
switch ext
    case 'ide'
        fnamein = sprintf('%s%s.ide',Z_file_path,fname);
        fprintf('[MT_Z_plot_demo] Reading ide-file %s in %s ...\n',Z_file, Z_file_path);
        S = read_ide(fnamein);
        
        % Derive input parameters from filename
        fu2=strfind(Z_file,'_');
        MT_site=Z_file(fu2(1)+1:fu2(2)-1);

        fp=strfind(Z_file,'.ide');
        date_str1=Z_file(fu2(2)+1:fp-1);        
    case 'edi'
        fnamein = sprintf('%s%s.edi',Z_file_path,fname);
        fprintf('[MT_Z_plot_demo] Reading edi-file %s in %s ...\n',Z_file, Z_file_path);
        S = read_edi(fnamein);
        
        % Derive input parameters from filename
        fp1=strfind(Z_file,'.');
        MT_site=Z_file(1:fp1-1);
        sd=dir(fnamein);
        date_num=datenum(sd.date);
        date_str1=datestr(date_num,'yyyymmdd');        
end



% Parameters to use in Z-plots
xvar='period';
units='MT';
save_plot_flag='true';

%% call MT_ide_plot
MT_Z_plot(MT_site,date_str1,S,xvar,units,save_plot_flag,Z_file_path);