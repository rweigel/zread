% Demonstrates the use of the function read_edi to read the
% surface impedance data from the edi files created in the SAMTEX campaign
% from https://www.mtnet.info/data/samtex/samtex.html

%% Read file in repository
% Full path of .ide file
edi_file = [fileparts(mfilename('fullpath')),'/data/bot201.edi'];

S = read_edi(edi_file);
S

%% Read file in https://www.mtnet.info/data/samtex/samtex.zip
% (Backup stored in git-data/zread)
% Download files if not found
ddir = [fileparts(mfilename('fullpath')),'/mtnet.info/samtex'];
if ~exist(ddir,'dir')
    url = 'https://www.mtnet.info/data/samtex/samtex.zip';
    fprintf('Downloading and extracting %s\n',url);
    mkdir(ddir);
    unzip(url,ddir);
end

edi_file = [ddir,'/Final_with_DeBeers/edi_files/KAP03/kap003.edi'];

S = read_edi(edi_file);
S