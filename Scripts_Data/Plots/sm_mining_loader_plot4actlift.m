function [fig_h, res] = sm_mining_loader_plot4actlift(logsoutRes)
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

% Get Lift quantities
logNamesLift = logsoutRes.get('Loader').Values.Vehicle.Lift;

hinge_q   = logNamesLift.H.q;
hinge_trq = logNamesLift.H.trq;
actL_p    = logNamesLift.L.p;
actL_f    = logNamesLift.L.force;
actR_p    = logNamesLift.R.p;
actR_f    = logNamesLift.R.force;

% Create plot based on results
if(isscalar(actL_f.Data) && isscalar(actR_f.Data))
    plotType = "HingeActuation";
elseif(isscalar(hinge_trq.Data) && isscalar(actR_f.Data))
    plotType = "LeftActuation";
elseif(isscalar(hinge_trq.Data) && ~isscalar(actR_f.Data))
    plotType = "LeftRightActuation";
end

switch plotType
    case "HingeActuation"
        ah(1) = subplot(311);
        plot(hinge_q.Time,hinge_q.Data, 'LineWidth',1)
        ylabel('Angle (deg)')
        title('Lift Hinge Angle')
        grid on

        ah(2) = subplot(312);
        plot(hinge_trq.Time,hinge_trq.Data, 'LineWidth',1)
        ylabel('Torque (N*m)')
        title('Lift Hinge Actuation Torque')
        grid on

        ah(3) = subplot(313);
        plot(actL_p.Time,actL_p.Data, 'LineWidth',1,'DisplayName','Actuator L')
        hold on
        plot(actR_p.Time,actR_p.Data,'--', 'LineWidth',1,'DisplayName','Actuator R')
        hold off
        ylabel('Position (m)')
        title('Lift Actuator Extension')
        xlabel('Time (s)')
        legend('Location','Best')
        grid on

    case "LeftActuation"
        ah(1) = subplot(311);
        plot(hinge_q.Time,hinge_q.Data, 'LineWidth',1)
        ylabel('Angle (deg)')
        title('Lift Hinge Angle')
        grid on

        ah(2) = subplot(312);
        plot(actL_p.Time,actL_p.Data, 'LineWidth',1,'DisplayName','Actuator L')
        hold on
        plot(actR_p.Time,actR_p.Data,'--', 'LineWidth',1,'DisplayName','Actuator R')
        ylabel('Position (m)')
        title('Lift Actuator Extension')
        legend('Location','Best')
        grid on

        ah(3) = subplot(313);
        plot(actL_f.Time,actL_f.Data, 'LineWidth',1,'DisplayName','Actuator L')
        ylabel('Force (N)')
        title('Lift Actuator Force')
        xlabel('Time (s)')
        legend('Location','Best')
        grid on

    case "LeftRightActuation"
        ah(1) = subplot(311);
        plot(hinge_q.Time,hinge_q.Data, 'LineWidth',1)
        ylabel('Angle (deg)')
        title('Lift Hinge Angle')
        grid on

        ah(2) = subplot(312);
        plot(actL_p.Time,actL_p.Data, 'LineWidth',1,'DisplayName','Actuator L')
        hold on
        plot(actR_p.Time,actR_p.Data,'--', 'LineWidth',1,'DisplayName','Actuator R')
        hold off
        ylabel('Position (m)')
        legend('Location','Best')
        title('Lift Actuator Extension')
        grid on

        ah(3) = subplot(313);
        plot(actL_f.Time,actL_f.Data, 'LineWidth',1,'DisplayName','Actuator L')
        hold on
        plot(actR_f.Time,actR_f.Data,'--', 'LineWidth',1,'DisplayName','Actuator R')
        hold off
        ylabel('Force (N)')
        title('Lift Actuator Force')
        xlabel('Time (s)')
        legend('Location','Best')
        grid on

end

linkaxes(ah,'x')





