function S = read_edi(fnamein)
% Function to read data from SAMTEX Magnetotellurometer surface impedance files with the extension *.edi
%   as available on https://www.mtnet.info/data/samtex/samtex.html
%
% Date: 2020-02-29
% Author:  Pierre Cilliers, SANSA Space Science, Hermanus, South Africa
%
% Inputs: fnamein = name of input file with full path
% Output: Structure S with fields
%     filename: 'c:\Users\pjcilliers\Documents\Research\Geomagnetics\MT\Data\SAMTEX\bot201.edi'
%       coords: [-27.0386 27.4167 1444] ; [lat, lon, altitude]
%           fe: [47×1 double]  frequencies
%         ZROT: [47×1 double]  Rotation
%            Z: [47×4 double]  Tensor components of surface impedance [Zxx,Zxy,Zyx,Zyy] complex numbers [mV/km/nT]
%           ZV: [47×4 double]  Variations of magnitudes [Zxx_var,Zxy_var,Zyx_var,Zyy_var];
%          TIP: [47×2 double]  Tipper values [TX,TY] complex numbers
%       TIPVAR: [47×2 double]  Variations in tipper values [TXVAR,TYVAR]

    % initialize counters and fields
    ip=1;
    NFREQ=[];
    
    % derive filename and path to edi file
    [fpath,fname,fext] = fileparts(fnamein);
    bs='\';
    fnamein = sprintf('%s%s%s.edi',fpath,bs,fname);    

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
    
    % read edi-file as text into file of char
    D = asciiread(fnamein);

    while ip<size(D,1)
        tline=D(ip,:);
        % find coordinate lines
        if contains(tline,'LATITUDE') % Read latitude
            T = textscan(tline,'%s %s %f');
            latitude = T{3};
            fprintf('Latitude = %5.2f \n',latitude);
        elseif contains(tline,'LONGITUDE') % Read longitude
            T = textscan(tline,'%s %s %f');
            longitude = T{3};
            fprintf('Longitude = %5.2f \n',longitude);
        elseif contains(tline,'ELEVATION') % Read altitude
            T = textscan(tline,'%s %s %f');
            altitude = T{3};
            fprintf('Altitude = %5.2f m\n',altitude);
        end
        % find number of frequencies
        if isempty(NFREQ)
            if contains(tline,test_str1) % Read number of frequencies                
                T = textscan(tline,'%s %f');
                NFREQ = T{2};
                fprintf('NFREQ = %i \n',NFREQ);
                nlines=ceil(NFREQ/5);  % number of lines to read for each field
            end
        else % read all the remaining parameters in the edi-file
            if contains(tline,C{ic}) % Read parameter C{ic}
                [P,ic,ip]=read_field(P,C,D,ic,ip,nlines);
            end
        end
        ip=ip+1;
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
    % Tipper values
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

function [P,ic,ip]=read_field(P,C,D,ic,ip,nlines)
    ZV=[];
    for it=1:nlines
        ip=ip+1;
        zscan=textscan(D(ip,:),'%f');
        zv=cell2mat(zscan);
        ZV=[ZV;zv];
    end
    eval(sprintf('P.%s=ZV;',C{ic}));
    ic=ic+1;
end
