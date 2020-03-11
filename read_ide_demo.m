%% read_ide_demo.m
% READ_IDE_DEMO Demonstrates the use of the function read_ide() for reading
% surface impedance values generated from magnetotelluric measurements
% by the lemimt program.
% 
% Pierre Cilliers, SANSA Space Science 2020-02-04

%% Input
% Full path of .ide file
ide_file = [fileparts(mfilename('fullpath')),'/data/MT_Middelpos_20120712.ide'];
m_path = [fileparts(mfilename('fullpath')),'/m/'];
addpath(m_path);

%% Read ide file
S = read_ide(ide_file);
S