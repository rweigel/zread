%% read_ide_demo.m
% Script to demonstrate the use of the function read_ide() for reading
%  surface impedance values generated from magnetotelluric measurements
%  by means od the function lemimt
% 
% Pierre Cilliers, SANSA Space Science 2020-02-04
close all
clear

%% Inputs
script_path='C:\Users\pjcilliers\Documents\Research\Geomagnetics\MT';
ide_data_path='c:\Users\pjcilliers\Documents\Research\Geomagnetics\MT\Data\Middelpos\';
ide_file='MT_Middelpos_20120712.ide';
addpath(script_path);

%% Read ide file
[fpath,fname,fext] = fileparts(ide_file);
fnamein = sprintf('%s%s.ide',ide_data_path,fname);
tic
S = read_ide(fnamein);
disp(S);
toc

