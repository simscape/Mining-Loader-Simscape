function [fig_h, res] = sm_mining_loader_plot6vehpos(logsoutRes, Maneuver)
% Code to plot simulation results from mining loader models
%% Plot Description:
%
% The plot below shows the path of the loader and the target trajectory.
% Note that a portion of the trajectory is performed open-loop, as the
% loader transitions from the pile to the return path.

% Copyright 2025-2026 The MathWorks, Inc.

% Reuse figure if it exists, else create new figure
figString = ['h1_' mfilename];
% Only create a figure if no figure exists
figExist = 0;
fig_hExist = evalin('base',['exist(''' figString ''',''var'')']);
if (fig_hExist)
    figExist = evalin('base',['ishandle(' figString ') && strcmp(get(' figString ', ''type''), ''figure'')']);
end
if ~figExist
    fig_h = figure('Name',figString);
    assignin('base',figString,fig_h);
else
    fig_h = evalin('base',figString);
end
figure(fig_h)
clf(fig_h)

% Get Tilt quantities
logNamesWorld = logsoutRes.get('Loader').Values.World;

veh_px = logNamesWorld.x;
veh_py = logNamesWorld.y;

plot(Maneuver.Trajectory.x.Value,...
    Maneuver.Trajectory.y.Value,...
    ':o','Color',[1 1 1]*0.4,...
    'DisplayName','Trajectory');

hold on
plot(veh_px.Data,veh_py.Data, 'LineWidth',2,...
    'DisplayName','Loader Path')
hold off
xlabel('Location (m)')
ylabel('Location (m)')
title('Vehicle Position')
legend('Location','Best')
grid on
axis equal
