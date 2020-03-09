function D = asciiread( File, Size )
% Function to read ASCII data into a character matrix
%    D = asciiread( File, Size )
% Input Arguments:
%    File = File name
% Optional Input Arguments:
%    Size = Return selected elements [Rows,Cols], default [inf,inf]
% Output Arguments:
%    D     = ASCII file stored as character matrix
%
% Example. Read first four columns of ASCII file
%    Sites = asciiread('./data/sitelists/IGS_NORTH.sites',[Inf,4]);
%
% See also
% ----------------------------------------------------------------------------
if nargin == 1; Size = []; end

D = []; if ~exist(File,'file'); fprintf('%s not found\n',File); return; end

% Chunk decoding settings for large files
Bytes = 25E6;  % Bytes to handle in a single go 
Line  = 1024;  % Maximum characters in a line

try
   f = dir(File); 
   if f.bytes < Bytes
      D = char(textread(File,'%s','delimiter','\n','whitespace',''));
   else % Decode in Bytes chunks
      fp = fopen(File,'r'); d = []; D  = {};  
      while ~feof(fp)
         d = [d;fread(fp,Bytes,'uint8=>uint8')];
         i = find(flipud(d(end-Line:end))==sprintf('\n'));
         if isempty(i), i = 0; end
         D{end+1} = char(strread(char(d(1:end-i(1))),'%s','delimiter','\n','whitespace',''));
         if i(1)<2, d = []; else d = d(end-i(1)+2:end); end
      end
      D{end+1} = char(strread(char(d),'%s','delimiter','\n','whitespace',''));
      fclose(fp); clear('d');
      D = strvcat(D);
   end

   if ~isempty(Size), D = D(1:min([size(D,1),Size(1)]),1:min([size(D,2),Size(2)])); end

catch
   fprintf('Warning from asciiread.m: ');
   if ~exist(File,'file'); fprintf('%s not found\n',File); return; end
   Err = lasterror; fprintf('%s\n',Err.message);
end

