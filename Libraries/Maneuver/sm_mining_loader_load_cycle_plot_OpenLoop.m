% Reuse figure if it exists, else create new figure
figString = ['h1_' mfilename];
% Only create a figure if no figure exists
figExist = 0;
fig_hExist = evalin('base',['exist(''' figString ''',''var'')']);
if (fig_hExist)
    figExist = evalin('base',['ishandle(' figString ') && strcmp(get(' figString ', ''type''), ''figure'')']);
end
if ~figExist
    fig_h = figure;%('Name',figString);
    assignin('base',figString,fig_h);
else
    fig_h = evalin('base',figString);
end
figure(fig_h)
clf(fig_h)

%% Plot Maneuver
ah(1) = subplot(2,1,1);
area(Maneuver.Override.aSteer.t.Value,...
    Maneuver.Override.aSteer.On.Value*1.1*abs(max(Maneuver.Steer.aWheel.Value*180/pi)),...
    'FaceColor','g','FaceAlpha',0.3,'DisplayName','Override On');
hold on
plot(Maneuver.Steer.t.Value,Maneuver.Steer.aWheel.Value*180/pi,'DisplayName','Steering Angle');
hold off
ylabel('deg')
legend('Location','Best')
title('Steering Angle Command')

ah(2) = subplot(2,1,2);
area(Maneuver.Override.vTarget.t.Value,...
    Maneuver.Override.vTarget.On.Value,...
    'FaceColor','g','FaceAlpha',0.3,'DisplayName','Override On');
hold on
plot(Maneuver.vTarget.t.Value,Maneuver.vTarget.kph.Value,'DisplayName','vTarget');
hold off
legend('Location','Best')
title('Target Speed Command')
ylabel('kph')
xlabel('Time (s)')
linkaxes(ah,'x')
