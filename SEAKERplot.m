% For Figure 1
PuBuGn = [
      0.476    0.8471    0.9176;
    0.6667    0.5882    0.8549;
    0.9882    0.7059    0.8275;];
%PuBuGn(1,:)

fig = figure;
set(fig, 'defaultAxesColorOrder', [PuBuGn(1,:); 0 0 0])

ratioStr = ["1:10", "1:1", "10:1", "100:1"] 
for i = 1:4
    subplot(2,2,i)
    plotSEAK(solution(:,5,i), solution(:,1:4,i), PuBuGn)
    title(strcat("Effector-Target ", ratioStr(i)))
end




function plotSEAK(time, ODEsys, palette)
% ODEsys is the y returned from ode45.

semilogy(time, ODEsys(:,1), 'Color', palette(3,:))
hold on
semilogy(time, ODEsys(:,2), 'Color', palette(2,:))
hold off

yyaxis left
ylim([1e2 1e7])
ylabel('Cells')
xlabel('time (h)')
xlim([0 100])

yyaxis right
semilogy(time, ODEsys(:,4), '--', 'Color', palette(1,:))
ylabel('[AMS] (nM)', 'Color', palette(1,:))
ylim([0 1e6])

legend('CTL', 'Raji', 'AMS')
plotfixer
end