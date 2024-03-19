function [output]=elapsed_min_time(d1,i1,a1,d2,i2,a2)
%input data:
% direction data 1:
% d1: declination 1 in decimal degrees.
% i1: inclination 1 in decimal degrees.
% a1: alpha95 1 in decimal degrees.
% direction data 2:
% d2: declination 1 in decimal degrees.
% i2: inclination 1 in decimal degrees.
% a2: alpha95 1 in decimal degrees.
%output data:
% table with the elapsed minimum time at:
% mode (most often value), 95%, 68%, for two paleoreconstructions
% and for the toy-model.
% Figure with the elapsed minimum times.


% STEP 1, PDF1 of the angular deviation between both directions.
omega = .1:.1:25;
PDF1  = pdf1(d1,i1,a1,d2,i2,a2);  %one pdf

% STEP 2, PDF2 of the two paleoreconstructions and toy-model
t = 0:14e3; %maximum time of evaluation
PDF2a = pdf2('SHA.DIF.14k');  %one pdf per omega
PDF2b = pdf2('ArchKalmag14k'); %one pdf per omega
PDF2c = pdf2('toy'); %one pdf per omega

%STEP 3, combination of PDF1 and PDF2
PDF3a = PDF1*PDF2a/sum(PDF1);
PDF3b = PDF1*PDF2b/sum(PDF1);
PDF3c = PDF1*PDF2c/sum(PDF1);

%Output Table
time = [
    t(PDF3a==max(PDF3a)), intersection(t, PDF3a, 95), intersection(t, PDF3a, 68); %SHA.DIF.14k
    t(PDF3b==max(PDF3b)), intersection(t, PDF3b, 95), intersection(t, PDF3b, 68); %ArchKalmag14k
    t(PDF3c==max(PDF3c)), intersection(t, PDF3c, 95), intersection(t, PDF3c, 68)  %toy
];
time = 5.*round(time/5); %round to multiples of five

%Figure
figure('WindowState', 'maximized')
tiledlayout(2,2, 'TileSpacing','compact')
nexttile
plot(omega, PDF1, '-b', 'LineWidth',3)
grid on; box on;
xlabel('\Omega [º]')
ylabel('PDF')
title('Angular deviation between the pair of directions')
set(gca, 'FontSize', 14)

PDF3 = [PDF3a; PDF3b; PDF3c];
position_text = [.8 .3 .8; .8 .3 .3];
titles = ["SHA.DIF.14k", "ArchKalmag14k", "toy"];
for i = 1:3
    nexttile
    hold on
    plot(t, PDF3(i,:), '-k', 'LineWidth',3)
    plot([time(i,1) time(i,1)],[0 PDF3(i,t==time(i,1))],'--', 'Color', "#D95319", 'LineWidth',2)
    plot([time(i,2) time(i,2)],[0 PDF3(i,t==time(i,2))],'--', 'Color', "#7E2F8E", 'LineWidth',2)
    plot([time(i,3) time(i,3)],[0 PDF3(i,t==time(i,3))],'--', 'Color', "#A2142F", 'LineWidth',2)
    xlim([0 t(find(PDF3(i,:)>=max(PDF3(i,:)/10),1, 'last'))])
    ylim([0 max(PDF3(i,:))])
    grid on; box on;
    xlabel('\Deltat_{min} [yr]')
    ylabel('PDF')
    title('Results for '+titles(i)+' model')
    annotation('textbox', [position_text(1,i) position_text(2,i) .1 .1], 'String', 'Mode = '+string(time(i,1))+' yr', 'Color', "#D95319",'fontweight', 'bold' , 'fontsize', 14)
    annotation('textbox', [position_text(1,i) position_text(2,i)-.05 .1 .1], 'String', 'at 95% = '+string(time(i,2))+' yr', 'Color', "#7E2F8E",'fontweight', 'bold', 'fontsize', 14)
    annotation('textbox', [position_text(1,i) position_text(2,i)-.1 .1 .1], 'String', 'at 68% = '+string(time(i,3))+' yr', 'Color', "#A2142F",'fontweight', 'bold' , 'fontsize', 14)
    set(gca, 'FontSize', 14)
    output(i,:)=time(i,:);
end
h=gcf;
set(h,'PaperOrientation','landscape');
print(gcf,'-dpdf','Figure_output.pdf','-fillpage');
save output.dat output -ascii
return


%%%%%%%%%%%%%%
function pdf = pdf1(d1,i1,a1,d2,i2,a2)
    n=1e8;%number of data in the bootstrap.
    a1=57.3*a1/140;
    a2=57.3*a2/140;
    ed1=a1/cosd(i1);ei1=a1;
    ed2=a2/cosd(i2);ei2=a2;
    D1=d1+ed1*randn(n,1);
    D2=d2+ed2*randn(n,1);
    I1=i1+ei1*randn(n,1);
    I2=i2+ei2*randn(n,1);
    omega=acosd(cosd(I1).*cosd(I2).*cosd(D1-D2)+sind(I1).*sind(I2));
    pdf = hist(omega, .1:.1:25)/(0.1*length(omega));
return

function pdfs = pdf2(model)
    table = load('table_data.dat');
    if isequal(model, 'SHA.DIF.14k')
        table = table(:,1:3);
    elseif isequal(model, 'ArchKalmag14k')
        table = [table(:,1),table(:,4:5)];
    elseif isequal(model, 'toy')
        table = [table(:,1),table(:,6:7)];
    end
    omega = table(:,1);
    mu = table(:,2);
    sigma = table(:,3);
    table = interp1(omega, [mu sigma], .1:0.1:25, 'spline', 'extrap');
    table = [round((.1:0.1:25)',1) table];
    omega = .1:.1:25;
    tev = 0:14e3;
    pdfs = zeros(length(omega), length(tev));
    for i = 1:length(omega)
        pdfs(i, :) = lognpdf(tev, table(i,2), table(i,3));
    end
return

function tmin = intersection(t, z, gp)
    area = [];
    areat = trapz(t, z);
    for ti = t(2:end-1)
        areai = trapz(t(t>=ti), z(t>=ti));
        area = [area, areai/areat];
    end  
    intersection = find(area<=gp/100,1);
    tmin = t(intersection);
return
