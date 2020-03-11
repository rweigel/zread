%% MT_Z_plot_demo.m
% MT_Z_PLOT_DEMO Script to demonstrate the use of the functions read_ide.m and MT_Z_plot.m
% 
% Pierre Cilliers, SANSA Space Science 2020-02-24
% Revision 2020-03-11 Pierre Cilliers, SANSA Space Science. changed paths to be relative to that of the calling function

close all
clear

%% Inputs to MT_Z_plot
Z_file=[fileparts(mfilename('fullpath')),'\data\MT_Middelpos_20120712.ide'];
% Z_file=[fileparts(mfilename('fullpath')),'\data\kap025.edi'];
m_path = [fileparts(mfilename('fullpath')),'\m\'];
addpath(m_path);
set(0,'DefaultAxesFontSize',18);

%% Read ide or edi file(s) in data_path
fp=strfind(Z_file,'.');
ext=Z_file(fp+1:end);
[fpath,fname,fext] = fileparts(Z_file);
switch ext
    case 'ide'
        fnamein = [fpath,'\',fname,'.ide'];
        fprintf('[MT_Z_plot_demo] Reading ide-file %s in %s ...\n',Z_file, fpath);
        S = read_ide(fnamein);
        
        % Derive input parameters from filename
        fu2=strfind(Z_file,'_');
        MT_site=Z_file(fu2(1)+1:fu2(2)-1);

        fp=strfind(Z_file,'.ide');
        date_str1=Z_file(fu2(2)+1:fp-1);        
    case 'edi'
%         fnamein = sprintf('%s%s%s.edi',fpath,bs,fname);
        fnamein = [fpath,'\',fname,'.edi'];
        fprintf('[MT_Z_plot_demo] Reading edi-file %s in %s ...\n',Z_file,fpath);
        S = read_edi(fnamein);
        
        % Derive input parameters from filename
        fp1=strfind(Z_file,'.');
        MT_site=Z_file(fp1-6:fp1-1);
        sd=dir(fnamein);
        date_num=datenum(sd.date);
        date_str1=datestr(date_num,'yyyymmdd');        
end

% Parameters to use in Z-plots
xvar='period';
units='MT';
save_plot_flag='true';

%% call MT_ide_plot
MT_Z_plot(MT_site,date_str1,S,xvar,units,save_plot_flag,fpath);