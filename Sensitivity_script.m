clear all

g = [0.0866, %CTL growth const
    0.0193, %Raji growth const
    79.8, %CTL killing const
    8.8e6, %carrying capacity
    0.05 %AMS fractional killing rate (%/hr)
    ];

[t,y,dydg]=sens_sys('diffSEAKER',[0 100],[1e7; 1e6],[],g);
%tspan [0 100]
%E:T - 10:1 (1e7/1e6)
%% 


% For Figure 1
PuBuGn = [
      0.476    0.8471    0.9176;
    0.6667    0.5882    0.8549;
    0.9882    0.7059    0.8275;];
%PuBuGn(1,:)


titleStr = ["CTL Growth Constant", "Raji Growth Constant", "CTL Killing Constant", "Carrying Capacity", "AMS Killing Rate"] 
labels  = ["(a)", "(b)", "(c)", "(d)", "(e)"]

for i=1:5
    subplot(2,3,i)
    plotSens(t, dydg(:,:,i), PuBuGn)
    title(strcat("Sens to ", titleStr(i)))
    text(0.9,0.15, labels(i),'Units', 'Normalized', 'VerticalAlignment', 'Top')
    plotfixer
end


function plotSens(time, traces, palette)
% ODEsys is the y returned from ode45.

plot(time, traces(:,1), 'Color', palette(3,:))
hold on
plot(time, traces(:,2), 'Color', palette(2,:))
hold off
ylabel('dCells')
xlabel('time (h)')
xlim([0 100])

legend('dCTL', 'dRaji')

end
