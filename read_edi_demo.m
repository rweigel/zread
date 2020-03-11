%% read_edi_demo.m
% READ_edi_DEMO Demonstrates the use of the function read_edi to read the surface
% impedance data from the edi files created in the SAMTEX campaign from
% https://www.mtnet.info/data/samtex/samtex.html

%% Input
% Full path of .ide file
edi_file = [fileparts(mfilename('fullpath')),'/data/bot201.edi'];
m_path = [fileparts(mfilename('fullpath')),'/m/'];
addpath(m_path);

%% Read edi file
S = read_edi(edi_file);
S