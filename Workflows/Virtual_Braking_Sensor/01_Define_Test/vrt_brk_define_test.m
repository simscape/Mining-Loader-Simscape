%% Create Virtual Test with Performance Metrics 
%
% <<Mining_Loader_Brake_Test_Overview.png>>
%

%% Overview
% This example defines a braking test for a mining loader. The braking
% distance is obtained via post processing. The purpose of this test is to
% generate training data for an AI surrogate model that can estimate the
% braking distance based on current vehicle conditions. The test is
% parameterized so that the conditions of the test can be varied:
%
% # Vehicle Speed
% # Boom Angle
% # Bucket Load
% # Surface Slope
%
% The code used to create this documentation is here: <matlab:edit('vrt_brk_define_test.m'); vrt_brk_define_test.m>
%
% (<matlab:web('Mining_Loader_Design_Overview.html') return to Mining Loader Design with Simscape Overview>)
%
% Copyright 2026 The MathWorks, Inc.

%% Open and Configure Model
%
% The vehicle model is created using Simscape.  Inputs from the workspace
% configure the test conditions. A simple state machine applies the brakes
% to assess braking distance
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

ann_h = find_system(modelName,'MatchFilter',@Simulink.match.allVariants,'FindAll', 'on','type','annotation','Tag','ModelFeatures');
for i = 1:length(ann_h)
    set_param(ann_h(i),'Interpreter','off')
    end

%% Mining Loader Model
%
% The mining loader model consists of the actuation system, powertrain, and
% the vehicle chassis with the implement.  The surface upon which the
% vehicle drives can be selected as well.  For the braking test, a flat
% slope with a parameterized incline is selected.
%
% <matlab:open_system('Mining_Loader_Sweep');open_system('Mining_Loader_Sweep/Mining%20Loader','force');Open Subsystem>

set_param('Mining_Loader_Sweep/Mining Loader','LinkStatus','none')
open_system('Mining_Loader_Sweep/Mining Loader','force')


%% Braking Test Controller
%
% The test sequence specifies when the brakes will be applied.
%
% # *Initialization* : Loader settles onto surface
% # *NotAtTarget* : Loader accelerates to target speed
% # *AtTarget* : Loader settles at target speed
% # *EngageBrake* : Brakes are applied
% # *StopSim* : Loader speed is below threshold for long enough period of time
%
% <matlab:open_system('Mining_Loader_Sweep');open_system('Mining_Loader_Sweep/Braking%20Test%20Control/Test%20Sequence','force');Open Subsystem>

set_param('Mining_Loader_Sweep/Braking Test Control/Test Sequence','LinkStatus','none')
open_system('Mining_Loader_Sweep/Braking Test Control/Test Sequence','force')


%% Simulation Results: Braking Test 1 
%
% The test conditions can be defined using a MATLAB App.
% 
% <<Mining_Loader_Brake_Test_App.png>>
% 
% The app calls a function that configures inputs and parameters for the
% braking test. Pressing button "Run Test" 
% 
% # Echoes the command to the MATLAB Command window
% # Runs the command to configure the test
% # Runs the simulation
% # Processes the results and creates a plot with the braking distance
%
% <<Mining_Loader_Brake_Test_1.png>>

[extInput_Mining_Loader_Sweep, minMachParams, Init] = test_MLSweep_braking(...
    'Mining_Loader_Sweep',...
    minMachParams,testSettings,Init,...
     5, ... % Vehicle Speed
    10, ... % Slope
     0, ... % Steering Angle (hinge)
    45, ... % Boom Lift Angle
     5, ... % Bucket Tilt Angle
 10000, ... % Bucket Load
    40  ... % Max Simulation Time
    );

out = sim('Mining_Loader_Sweep');
sm_mining_loader_plot1whlspd(out.logsout_Mining_Loader_Sweep,minMachParams.contact.tireRad/1000,minMachParams.contact.tireRad/1000,true);

%% Simulation Results: Braking Test 2 
%
% We increase the load, switch to reverse, and switch the slope for our
% second test.
%
% <<Mining_Loader_Brake_Test_2.png>>

[extInput_Mining_Loader_Sweep, minMachParams, Init] = test_MLSweep_braking(...
    'Mining_Loader_Sweep',...
    minMachParams,testSettings,Init,...
   -10, ... % Vehicle Speed
   -10, ... % Slope
     0, ... % Steering Angle (hinge)
    45, ... % Boom Lift Angle
     5, ... % Bucket Tilt Angle
 14000, ... % Bucket Load
    40  ... % Max Simulation Time
    );

out = sim('Mining_Loader_Sweep');
sm_mining_loader_plot1whlspd(out.logsout_Mining_Loader_Sweep,minMachParams.contact.tireRad/1000,minMachParams.contact.tireRad/1000,true);

%%

%clear all
%close all
bdclose all

