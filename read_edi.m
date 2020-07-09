function S = read_edi(fnamein)
%READ_EDI To read SAMTEX EDI Files
%
%  Function to read data from SAMTEX Magnetotellurometer surface impedance
%  files with the extension *.edi as available on
%  https://www.mtnet.info/data/samtex/samtex.html
%
%  The EDI format is documented at 
%  http://www.mtnet.info/docs/ediformat.txt
%  https://seg.org/Portals/0/SEG/News%20and%20Resources/Technical%20Standards/seg_mt_emap_1987.pdf
%  
%  Other (probably more general) MATLAB code for reading EDI files is 
%  available in load_edi.tar.gz at
%  https://sites.ualberta.ca/~unsworth/codes/codes_index.html
%
%  S = READ_EDI(fname) where fname is the full path of a .edi file
%
%  Output: Structure S with fields e.g.
%     filename: '/tmp/zread/data/bot201.edi'
%       coords: [-27.0386 27.4167 1444] ; [lat, lon, altitude]
%           fe: [47x1 double]  frequencies
%         ZROT: [47x1 double]  Rotation
%            Z: [47x1 double]  Tensor components of surface impedance [Zxx,Zxy,Zyx,Zyy] complex numbers [mV/km/nT]
%           ZV: [47x4 double]  Variations of magnitudes [Zxx_var,Zxy_var,Zyx_var,Zyy_var];
%          TIP: [47x2 double]  Tipper values [TX,TY] complex numbers
%       TIPVAR: [47x2 double]  Variations in tipper values [TXVAR,TYVAR]
%
%  Note: Some edi-files do not have Tipper values
%
%  Author: Pierre Cilliers, SANSA Space Science, Hermanus, South Africa
%
%  See also READ_EDI_DEMO, READ_IDE.
			     
    m_path = [fileparts(mfilename('fullpath')),'/m/'];
    addpath(m_path);

    m_path = [fileparts(mfilename('fullpath')),'/m/'];
    addpath(m_path);

    % initialize counters and fields
    ip=1;
    NFREQ=[];
    
    % Field labels found in edi file
    C = {'FREQ','ZROT',...
         'ZXXR','ZXXI','ZXX.VAR','ZXYR','ZXYI','ZXY.VAR',...
         'ZYXR','ZYXI','ZYX.VAR','ZYYR','ZYYI','ZYY.VAR',...
         'TXR.EXP','TXI.EXP','TXVAR.EXP','TYR.EXP','TYI.EXP','TYVAR.EXP'};
    % Structure with all fields in edi file
    P = struct();
    % Initialize all fields of P
    for ic=1:20
        eval(sprintf('P.%s=[];',C{ic}));
    end
    % re-initialize field counter ic
    ic=1;
    test_str1='NFREQ=';
    
    S = struct();
    S.filename = fnamein;
    % default type
    S.type = 'zfile';
    
    % read edi-file as text into file of char
    D = asciiread(fnamein);

    while ip<size(D,1)
        tline=D(ip,:);
        % find if the file contains SPECTA lines
        if ~isempty(strfind(tline,'>SPECTRA')) % Not a Z-file
           S.type='spect';
           return
        % find coordinate lines
        elseif ~isempty(strfind(tline,'REFLAT')) % Read latitude
            fc=strfind(tline,'=');
            lat_str=tline(fc+1:end);
            latitude = dms2dd(lat_str);
            %fprintf('Latitude = %5.2f \n',latitude);            
        elseif ~isempty(strfind(tline,'REFLONG')) % Read longitude
            fc=strfind(tline,'=');
            lon_str=tline(fc+1:end);
            longitude = dms2dd(lon_str);
            %fprintf('Longitude = %5.2f \n',longitude);
        elseif ~isempty(strfind(tline,'REFELEV')) % Read altitude
            fc=strfind(tline,'=');
            elv_str=tline(fc+1:end);
            altitude = str2double(elv_str);
            %fprintf('Altitude = %5.2f m\n',altitude);
        end
        % find number of frequencies
        if isempty(NFREQ)
            if ~isempty(strfind(tline,test_str1)) % Read number of frequencies                
                fc=strfind(tline,'=');
                freq_str=tline(fc+1:end);
                NFREQ = str2double(freq_str);
                %fprintf('NFREQ = %i \n',NFREQ);
            end
        else % read all the remaining parameters in the edi-file
            if ~isempty(strfind(tline,C{ic})) % Read parameter C{ic}
                [P,ic,ip]=read_field(P,C,D,ic,ip,NFREQ);                
            end
        end
        ip=ip+1;
        if ic>numel(C)
            break
        end
    end
    % Coordinates
    S.coords=[latitude,longitude,altitude];
    % Frequencies
    S.fe = P.FREQ;
    % Rotation
    S.ZROT = P.ZROT;
    % Complex surface impedance components
    Z = zeros(NFREQ,4);
    Z(:,1) = complex(P.ZXXR,P.ZXXI);  % Zxx
    Z(:,2) = complex(P.ZXYR,P.ZXYI);  % Zxy
    Z(:,3) = complex(P.ZYXR,P.ZYXI);  % Zyx
    Z(:,4) = complex(P.ZYYR,P.ZYYI);  % Zyy 
    S.Z = Z;
    % Variations
    ZV=zeros(NFREQ,4);
    ZV(:,1) = P.ZXX.VAR; % Zxx-var
    ZV(:,2) = P.ZXY.VAR; % Zxy-var
    ZV(:,3) = P.ZYX.VAR; % Zyx-var
    ZV(:,4) = P.ZYY.VAR; % Zyy-var
    S.ZV=ZV;
    % Tipper values (if available)
    if ~isempty(P.TXR.EXP)
        TIP=zeros(NFREQ,2);
        TIP(:,1) = complex(P.TXR.EXP,P.TXI.EXP);  % Tx
        TIP(:,2) = complex(P.TYR.EXP,P.TYI.EXP);  % Ty
        S.TIP = TIP;
        % Tipper variations
        TIPVAR=zeros(NFREQ,2);
        TIPVAR(:,1) = P.TXVAR.EXP;  % Tx-var
        TIPVAR(:,2) = P.TYVAR.EXP;  % Ty-var
        S.TIPVAR = TIPVAR;
    end
end

function [P,ic,ip]=read_field(P,C,D,ic,ip,NFREQ)
    ZV=[];
    Nv=0;
    while Nv<NFREQ
        ip=ip+1;
        zscan=textscan(D(ip,:),'%f');
        zv=cell2mat(zscan);
        Nv=Nv+numel(zv);
        ZV=[ZV;zv];
    end
    eval(sprintf('P.%s=ZV;',C{ic}));
    ic=ic+1;
end

function ddd=dms2dd(s)
% DMS2DD convert latitude or longitude from string +dd:mm:ss to decimal degrees
    ddd=[];
    fp=strfind(s,':');
    % check if first character is '-'
    sgn_found=strcmp(s(1),'-') | strcmp(s(1),'+');
    if sgn_found
        sgn = s(1);
        dd=s(2:fp(1)-1);
    else
        sgn='+';
        dd=s(1:fp(1)-1);
    end
    mm=s(fp(1)+1:fp(2)-1);
    ss=s(fp(2)+1:end);
    ddd=eval([dd,'+',mm,'/60+',ss,'/3600']);
    switch sgn
        case '-'
            ddd=-ddd;
    end
end
