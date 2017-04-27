xL = xlim;
% line(xL, [0 0], 'Color', 'black');  %y-axis
%
% legend('Ls', 'Cs', 'L#', 'Location', 'NorthWest');
%
% h = xlabel('Time (min.)', 'FontSize', 12);
% set(h, 'Interpreter', 'latex');
% h = ylabel('Molecular Units $\cdot$ $10^{10}$', 'FontSize', 12);
% set(h, 'Interpreter', 'latex');
% h = title('Time Evolution of Surface Complex and Ligands', 'FontSize', 12);
% set(h, 'Interpreter', 'latex');
%
% axes('position',[.63 .175 .25 .25]);
%
% box on; % put box around new pair of axes
%
% xL = 0.5;
% indexOfTime = (t < xL) & (t > 0); % range of t near perturbation
% indexOfUnit = (t < xL) & (t > 0);
%
% Lsplotzoom = y(:,2);
% Ciplotzoom = y(:,3);
%
% line([0 xL], [0 0], 'Color', 'w');  %y-axis
% hold('on');
%
% plot(t(indexOfTime), Lsplotzoom(indexOfUnit));
% plot(t(indexOfTime), Ciplotzoom(indexOfUnit));
% plot(t(indexOfTime), Lipound(indexOfUnit)); % plot on new axes
% axis([-0.01, 0.2, -1, 20])
