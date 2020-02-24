%% read_edi_demo.m
% READ_EDI_DEMO Script to demonstrate the use of the function read_edi
%  to read the surface impedance data from the edi files created in the SAMTEX campaign
%  data-source: https://www.mtnet.info/data/samtex/samtex.html
clear
close all

%% Inputs
script_path='c:\Users\pjcilliers\Documents\Research\Geomagnetics\MT\';
data_path='c:\Users\pjcilliers\Documents\Research\Geomagnetics\MT\Data\SAMTEX\';
edi_file='CPV001.edi';

%% Initialize
addpath(script_path);
cd(data_path);

%% Read ide file
[fpath,fname,fext] = fileparts(edi_file);
fnamein = sprintf('%s%s.edi',data_path,fname);
tic
fprintf('[read_SAMTEX_edi_demo] Reading SAMTEX edi file %s ...\n',edi_file);
S = read_edi(fnamein);
disp(S);
toc
