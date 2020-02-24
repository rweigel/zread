function [ ] = MT_Z_plot(MT_site,date_str1,S,xvar,unit_type,save_plot_flag,ide_path)
% MT_Z_plot Plot of surface impedance components generated from MT data
% by the lemimt software or other software which stores it in the structure S.
%
% Author:  Robert S Weigel 2020-02-01 George Mason University, Virginia, USA
% Revision 2020-02-04 Pierre Cilliers, SANSA Space Science. changed format
%   to use tight_subplot and added options on x-axis variable and Z-value
%   units.
% 
% Functions used
%   tight_subplot
%
% local flags to select plots
    plot_Z_flag=1;   % plot Re and Im parts of surface impedance
    plot_VAR_flag=0; % plot magnitude and variance of surface impedance
    
    %% Plot 1: Real and imaginary components of surface impedance
    if plot_Z_flag
        fprintf('[MT_Z_plot] Plotting surface impedance data from MT station %s ...\n',MT_site);
        % Derive surface impedance components from Z in structure S
        freq=S.fe;
        Zxx=S.Z(:,1);
        Zxy=S.Z(:,2);
        Zyx=S.Z(:,3);
        Zyy=S.Z(:,4);

        T=1./freq;
        
        MT_site_str=MT_site;
        % replace anomalous names with '';
        ip=strfind(MT_site_str,'_');
        if ~isempty(ip)
            MT_site_str(ip)=' ';
        end
        
        % Adjust the plot units
        switch unit_type
            case {'MT','lemi'}
                units='[mV/km/nT]';
            case 'Ohms'
                units='[\Omega]';
        end

        figure
        % Set up panels for Z-plot
        % number of panels
        Nh=2;
        Nw=2;
        Nt=Nh*Nw;
        % gaps
        gap_h=0.028;  % height
        gap_w=0.075; % width
        gap=[gap_h gap_w];
        % height margins
        lower_margin=0.11;
        upper_margin=0.06;
        marg_h=[lower_margin upper_margin];
        % width margins
        left_margin=0.08;
        right_margin=0.04;
        marg_w=[left_margin right_margin];

        % set up axes gaps and margins
        hb = tight_subplot(Nh,Nw,gap,marg_h,marg_w);

        % Find y-axis limits
        z_max=round(max(max([abs(Zxx),abs(Zxy),abs(Zyx),abs(Zyy)])),1);

        % Zxx
        axis(hb(1));
        switch xvar
           case 'period'
                semilogx(hb(1),T,real(Zxx),'b',T,imag(Zxx),'r','LineWidth',2);
                xlim(hb(1),[1e0,1e5]);
           case 'freq'
                semilogx(hb(1),freq,real(Zxx),'b',freq,imag(Zxx),'r');
                xlim(hb(1),[1e-5,1e-0]);                
        end
        set(hb(1),'XtickLabel',' ');
        ylabel(hb(1),['Z_{xx} ',units]);
        ylim(hb(1),[-z_max,z_max]);
        legend(hb(1),'Re','Im','location','northwest');
    %         axis(hb(1),[1,1e5,-20,20]);
        title_str=sprintf('MT-site: %s',MT_site_str);
        title(hb(1),title_str);
        grid(hb(1),'on');

        % Zxy
        axis(hb(2));        
        switch xvar
           case 'period'        
                semilogx(hb(2),T,real(Zxy),'b',T,imag(Zxy),'r','LineWidth',2);
                xlim(hb(2),[1e0,1e5]);
            case 'freq'
                semilogx(hb(2),freq,real(Zxy),'b',freq,imag(Zxy),'r');
                xlim(hb(2),[1e-5,1e0]);
        end
        set(hb(2),'XtickLabel',' ');
        ylim(hb(2),[-z_max,z_max]);
        ylabel(hb(2),['Z_{xy}  ',units]);
        title_str=sprintf('Date: %s',date_str1);
        title(hb(2),title_str);    
        grid(hb(2),'on');
        legend(hb(2),'Re','Im','location','northwest');

        % Zyx
        axis(hb(3));        
        switch xvar
           case 'period'         
                semilogx(hb(3),T,real(Zyx),'b',T,imag(Zyx),'r','LineWidth',2)
                xlim(hb(3),[1e0,1e5]);
                xlabel(hb(3),'Period [s]');
            case'freq'
                semilogx(hb(3),freq,real(Zyx),'b',freq,imag(Zyx),'r');                
                xlim(hb(3),[1e-5,1e-2]);
                xlabel(hb(3),'Frequency [Hz]');                
        end
        ylim(hb(3),[-z_max,z_max]);
        ylabel(hb(3),['Z_{yx}  ',units]);
        grid(hb(3),'on');
        legend(hb(3),'Re','Im','location','northwest');

        % Zyy
        axis(hb(4));        
        switch xvar
           case 'period'          
                semilogx(hb(4),T,real(Zyy),'b',T,imag(Zyy),'r','LineWidth',2);
                xlim(hb(4),[1e0,1e5]);
                xlabel(hb(4),'Period [s]');
            case 'freq'
                semilogx(hb(4),freq,real(Zyy),'b',freq,imag(Zyy),'r');
                xlim(hb(4),[1e-5,1e-2]);
                xlabel(hb(4),'Frequency [Hz]');                
        end
        ylim(hb(4),[-z_max,z_max]);
        ylabel(hb(4),['Z_{yy}  ',units]);
        grid(hb(4),'on');
        legend(hb(4),'Re','Im','location','northwest');

        % adjust plot size
        set(gcf,'units','normalized');
        set(gcf,'position',[0    0.0463    1.0000    0.8667]);   

        if save_plot_flag
            cd(ide_path);
            save_file=[S.filename,'.png'];
            saveas(gcf,save_file,'png');
%             print('-dpdf',[S.filename,'.pdf']);
%             print('-dpng',[S.filename,'.png']);
        end
    end
    
    %% Plot 2: Magnitude and variation of Z vs. period
    if plot_VAR_flag
        figure
        % Zxx        
        subplot(2,2,1)
        errorbar(log10(1./S.fe),abs(S.Z(:,1)),S.ZVAR(:,1),'k');
        hold on
        grid on
        xlim([0 5]);
        ylim([0 3]);
        xlabel('log10(Period) [s]');
        ylabel(['|Zxx| ','[mV/km/nT]']);
        title([MT_site,' |Z| & VAR(Z)']);
        
        subplot(2,2,2)
        errorbar(log10(1./S.fe),abs(S.Z(:,2)),S.ZVAR(:,2),'k');        
        hold on
        grid on
        xlim([0 5]);
        ylim([0 3]);
        xlabel('log10(Period) [s]');
        ylabel(['|Zxy| ','[mV/km/nT]']);
        title(['Date: ',date_str1]);
        
        subplot(2,2,3)
        errorbar(log10(1./S.fe),abs(S.Z(:,3)),S.ZVAR(:,3),'k');         
        hold on
        grid on
        xlim([0 5]);
        ylim([0 3]);
        xlabel('log10(Period) [s]');
        ylabel(['|Zyx| ','[mV/km/nT]']);
        
        subplot(2,2,4)
        errorbar(log10(1./S.fe),abs(S.Z(:,4)),S.ZVAR(:,4),'k');  
        hold on
        grid on
        xlim([0 5]);
        ylim([0 3]);
        xlabel('log10(Period) [s]');
        ylabel(['|Zyy| ','[mV/km/nT]']);
        
        % adjust plot size
        set(gcf,'units','normalized');
        set(gcf,'position',[0    0.0463    1.0000    0.8667]);         
    end
end
