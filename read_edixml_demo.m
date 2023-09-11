
fname = 'VAQ58bc_FRDcoh.xml';
fname = fullfile(fileparts(mfilename('fullpath')),'data','misc',fname);

[D, S] = read_edixml(fname)