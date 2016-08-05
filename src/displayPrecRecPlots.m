function [f, avp_views, peap_views] = displayPrecRecPlots(result)
%function [f, avp_views, peap_views] = displayPrecRecPlots(result)
%
% Save and display prec-rec curves (AP, aos,avp and peap)
%
% Inputs:
% results: detection results


close all;
fs = 18;
f = 1;
figure(f)
plot(result.pose.r,result.pose.p,'b','LineWidth',4);
hold on;
plot(result.pose.r,result.pose.p_aos,'g','LineWidth',4);
plot(result.pose.r,result.pose.p_avp15,'r','LineWidth',4);
plot(result.pose.r_peap30,result.pose.p_peap15,'k','LineWidth',4);
axis([0 1 0 1]); grid on
xlabel('recall', 'fontsize', fs)
ylabel('precision', 'fontsize', fs)
legend(sprintf('AP = %.4f', result.pose.ap),sprintf('AOS = %.4f', result.pose.aos),...
    sprintf('AVP (pi/12) = %.4f', result.pose.avp15), sprintf('PEAP (pi/12) = %.4f', ...
    result.pose.peap15),'Location','SouthEast');

f = f + 1;
hold off;

figure(f)
plot(result.pose.r,result.pose.p,'b','LineWidth',4);
hold on;
plot(result.pose.r,result.pose.p_avp_bins(:,1),'g','LineWidth',4);
plot(result.pose.r,result.pose.p_avp_bins(:,2),'y','LineWidth',4);
plot(result.pose.r,result.pose.p_avp_bins(:,3),'Color', [0.2 0.3 0.4],'LineWidth',4);
plot(result.pose.r,result.pose.p_avp_bins(:,4),'Color', [0.7 0.1 0.4],'LineWidth',4);
axis([0 1 0 1]); grid on
xlabel('recall', 'fontsize', fs)
ylabel('precision', 'fontsize', fs)
legend(sprintf('AP = %.4f', result.pose.ap),sprintf('AVP (4 views) = %.4f', result.pose.avp_bin(1)), ...
    sprintf('AVP (8 views) = %.4f', result.pose.avp_bin(2)), ...
    sprintf('AVP (16 views) = %.4f', result.pose.avp_bin(3)), ...
    sprintf('AVP (24 views) = %.4f', result.pose.avp_bin(4)));

avp_views(1) = result.pose.avp_bin(1);
avp_views(2) = result.pose.avp_bin(2);
avp_views(3) = result.pose.avp_bin(3);
avp_views(4) = result.pose.avp_bin(4);

f = f + 1;
hold off;

figure(f)
plot(result.pose.r,result.pose.p,'b','LineWidth',4);
hold on;
plot(result.pose.r_peap_bins(:,1),result.pose.p_peap_bins(:,1),'g','LineWidth',4);
plot(result.pose.r_peap_bins(:,2),result.pose.p_peap_bins(:,2),'y','LineWidth',4);
plot(result.pose.r_peap_bins(:,3),result.pose.p_peap_bins(:,3),'Color', [0.2 0.3 0.4],'LineWidth',4);
plot(result.pose.r_peap_bins(:,4),result.pose.p_peap_bins(:,4),'Color', [0.7 0.1 0.4],'LineWidth',4);
axis([0 1 0 1]); grid on
xlabel('recall', 'fontsize', fs)
ylabel('precision', 'fontsize', fs)
legend(sprintf('AP = %.4f', result.pose.ap), sprintf('PEAP (4 views) = %.4f', result.pose.peap_bin(1)), ...
    sprintf('PEAP (8 views) = %.4f', result.pose.peap_bin(2)), ...
    sprintf('PEAP (16 views) = %.4f', result.pose.peap_bin(3)), ...
    sprintf('PEAP (24 views) = %.4f', result.pose.peap_bin(4)));

peap_views(1) = result.pose.peap_bin(1);
peap_views(2) = result.pose.peap_bin(2);
peap_views(3) = result.pose.peap_bin(3);
peap_views(4) = result.pose.peap_bin(4);