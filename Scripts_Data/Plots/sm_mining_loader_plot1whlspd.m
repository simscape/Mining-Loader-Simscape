function [fig_h, res] = sm_mining_loader_plot1whlspd(logsoutRes,whlRadF,whlRadR,calcBrkDst)
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
simlog_t = [];
simlog_vFL = [];
simlog_vFR = [];
simlog_vRL = [];
simlog_vRR = [];

if(~isempty(find(strcmp(fieldnames(logsoutRes.get('Loader').Values.Vehicle),'Frame'))))
    simlog_t     = logsoutRes.get('Loader').Values.Vehicle.Frame.Body.vx.Time;
    simlog_vVeh  = logsoutRes.get('Loader').Values.Vehicle.Frame.Body.vx.Data*3.6;
    simlog_vFL  = logsoutRes.get('Loader').Values.Vehicle.Frame.WhlFL.w.Data*3.6;
    simlog_vFR  = logsoutRes.get('Loader').Values.Vehicle.Frame.WhlFR.w.Data*3.6;
    res.t    = simlog_t;
    res.vVeh = simlog_vVeh;
    res.vFL = simlog_vFL;
    res.vFR = simlog_vFR;
end
if(~isempty(find(strcmp(fieldnames(logsoutRes.get('Loader').Values.Vehicle),'Chassis'))))
    simlog_t     = logsoutRes.get('Loader').Values.Vehicle.Chassis.WhlRL.w.Time;
    simlog_vRL   = logsoutRes.get('Loader').Values.Vehicle.Chassis.WhlRL.w.Data*3.6;
    simlog_vRR   = logsoutRes.get('Loader').Values.Vehicle.Chassis.WhlRR.w.Data*3.6;
    res.vRL = simlog_vFL;
    res.vRR = simlog_vFR;
end

% Get simulation results
simlog_px = [];
simlog_py = [];
if(~isempty(find(strcmp(fieldnames(logsoutRes.get('Loader').Values),'World'))))
    simlog_xVeh  = logsoutRes.get('Loader').Values.World.x.Data;
    simlog_yVeh  = logsoutRes.get('Loader').Values.World.y.Data;
end

tco = get(gca,'defaultAxesColorOrder');

% Plot results
if(~isempty(cmdVehSpd))
    plot(cmdVehSpd.Time, cmdVehSpd.Data, 'k--', 'LineWidth', 1,'DisplayName','Command')
end
hold on
if(~isempty(simlog_vVeh))
    plot(simlog_t, simlog_vVeh, 'b', 'LineWidth', 2,'DisplayName','Vehicle')
    plot(simlog_t, simlog_vRL*whlRadR, 'Color',tco(5,:),'LineWidth', 1,'DisplayName','RL')
    plot(simlog_t, simlog_vRR*whlRadR, 'Color',tco(6,:),'LineWidth', 1,'DisplayName','RR')
end
if(~isempty(simlog_vFL))
    plot(simlog_t, simlog_vFL*whlRadF, 'Color',tco(1,:), 'LineWidth', 1,'DisplayName','FL')
    plot(simlog_t, simlog_vFR*whlRadF, 'Color',tco(2,:),'LineWidth', 1,'DisplayName','FR')
end
hold off

ylabel('Speed (km/hr)')
xlabel('Time (s)')
title('Wheel Speeds and Vehicle Speed')
grid on
legend('Location','Northeast');
box on
text(0.05,0.45,'Wheel Speeds estimated with unloaded radius','Units','normalized','Color',[0.6 0.6 0.6])
if(~isempty(simlog_xVeh))
    finalPosStr = sprintf('Final Position:  x = %3.2f, y=%3.2f',simlog_xVeh(end),simlog_yVeh(end));
    text(0.05,0.5,finalPosStr,'Units','normalized','Color',[0.6 0.6 0.6])
end

if(calcBrkDst)
    brakeSigTmp = logsoutRes.find('BrakeSignal');
    % Start of the braking event
    brakeStartIdx = find(diff(brakeSigTmp.Values.Data)==1,1)+1;
    % Speed signal
    if ~isempty(brakeStartIdx)
        % Calculate distance from speed
        speedSig = logsoutRes.find('BodyVx');
        speedSigMPS = abs(speedSig.Values.Data*1000/3600);
        BrakingDist = trapz(speedSig.Values.Time(brakeStartIdx:end),speedSigMPS(brakeStartIdx:end));

        % Calculate distance from positions at start and end of event
        %px = logsoutRes.get('Loader').Values.World.x.Data;
        %py = logsoutRes.get('Loader').Values.World.y.Data;
        %pz = logsoutRes.get('Loader').Values.World.z.Data;
        %BrakingDist = sqrt((px(brakeStartIdx)-px(end))^2+(py(brakeStartIdx)-py(end))^2+(pz(brakeStartIdx)-pz(end))^2);

        BrkDstStr = sprintf('Braking Distance Measured: %3.2f m',BrakingDist);

        % If estimate is active, record estimate
        xBrk = logsoutRes.get('Loader').Values.Sensor.xBrk.Data;
        if(max(abs(xBrk))>1e-2)
            tBrk = logsoutRes.get('Loader').Values.World.x.Time(brakeStartIdx);
            BrakingDistEst = interp1(...
                logsoutRes.get('Loader').Values.Sensor.xBrk.Time, ...
                xBrk,tBrk);
            BrkDstStr = sprintf('%s\nBraking Distance Estimated: %3.2f m',BrkDstStr,BrakingDistEst);
            %text(0.05,0.2,BrkDstStr,'Units','normalized','Color',[0.6 0.6 0.6])
        end

        text(0.05,0.4,BrkDstStr,'Units','normalized','Color',[0.6 0.6 0.6])

    
    else
        BrakingDist = -1;
    end
end


