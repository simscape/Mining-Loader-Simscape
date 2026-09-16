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

ah2(1) = subplot(2,1,1);
plot(Maneuver.Trajectory.xTrajectory.Value,Maneuver.Trajectory.vx.Value,'-o')
ylabel('Speed (kph)')
xlabel('Distance Along Trajectory (m)')
title('Target Speed')

ah2(2) = subplot(2,1,2);
plot(Maneuver.Trajectory.xTrajectory.Value,Maneuver.Trajectory.aYaw.Value*180/pi,'-o')
ylabel('Yaw Angle (deg)')
xlabel('Distance Along Trajectory (m)')
title('Target Yaw Angle')
