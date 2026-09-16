%% Mining Loader Design with Simscape(TM)
%
% <<Mining_Loader_Design_Overview.png>>
% 
% This repository contains models and code to help engineers design
% mining loaders. 
%
% * *Size actuators* using prescribed motion for cylinder positions. 
% * *Tune control systems* using abstract actuation systems.
% * *Explore kinematics* of bucket linkage.
% * *Measure mechanical loads* with abstract models for fast simulation.
% * *Evaluate braking distance* by sweeping test conditions.
% * *Develop virtual braking sensors* by training surrogate models using
% generated data.

% Copyright 2025-2026 The MathWorks, Inc.

%%
% *Mining Loader Model*
% 
% # Mining Loader Model: <matlab:open_system('Mining_Loader_Cycle') Model>, <matlab:web('Mining_Loader_Cycle.html') Documentation>
%
% *Workflows*
%
% # Define Braking Test: <matlab:open_system('Mining_Loader_Sweep') Model>, <matlab:web('vrt_brk_define_test.html') Documentation>
% # Generate Training Data: <matlab:open_system('Mining_Loader_Sweep') Model>, <matlab:web('vrt_brk_generate_data.html') Documentation>
% # Train and Validate Model: <matlab:open_system('Mining_Loader_Sweep') Model>, <matlab:web('vrt_brk_train_surrogate.html') Documentation>
