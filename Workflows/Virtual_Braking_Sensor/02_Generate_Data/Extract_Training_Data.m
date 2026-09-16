function [FullResultsTable,BrkDist_MeasEst] = Extract_Training_Data(TrainingResults,now_string)
%% Extract Training Data
% This function creates plots that show the training data for the braking
% distance simulations and assembles data for training surrogate models.

%% Table of Results
% Column names
columnNames = {...
    'BucketLoad', 'Slope', 'BoomAngle', 'VehSpeedCmd', 'BrakingDist'};

% Number of tests
numTests = numel(TrainingResults);
BucketLoad  = GetLastVals(TrainingResults,'BucketLoad',numTests);  % [kg]
Slope       = GetLastVals(TrainingResults,'Slope',numTests);       % [deg]
BoomAngle   = GetLastVals(TrainingResults,'BoomAngle',numTests);   % [deg]
VehSpeedCmd = GetLastVals(TrainingResults,'VehSpeedCmd',numTests); % [km/hr]

% Test valid if vehicle came to rest before end of simulation
StopSim = GetLastVals(TrainingResults,'StopSim',numTests);
failedTestsIdx = find(StopSim==0);
if ~isempty(failedTestsIdx)
    warning(['Vehicle did not come to rest in ' num2str(length(failedTestsIdx)) ' tests ' num2str(failedTestsIdx)]);
end

%% Identify index where braking event starts
brakeStartIdx = zeros(numTests,1);
for ii = 1:1:numTests
    brakeSigTmp = TrainingResults(ii).logsout_Mining_Loader_Sweep.find('BrakeSignal');
    % Start of the braking event
    brakeStartIdx(ii,1) = find(diff(brakeSigTmp.Values.Data)==1,1)+1;
end

% Braking Distance: Integrate Vehicle Speed along direction of travel
BrakingDist = zeros(numTests,1);
for ii = 1:1:numTests
    BrakingDist(ii,1)    = findLoaderBrkDist_integVel(TrainingResults(ii).logsout_Mining_Loader_Sweep);
end

% Braking Distance: Find final resting position of vehicle
BrakingDist_px= zeros(numTests,1);
for ii = 1:1:numTests
    BrakingDist_dx(ii,1) = findLoaderBrkDist_dx(TrainingResults(ii).logsout_Mining_Loader_Sweep);
end

% Braking Distance: Obtain estimation
BrakingDist_es= zeros(numTests,1);
for ii = 1:1:numTests
    BrakingDist_es(ii,1) = findLoaderBrkDist_estim(TrainingResults(ii).logsout_Mining_Loader_Sweep);
end

BrkDist_MeasEst = [BrakingDist_dx BrakingDist BrakingDist_es];

% Braking Distance Plot
figString = 'h1_Braking_Distance';
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

plot(BrakingDist,':o','DisplayName','Integrate vx');
%hold on
%plot(BrakingDist_px,':x','DisplayName','Delta px');
%hold off
grid on;
title('Braking Distance');
xlabel('Test Number');
ylabel('Braking Distance [m]');
box on
if(~strcmp(now_string,'none'))
    saveas(gcf, ['Test_' now_string '_BrakingDistance.png'])
end

% Wheel Speeds Plot
figString = 'h2_Wheel_Speeds';
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

hold on;
for ii = 1:1:numTests
    leftFrontTmp = TrainingResults(ii).logsout_Mining_Loader_Sweep.find('LeftFrontWheelSpeed');
    rightFrontTmp = TrainingResults(ii).logsout_Mining_Loader_Sweep.find('RightFrontWheelSpeed');
    leftRearTmp = TrainingResults(ii).logsout_Mining_Loader_Sweep.find('LeftRearWheelSpeed');
    rightRearTmp = TrainingResults(ii).logsout_Mining_Loader_Sweep.find('RightRearWheelSpeed');

    plot(leftFrontTmp.Values.Time(brakeStartIdx(ii,1):end),leftFrontTmp.Values.Data(brakeStartIdx(ii,1):end));
    plot(rightFrontTmp.Values.Time(brakeStartIdx(ii,1):end),rightFrontTmp.Values.Data(brakeStartIdx(ii,1):end));
    plot(leftRearTmp.Values.Time(brakeStartIdx(ii,1):end),leftRearTmp.Values.Data(brakeStartIdx(ii,1):end));
    plot(rightRearTmp.Values.Time(brakeStartIdx(ii,1):end),rightRearTmp.Values.Data(brakeStartIdx(ii,1):end));
end
grid on;
title('Wheel Speeds During Braking');
xlabel('Time [s]');
ylabel('Wheel Speed [rad/s]');
box on
if(~strcmp(now_string,'none'))
    saveas(gcf, ['Test_' now_string '_WheelSpeeds.png'])
end

% Vehicle Speeds Plot
figString = 'h3_Vehicle_Speeds';
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

hold on;
for ii = 1:1:numTests
    BodyVx = TrainingResults(ii).logsout_Mining_Loader_Sweep.find('BodyVx');
    plot(BodyVx.Values.Time(brakeStartIdx(ii,1):end),BodyVx.Values.Data(brakeStartIdx(ii,1):end),'DisplayName',num2str(ii));
end
hold off;grid on;box on;

title('Vehicle Speed During Braking');
xlabel('Time [s]');
ylabel('Vehicle Speed [kph]');

if(~strcmp(now_string,'none'))
    saveas(gcf, ['Test_' now_string '_BodyVx.png'])
end

%% Extract Results Table
FullResultsTable = table(BucketLoad, Slope, BoomAngle, ...
    VehSpeedCmd, BrakingDist, ...
    'VariableNames', columnNames);

if(~strcmp(now_string,'none'))
    save(['Test_' now_string '_FullResultsTable.mat'], "FullResultsTable")
end

end

%% Functions
function lastVals = GetLastVals(SweepResults, SignalName, numTests)
% Initialize
lastVals = zeros(numTests,1);
% Populate
for ii = 1:1:numel(SweepResults)
    % Get signal
    sigTmp = SweepResults(ii).logsout_Mining_Loader_Sweep.find(SignalName);

    % Get last value
    lastVals(ii,1) = sigTmp(1).Values.Data(end);
end
end