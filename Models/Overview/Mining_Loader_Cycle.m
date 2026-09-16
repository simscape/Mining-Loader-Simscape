%% Mining Loader Test Cycle
% 
% <<Mining_Loader_Test_Cycle_Overview.png>>
%
% This example models a mining loader. The loader has an articulated
% chassis with two driven wheels on the chassis and two driven wheels on
% the front frame. A single power source powers both axles. The bucket is
% attached to an arm that is lifted by two hydraulic cylinders. The bucket
% is tilted by a cylinder that connects to the bucket via a z-linkage. 
% 
% For the test cycle, the loader follows one lane to a right-angle turn.
% Partway down that passage, the loader stops and raises the arm and
% bucket.  The loader reverses out of that passage, and then follows a
% separate lane back to a position near the start. The bucket then tilts to
% empty its load.
%
% (<matlab:web('Mining_Loader_Design_Overview.html') return to Mining Loader Design with Simscape Overview>)
%
% Copyright 2026 The MathWorks, Inc.

%% Model
%
% <matlab:open_system('Mining_Loader_Cycle'); Open Model>

open_system('Mining_Loader_Cycle')

ann_h = find_system('Mining_Loader_Cycle','MatchFilter',@Simulink.match.allVariants,'FindAll', 'on','type','annotation','Tag','ModelFeatures');
for i = 1:length(ann_h)
    set_param(ann_h(i),'Interpreter','off')
end

%% Mining Loader Model
%
% The mining loader model consists of the actuation system, powertrain, and
% the vehicle chassis with the implement.  The surface upon which the
% vehicle drives can be selected as well.
%
% <matlab:open_system('Mining_Loader_Cycle');open_system('Mining_Loader_Cycle/Mining%20Loader','force');Open Subsystem>

set_param('Mining_Loader_Cycle/Mining Loader','LinkStatus','none')
open_system('Mining_Loader_Cycle/Mining Loader','force')

%% Vehicle Model
%
% The vehicle model contains the articulated chassis with a hinge
% connecting the chassis to the frame. The implement attaches to the frame
% Two wheels on the rear frame and two wheels on the front frame are
% connected via driveshafts to the drivetrain  Contact forces enable the
% tires to ride over the selected surface.
%
% <matlab:open_system('Mining_Loader_Cycle');open_system('Mining_Loader_Cycle/Mining%20Loader/Vehicle','force');Open Subsystem>

set_param('Mining_Loader_Cycle/Mining Loader/Vehicle','LinkStatus','none')
open_system('Mining_Loader_Cycle/Mining Loader/Vehicle','force')

%% Chassis Model
%
% The chassis is the rear portion of the loader. Two powered wheels connect
% to the housing.
%
% <matlab:open_system('Mining_Loader_Cycle');open_system('Mining_Loader_Cycle/Mining%20Loader/Vehicle/Chassis','force');Open Subsystem>

set_param('Mining_Loader_Cycle/Mining Loader/Vehicle/Chassis','LinkStatus','none')
open_system('Mining_Loader_Cycle/Mining Loader/Vehicle/Chassis','force')

%% Implement Model
%
% The implement subsystem houses the arm and the bucket linkage.  Two
% actuation systems position the bucket by lifting the arm and tilting the
% bucket.
%
% <matlab:open_system('Mining_Loader_Cycle');open_system('Mining_Loader_Cycle/Mining%20Loader/Vehicle/Implement','force'); Open Subsystem>

set_param('Mining_Loader_Cycle/Mining Loader/Vehicle/Implement','LinkStatus','none')
open_system('Mining_Loader_Cycle/Mining Loader/Vehicle/Implement','force')

%% Steer Actuation Model
%
% Two opposing hydraulic cylinders act to steer the loader.  Three methods
% of modeling the actuation system are provided. 
%
% * Hinge Motion: Motion of the hinge is prescribed with an input signal
% * Left Cylinder Motion: Only the motion of the left cylinder is
% prescribed with an input signal
% * Cylinder Actuation: Both cylinders are actuated using a Simscape model
% of the actuator.
%
% <matlab:open_system('Mining_Loader_Cycle');open_system('Mining_Loader_Cycle/Mining%20Loader/Vehicle/Steer','force');
% Open Subsystem>

set_param('Mining_Loader_Cycle/Mining Loader/Vehicle/Steer','LinkStatus','none')
open_system('Mining_Loader_Cycle/Mining Loader/Vehicle/Steer','force')


%% Steer Actuation, Hinge Motion
%
% The hinge motion variant prescribes the motion of the hinge connecting
% the chassis and frame. The simulation calculates the amount of torque it
% would take to move the hinge. This result can be used to size
% steering actuators.  A similar option exists for the lift arm
% and the bucket tilt actuation systems.
%
% <matlab:open_system('Mining_Loader_Cycle');open_system('Mining_Loader_Cycle/Mining%20Loader/Vehicle/Steer/Actuation/Hinge','force'); Open Subsystem>

set_param('Mining_Loader_Cycle/Mining Loader','popup_steer_actuation','Hinge Motion')
set_param('Mining_Loader_Cycle', 'SimulationCommand', 'update')
set_param('Mining_Loader_Cycle/Mining Loader/Vehicle/Steer/Actuation/Hinge','LinkStatus','none')
open_system('Mining_Loader_Cycle/Mining Loader/Vehicle/Steer/Actuation/Hinge','force')


%% Steer Actuation, Left Cylinder Extension
%
% The left cylinder motion variant prescribes the motion of the left
% cylinder connecting the chassis and the frame. The simulation calculates
% the amount of force it would take to produce this motion. This result can
% be used to size steering actuators. A similar option exists for the lift arm
% and the bucket tilt actuation systems.
%
% <matlab:open_system('Mining_Loader_Cycle');open_system('Mining_Loader_Cycle/Mining%20Loader/Vehicle/Steer/Actuation/Extension%20L','force'); Open Subsystem>

set_param('Mining_Loader_Cycle/Mining Loader','popup_steer_actuation','Left Cylinder Motion')
set_param('Mining_Loader_Cycle', 'SimulationCommand', 'update')
set_param('Mining_Loader_Cycle/Mining Loader/Vehicle/Steer/Actuation/Extension L','LinkStatus','none')
open_system('Mining_Loader_Cycle/Mining Loader/Vehicle/Steer/Actuation/Extension L','force')

%% Steer Actuation, Cylinder Actuation
%
% The cylinder actuation variant connects a 1D Simscape actuation model to
% the joints modeling the cylinder extension.  This variant enables
% engineers to size actuators, design actuation systems, and develop
% steering control systems. A similar option exists for the lift arm
% and the bucket tilt actuation systems.
%
% <matlab:open_system('Mining_Loader_Cycle');open_system('Mining_Loader_Cycle/Mining%20Loader/Vehicle/Steer/Actuation/Actuation','force'); Open Subsystem>

set_param('Mining_Loader_Cycle/Mining Loader','popup_steer_actuation','Cylinder Actuation')
set_param('Mining_Loader_Cycle', 'SimulationCommand', 'update')
set_param('Mining_Loader_Cycle/Mining Loader/Vehicle/Steer/Actuation/Actuation','LinkStatus','none')
open_system('Mining_Loader_Cycle/Mining Loader/Vehicle/Steer/Actuation/Actuation','force')


%% Drivetrain Model
%
% The drivetrain connects all four wheels via two differentials.  Each
% wheel driveshaft is modeled as a flexible shaft. All four wheels have
% disc brakes.
%
% <matlab:open_system('Mining_Loader_Cycle');open_system('Mining_Loader_Cycle/Mining%20Loader/Drivetrain','force'); Open Subsystem>

set_param('Mining_Loader_Cycle/Mining Loader/Drivetrain','LinkStatus','none')
open_system('Mining_Loader_Cycle/Mining Loader/Drivetrain','force')

%% Transmission Model
%
% A variable-ratio transmission block permits any transmission ratio
% between the input and output shafts. To keep the model numerically
% efficient, a gear ratio of 1 is used when the vehicle is moving, and the
% ratio is set to 0 when the vehicle is not moving.  This model is only
% compatible with a very abstract motor model.
%
% <matlab:open_system('Mining_Loader_Cycle');open_system('Mining_Loader_Cycle/Mining%20Loader/Transmission','force'); Open Subsystem>

set_param('Mining_Loader_Cycle/Mining Loader/Transmission','LinkStatus','none')
open_system('Mining_Loader_Cycle/Mining Loader/Transmission','force')

%% Motor Model
% 
% The motor model is an ideal velocity source.  It will spin the output
% shaft at the commanded speed, and that speed is calculated based on the
% target vehicle speed and wheel radius.
%
% <matlab:open_system('Mining_Loader_Cycle');open_system('Mining_Loader_Cycle/Mining%20Loader/Motor','force'); Open Subsystem>

set_param('Mining_Loader_Cycle/Mining Loader/Motor','LinkStatus','none')
open_system('Mining_Loader_Cycle/Mining Loader/Motor','force')

%% Virtual Braking Sensor Model
% 
% A machine learning model is used to estimate braking distance.  The
% current bucket load, vehicle pitch, boom angle, and vehicle speed are
% provided as inputs, and the trained Regression Gaussian Process model
% estimates the braking distance.  Variable Brick Solid blocks visualize
% the braking distance in the animation.
%
% <matlab:open_system('Mining_Loader_Cycle');open_system('Mining_Loader_Cycle/Mining%20Loader/Braking%20Distance%20Sensor/Estimate','force'); Open Subsystem>

set_param('Mining_Loader_Cycle/Mining Loader/Braking Distance Sensor/Estimate','LinkStatus','none')
open_system('Mining_Loader_Cycle/Mining Loader/Braking Distance Sensor/Estimate','force')


%% Simulation Results: Load Cycle, Hinge Motion
%
% For the test cycle, the loader follows one lane to a right-angle turn.
% Partway down that passage, the loader stops and raises the arm and
% bucket.  The loader reverses out of that passage, and then follows a
% separate lane back to a position near the start. The bucket then tilts to
% empty its load.
%
% To accomplish this cycle, the test is defined with two sets of inputs.
% The path-following portion is specified by providing a closed-loop driver
% model a target speed and heading angle for each point along the
% trajectory. Note that this definition is with respect to distance, not
% time.  This covers first phase of the maneuver, reaching the end of the
% passage, and the final stage of the maneuver where the loader returns to
% the start position.
%

sm_mining_loader_load_cycle_plot_ClosedLoop

%%
% The middle phase of the maneuver is conducted open loop. The steering
% angle and vehicle speed are specified as the loader reverses out of the
% passage and aligns with the return lane.
%
% To switch between closed-loop control and open-loop control, the
% closed-loop commands are overridden in a subsystem downstream of the
% closed-loop driver model.  For a period of time, the commands of the
% closed-loop driver are ignored.  The periods of time where the
% closed-loop driver commands are ignored are cited on this plot.

sm_mining_loader_load_cycle_plot_OpenLoop

%%
set_param('Mining_Loader_Cycle/Mining Loader',...
    'popup_steer_actuation','Hinge Motion','popup_lift_actuation','Hinge Motion',...
    'popup_tilt_actuation','Hinge Motion','popup_scene','Grid',...
    'popup_sensor','None');

%%
% The plot below shows the wheel speeds during the maneuver.  During
% turns, the wheel speeds differ slightly from the vehicle speed as the
% wheels on the outside of the turn spin faster than the wheels on the
% inside of the turn.

out=sim('Mining_Loader_Cycle');
close(gcf)
sm_mining_loader_plot1whlspd(out.logsout_Mining_Loader_Cycle,minMachParams.contact.tireRad/1000,minMachParams.contact.tireRad/1000,false);

%% 
% The plot below shows the path of the mining loader during the maneuver.
% Note that a portion of the trajectory is performed open-loop, as the
% loader transitions from the pile to the return path.
sm_mining_loader_plot6vehpos(out.logsout_Mining_Loader_Cycle, Maneuver);

%%
% The actuation during this test is prescribed motion to the
% "hinge" joints for steering, lifting, and tilting. The plot below shows
% the articulation angle, torque required to move that joint, and the
% actuator extensions. This helps size actuators, including range of travel
% and force.

sm_mining_loader_plot3actsteer(out.logsout_Mining_Loader_Cycle);
sm_mining_loader_plot4actlift(out.logsout_Mining_Loader_Cycle);
sm_mining_loader_plot5acttilt(out.logsout_Mining_Loader_Cycle);

%% Simulation Results: Load Cycle, Cylinder Motion
%
% The same test cycle is performed, but in this test we prescribe the
% motion of one cylinder per hinge (steer, lift, tilt). 

close(gcf)
set_param('Mining_Loader_Cycle/Mining Loader',...
    'popup_steer_actuation','Left Cylinder Motion',...
    'popup_lift_actuation','Left Cylinder Motion',...
    'popup_tilt_actuation','Cylinder Motion','popup_scene','Grid',...
    'popup_sensor','None');

out=sim('Mining_Loader_Cycle');

%%
% The plot below shows the wheel speeds during the maneuver.  
sm_mining_loader_plot1whlspd(out.logsout_Mining_Loader_Cycle,minMachParams.contact.tireRad/1000,minMachParams.contact.tireRad/1000,false);

%%
% The actuation during this test is prescribed motion to one of the
% actuation cylinders. The plot below shows the articulation angle,
% actuator extensions, and force required for one actuator. This helps size
% actuators, including range of travel and force.
%
% Note that we are only measuring the force required for a single actuator,
% so for steering and lifting the reported force will be higher than would
% be required for a pair of actuators.

sm_mining_loader_plot3actsteer(out.logsout_Mining_Loader_Cycle);
sm_mining_loader_plot4actlift(out.logsout_Mining_Loader_Cycle);
sm_mining_loader_plot5acttilt(out.logsout_Mining_Loader_Cycle);

%% Simulation Results: Load Cycle, Cylinder Actuation
%
% The same test cycle is performed, but in this test we use ideal force
% actuation for all actuation systems (steer, lift, tilt). 

set_param('Mining_Loader_Cycle/Mining Loader',...
    'popup_steer_actuation','Cylinder Actuation',...
    'popup_lift_actuation','Cylinder Actuation',...
    'popup_tilt_actuation','Cylinder Actuation','popup_scene','Grid',...
    'popup_sensor','None');

out=sim('Mining_Loader_Cycle');

%%
% The plot below shows the wheel speeds during the maneuver.  
close(gcf)
sm_mining_loader_plot1whlspd(out.logsout_Mining_Loader_Cycle,minMachParams.contact.tireRad/1000,minMachParams.contact.tireRad/1000,false);

%%
% The actuation during this test is ideal force actuation to all cylinders.
% The plot below shows the articulation angle, actuator extensions, and
% force required for one actuator. This helps size actuators, including
% range of travel and force.

sm_mining_loader_plot3actsteer(out.logsout_Mining_Loader_Cycle);
sm_mining_loader_plot4actlift(out.logsout_Mining_Loader_Cycle);
sm_mining_loader_plot5acttilt(out.logsout_Mining_Loader_Cycle);

%%

%clear all
%close all
bdclose all
