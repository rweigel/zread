function S = read_ide(fnamein)
%READ_IDE Read IDE file generated by LEMI MT software
%
%  S = READ_EDI(fname) where fname is the full path of a .ide file
%
% See also READ_IDE_DEMO.

% Column labels found in file
C = {'FREQ','ZROT',...
     'ZXXR','ZXXI','ZXX_VAR','ZXYR','ZXYI','ZXY_VAR',...
     'ZYXR','ZYXI','ZYX_VAR','ZYYR','ZYYI','ZYY_VAR',...
     'TXR.EXP','TXI.EXP','TXVAR.EXP','TYR.EXP','TYI.EXP','TYVAR.EXP'};

D = importdata(fnamein,' ', 3);
D = D.data;

% Frequencies (in reverse order)
F = D(:,1);

switch size(D,2)
    case 20  % "standard" lemimt ide-format
        % Variations
        ZV(:,1) = D(:,5); % Zxx-var
        ZV(:,2) = D(:,8); % Zxy-var
        ZV(:,3) = D(:,11); % Zyx-var
        ZV(:,4) = D(:,14); % Zyy-var
        % Complex surface impedance components
        Z(:,1) = complex(D(:,3),D(:,4));  % Zxx
        Z(:,2) = complex(D(:,6),D(:,7));  % Zxy
        Z(:,3) = complex(D(:,9),D(:,10)); % Zyx
        Z(:,4) = complex(D(:,12),D(:,13));% Zyy
        % Tipper values
        TIP(:,1) = complex(D(:,15),D(:,16));  % Tx
        TIP(:,2) = complex(D(:,18),D(:,19));  % Ty
        % Tipper variations
        TIPVAR(:,1) = D(:,17);  % Tx-var
        TIPVAR(:,2) = D(:,20);  % Ty-var
    case 9  % reduced set ide format with only Z-values
        % Complex surface impedance components
        Z(:,1) = complex(D(:,2),D(:,3));  % Zxx
        Z(:,2) = complex(D(:,4),D(:,5));  % Zxy
        Z(:,3) = complex(D(:,6),D(:,7)); % Zyx
        Z(:,4) = complex(D(:,8),D(:,9));% Zyy        
end

S = struct();
S.filename = fnamein;
S.fe = F;
S.Z = Z;
switch size(D,2)
    case 20
        S.ZROT = D(:,2);
        S.ZVAR = ZV;
        S.TIP = TIP;
        S.TIPVAR = TIPVAR;
end
