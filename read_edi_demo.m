% Demonstrates the use of the function read_edi to read the surface
% impedance data from the edi files created in the SAMTEX campaign from
% https://www.mtnet.info/data/samtex/samtex.html

% Get absolute path of this demo file
script_dir = fileparts(mfilename('fullpath'));

%% Read file in repository

edi_file = 'CPV001.edi';

% Full path of .ide file
edi_file = fullfile(script_dir,'data', edi_file);

S = read_edi(edi_file);
S











