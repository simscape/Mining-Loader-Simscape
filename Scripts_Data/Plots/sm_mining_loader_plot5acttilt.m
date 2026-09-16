function [fig_h, res] = sm_mining_loader_plot5acttilt(logsoutRes)
% Code to plot simulation results from mining loader models
%% Plot Description:
%
% This function plots actuator quantities, including position and force or
% torque.  It looks at the recorded quantities to determine which form of
% actuation was used, and creates the appropriate plot.

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
logNamesTilt = logsoutRes.get('Loader').Values.Vehicle.Tilt;

hinge_q   = logNamesTilt.H.q;
hinge_trq = logNamesTilt.H.trq;
act_p     = logNamesTilt.A.p;
act_f     = logNamesTilt.A.force;

% Create plot based on results
if(isscalar(act_f.Data))
    plotType = "HingeActuation";
elseif(isscalar(hinge_trq.Data))
    plotType = "CylinderActuation";
end

switch plotType
    case "HingeActuation"
        ah(1) = subplot(311);
        plot(hinge_q.Time,hinge_q.Data, 'LineWidth',1)
        ylabel('Angle (deg)')
        title('Tilt Hinge Angle')
        grid on

        ah(2) = subplot(312);
        plot(hinge_trq.Time,hinge_trq.Data, 'LineWidth',1)
        ylabel('Torque (N*m)')
        title('Tilt Hinge Actuation Torque')
        grid on

        ah(3) = subplot(313);
        plot(act_p.Time,act_p.Data, 'LineWidth',1)
        ylabel('Position (m)')
        title('Tilt Actuator Extension')
        xlabel('Time (s)')
        grid on

    case "CylinderActuation"
        ah(1) = subplot(311);
        plot(hinge_q.Time,hinge_q.Data, 'LineWidth',1)
        ylabel('Angle (deg)')
        title('Tilt Hinge Angle')
        grid on

        ah(2) = subplot(312);
        plot(act_p.Time,act_p.Data, 'LineWidth',1)
        ylabel('Position (m)')
        title('Tilt Actuator Extension')
        grid on

        ah(3) = subplot(313);
        plot(act_f.Time,act_f.Data, 'LineWidth',1)
        ylabel('Force (N)')
        title('Tilt Actuator Force')
        xlabel('Time (s)')
        grid on
end

linkaxes(ah,'x')





