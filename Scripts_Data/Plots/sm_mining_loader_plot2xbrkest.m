function [fig_h, res] = sm_mining_loader_plot2xbrkest(logsoutRes)
% Code to plot simulation results from mining loader models
%% Plot Description:
%
% The plot below shows the wheel speeds during the maneuver.  The
% rotational wheel speeds are scaled by the unloaded radius so they can be
% compared with the translational speed of the vehicle.

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

logNames = logsoutRes.getElementNames;
if(isempty(find(strcmp(logNames,'Cmd'), 1)))
    cmdVehSpd = [];
else
    cmdVehSpd = logsoutRes.get('Cmd').Values.vVeh;
end

% Get simulation results
simlog_t    = [];
simlog_vVeh = [];

% Load, Slope, Boom, Vx
simlog_t      = logsoutRes.get('Loader').Values.Vehicle.Frame.Body.vx.Time;
simlog_vVeh   = logsoutRes.get('Loader').Values.Vehicle.Frame.Body.vx.Data*3.6;
simlog_qLift  = logsoutRes.get('Loader').Values.Vehicle.Lift.H.q.Data;
simlog_mLoad  = logsoutRes.get('Loader').Values.Vehicle.Bucket.Load.Data;
simlog_qSlope = logsoutRes.find('Slope').Values.Data;

if(length(simlog_mLoad) == 1)
    simlog_mLoad = ones(size(simlog_t))*simlog_mLoad;
end

tBrk = logsoutRes.get('Loader').Values.Sensor.xBrk.Time;
xBrk = logsoutRes.get('Loader').Values.Sensor.xBrk.Data;


% Get simulation results
tco = get(gca,'defaultAxesColorOrder');

% Plot results
ah(1) = subplot(511);
stairs(tBrk, xBrk, 'LineWidth', 2,'DisplayName','Estimated Braking Distance')
title('Estimated Braking Distance')
ylabel('Distance (m)')

ah(2) = subplot(512);
plot(simlog_t, simlog_vVeh, 'LineWidth', 1,'DisplayName','Vehicle Speed')
title('Vehicle Speed')
ylabel('kph')

ah(3) = subplot(513);
plot(simlog_t, simlog_qLift, 'LineWidth', 1,'DisplayName','Lift Angle')
title('Lift Angle')
ylabel('deg')

ah(4) = subplot(514);
plot(simlog_t, simlog_qSlope, 'LineWidth', 1,'DisplayName','Vehicle Pitch')
title('Vehicle Pitch')
ylabel('deg')

ah(5) = subplot(515);
plot(simlog_t, simlog_mLoad, 'LineWidth', 1,'DisplayName','Bucket Load')
title('Bucket Load')
ylabel('kg')
xlabel('Time (s)')

linkaxes(ah,'x')
grid(ah,'on')




