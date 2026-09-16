%% Generate Training Data by Running Design of Experiments
%
% <<Mining_Loader_Generate_Data_Overview.png>>
%

%% Overview
% This example generates training data for a AI surrogate model. A simple
% factorial distribution of experiments is created. The simulation model is
% tested with those parameters and the braking distance is measured. The
% parameter sets and braking distance will be used to train an AI
% surrogate model.
%
% The code used to create this documentation is here: <matlab:edit('vrt_brk_generate_data.m'); vrt_brk_generate_data.m>
%
% (<matlab:web('Mining_Loader_Design_Overview.html') return to Mining Loader Design with Simscape Overview>)

%% Open and Configure Model
%
% The vehicle model is created using Simscape.  Using MATLAB commands, we
% configure the model to use the simplest actuation method, prescribed
% motion for the steer, lift, and tilt joints.  The scene is configured to
% use a parameterized slope, and we turn off the braking distance
% estimation.
%
% <matlab:open_system('Mining_Loader_Sweep'); Open Model>

modelName = 'Mining_Loader_Sweep';
if ~bdIsLoaded(modelName)
    open_system(modelName);
end
set_param([modelName '/Mining Loader'],'popup_scene','SlopeX');
set_param([modelName '/Mining Loader'],'popup_sensor','None');
set_param([modelName '/Mining Loader'],...
    'popup_steer_actuation','Hinge Motion',...
    'popup_lift_actuation','Hinge Motion',...
    'popup_tilt_actuation','Hinge Motion'...
    )

Init.Vehicle.px = 0;
now_string = datestr(now,'yymmdd_HHMM'); % For saving results

%% Mining Loader Model
%
% The mining loader model consists of the actuation system, powertrain, and
% the vehicle chassis with the implement.  The surface upon which the
% vehicle drives can be selected as well.
%
% <matlab:open_system('Mining_Loader_Sweep');open_system('Mining_Loader_Sweep/Mining%20Loader','force');Open Subsystem>

% Open, but do not break link as model must be saved later
open_system('Mining_Loader_Sweep/Mining Loader','force')

%% Create Table of Test Conditions
%
% A factorial distribution is used to generate the test conditions.  The
% braking distance will increase sharply towards the edges of the parameter
% space (high loads, high slope, high speed). It is important to capture
% the limits of the operating conditions.  A Latin Hypercube distribution
% was also tested, but it resulted in a surrogate model that was less
% accurate at the edges of the operating conditions.

[allTests,testPoints] = generateTestPoints( ...
    minMachParams, ...
    4, ...   % Number of points for boom lift angles
    6, ...   % Number of points for vehicle speeds
    6, ...   % Number of points for slopes
    5);      % Number of points for bucket loads
numAllTestInputs = height(allTests);

% Alternate: Latin Hypercube
%[allTests] = generateTestPointsLHS(720,minMachParams);
%numAllTestInputs = height(allTests);

figure;
[~,ax,bigax] = gplotmatrix(allTests{:,:},[],[],[],[],[],[],[],...
    allTests.Properties.VariableNames, allTests.Properties.VariableNames);
title(['Scatter Plot of ' num2str(height(allTests)) ' Samples for ' num2str(width(allTests)) ' Parameters'],'FontSize',18)

set(gcf,'Position',[54   255   850   706])
for j = 1:size(ax,1)
    for k = 1:size(ax,2)
        %ax(j,k).XLabel.String = '';
        %ax(j,k).YLabel.Interpreter = 'none';
        %ax(j,k).YLabel.Rotation = 0;        
        %ax(j,k).YTickLabel = [];
        ax(j,k).Box = 'on'; 
    end
end

save allTestTable allTests

%% Create Simulation Input Object
% 
% A simulation input object contains all of the model and parameter
% settings for the test sweep we wish to run. Each element in the input
% object defines an individual brake test and uses the parameters from the
% distribution created above.

% Assign Defaults for Simulation Input Object
simIn = Simulink.SimulationInput(modelName);
simIn = simIn.setModelParameter('SimMechanicsOpenEditorOnUpdate', 'off');
simIn = simIn.setModelParameter('SimscapeLogType', 'None');
simIn = simIn.setVariable('stopTime', stopTime);
simIn = simIn.setVariable('testSettings',testSettings);
simIn = simIn.setVariable('Init',Init);

% Assign defaults to all inputs
simIn(1:numAllTestInputs) = simIn;

% Get default structure of inputs from model
testInputs = createInputDataset(modelName, "UpdateDiagram", false);

% Steering Angle is constant for all tests
testInputs{1}.time = [0 stopTime]';
testInputs{1}.data = [minMachParams.initCond.steerAngle minMachParams.initCond.steerAngle]';

% Bucket Tilt Angle is constant for all tests
testInputs{3}.time = [0 stopTime]';
testInputs{3}.data = [minMachParams.initCond.bucketAngle minMachParams.initCond.bucketAngle]';

% Inputs for factorial distribution
for ii = 1:1:numAllTestInputs
    % Set test conditions
    simIn(ii) = setVariable(simIn(ii), 'initBoomAngle', allTests.BoomAngle(ii)); % [deg]
    simIn(ii) = setVariable(simIn(ii), 'bucketLoadMass', allTests.BucketLoad(ii)); % [kg]
    Init.Vehicle.pitch = -allTests.Slope(ii);
    simIn(ii) = setVariable(simIn(ii), 'Init', Init); % [deg]
    simIn(ii) = setVariable(simIn(ii), 'targetSpeedMag', abs(allTests.VehicleSpeed(ii))); % [km/hr]

    % Boom Lift Angle
    testInputs{2} = timeseries([allTests.BoomAngle(ii) allTests.BoomAngle(ii)]',...
        [0 stopTime]',...
        'Name',testInputs{2}.Name);

    % Vehicle Speed
    testInputs{4} = timeseries([0 0 allTests.VehicleSpeed(ii) allTests.VehicleSpeed(ii)]',...
        [0 testSettings.initSettlingTime testSettings.initSettlingTime+testSettings.speedRampTime stopTime]',...
        'Name',testInputs{4}.Name);

    % Set the external input
    simIn(ii) = setExternalInput(simIn(ii), testInputs);
end

simIn

%% Run Simulations Using Parallel Computing
%
% Using the parsim() command, the suite of tests is executed in parallel on
% multiple workers.  Using Fast Restart, the model is only compiled once
% per worker.  Because we have defined the design parameters as run-time
% parameters, we can modify their values even within the compiled model.
% This dramatically shortens the time it takes to execute the sweep.
%
% Progress is reported using the Simulation Manager. We can see if any
% warnings or errors have occurred during any of the tests and see how long
% each run has taken.

close_system('Mining_Loader_Sweep/Mining Loader');
save_system(modelName) % Must be saved for parsim

TrainingResults = parsim(simIn, ...
    'ShowSimulationManager', 'on','UseFastRestart','on','ShowProgress','off');

save TrainingResultsOut TrainingResults

%% Extract Braking Distance
%
% The results of the sweep are passed to a function to calculate the
% braking distance. This is required to train the surrogate model, as it
% needs the test conditions and the resulting braking distance.

[FullResultsTable, BrkDist_MeasEst] = Extract_Training_Data(TrainingResults,now_string);

disp(['Number of samples in FullResultsTable:' num2str(height(FullResultsTable))]);
FullResultsTable(1:10,:)

save FullResultsTable FullResultsTable

%% Re-Run Test with Longest Braking Distance
%
% In this step, we find the run with the longest braking distance and
% re-run just that test. During this step, we turn Simscape logging back on
% and animate the results.  This lets us review the results of this
% individual test more closely.

% Maximum braking distance and first row index where it occurs
[maxVal, testIdxToRun] = max(FullResultsTable.BrakingDist);

disp(allTests(testIdxToRun,:));

% Copy Simulation Input Object element to separate variable
simInMxBrk = simIn(testIdxToRun);

% Turn logging and animation on for Simulation Input Object element
simInMxBrk = simInMxBrk.setModelParameter('SimMechanicsOpenEditorOnUpdate', 'on');
simInMxBrk = simInMxBrk.setModelParameter('SimscapeLogType', 'All');

% Run the simulation
out = sim(simInMxBrk);
extInput_Mining_Loader_Sweep = testInputs;
sm_mining_loader_plot1whlspd(out.logsout_Mining_Loader_Sweep,minMachParams.contact.tireRad/1000,minMachParams.contact.tireRad/1000,true);

%%
%clear all
%close all
bdclose all

