function sm_car_gen_driver_database
% Define vehicle-level initial conditions for maneuvers
% Vehicle position, orientation, initial speed, initial wheel speed
%
% Copyright 2019-2026 The MathWorks, Inc.

%% Vehicle-level data
%   Vehicle Name         #Axles  Wheel Radius (m)    Init Z-Offset (m)

%disp(['Generating DDatabase from ' mfilename]);

%% Default Driver
veh_name = 'Mining_Loader';
drv.Lateral.Stanley.NForward.Value          = 1.2;          % (no units) 
drv.Lateral.Stanley.NReverse.Value          = 2.5;        % (no units)
drv.Lateral.xWheelbase.Value        = 4.5;      % m
drv.Lateral.aMaxSteer.Value         = 100*10;         % deg
drv.Lateral.fSteerCutoff.Value      = 314.159265; % rad/s

drv.Long.mVehicle.Value             = 20000;%Vehicle.Body.Mass;       % kg
drv.Long.FTractive.Value            = 17297;      % N
drv.Long.tDriver.Value              = 0.1;        % s
drv.Long.xPreview.Value             = 20;         % s
drv.Long.NDragRoll.Value            = 200;        % N       
drv.Long.NDragRollDriveline.Value   = 2.5;        % N/(m/s)
drv.Long.NDragAero.Value            = 0;          % N/(m^2/s^2)
drv.Long.rho_air.Value              = 1.225;      % kg/m^3
drv.Long.ARef.Value                 = 2.81;       % m^2
drv.Long.gGravity.Value             = 9.80665;       % m/s^2
drv.Long.fAccelCutoff.Value         = 31.4159265; % 1/s
drv.Long.fBrakeCutoff.Value         = 31.4159265; % 1/s
drv.Long.FFLookahead.Value          = 0.5;        % s
drv.Long.NRollingResistance.Value   = 0.01;       % (1)
drv.Long.NRoadFriction.Value        = 0.9;        % (1)
drv.Long.Kp.Value                   = 0.3125;     % (1)
drv.Long.Ki.Value                   = 0.0391;     % (1)
drv.Long.gMaxAccel.Value            = 5;          % m/s^2
drv.Long.gMaxDecel.Value            = -10;        % m/s^2

drv.drvCycle.Long.Ki.Value          = 0;          % 1/s
drv.drvCycle.Long.Kp.Value          = 1;          % 1/s
drv.drvCycle.Filter.Reference.Value = 10.0;       % Hz
drv.drvCycle.Filter.Measured.Value  = 125.6637;      % Hz


drv.Vis.xA = -4.1769+1.1769+0.2;
drv.Vis.xB = 0.7846*0+0.2;
drv.Vis.yA = 0.5538;
drv.Vis.yB = 3.1154;
drv.Vis.extr_data = [...
    drv.Vis.xB drv.Vis.yB;...
    drv.Vis.xA drv.Vis.yB;...
    drv.Vis.xA drv.Vis.yA;...
    drv.Vis.xB drv.Vis.yA];
drv.Vis.extr_len = 2;

drv.Vis.clr = [1 0.4 0.4];
drv.Vis.opc = 0.2*0;

Driver.(veh_name) = drv;
clear drv

%% List of Closed-Loop Maneuvers
% Maneuvers with longitudinal and lateral driver
cl_manv_longLat = {...
    'Grading'};

% Maneuvers with longitudinal driver only
cl_manv_longOnly = {...
    'Accel_Decel'};

%% Assemble database of drivers - closed loop Long + Lat

% Get list of maneuver names (long + lat)
Mnames = cl_manv_longLat;
num_M  = length(Mnames);

% Get list of vehicle names
Vnames = fieldnames(Driver);
num_V  = size(Vnames,1);

% Loop over list of maneuvers
for Mi = 1:num_M
    % Loop over list of vehicles
	ManvName = Mnames{Mi};
    for Vi = 1:num_V
    	VehName = Vnames{Vi};
        % Add placeholder Units and Comments
        LoNames = fieldnames(Driver.(VehName).Long);
        for LOi = 1:length(LoNames)
            LoName = LoNames{LOi};
            % disp([ManvName ' ' VehName ' ' LoName]); % Debug
            Driver.(VehName).Long.(LoName).Units    = '';
            Driver.(VehName).Long.(LoName).Comments = '';
        end

        LaNames = fieldnames(Driver.(VehName).Lateral);
        for LOi = 1:length(LaNames)
            LaName = LaNames{LOi};
            Driver.(VehName).Lateral.(LaName).Units    = '';
            Driver.(VehName).Lateral.(LaName).Comments = '';
        end

        % Add Specific Units and Comments
        Driver.(VehName).Lateral.xWheelbase.Units    = 'm';
        Driver.(VehName).Lateral.xWheelbase.Comments = 'Vehicle.Chassis.Body.sAxle1.Value - Vehicle.Chassis.Body.sAxle(rear).Value';
        Driver.(VehName).Lateral.aMaxSteer.Units     = 'deg';
        Driver.(VehName).Lateral.fSteerCutoff.Units  = 'rad/s';
        Driver.(VehName).Lateral.Pursuit.xLookaheadMin.Units = 'm';        % m
        Driver.(VehName).Lateral.Pursuit.xLookaheadMax.Units = 'm';         % m
        Driver.(VehName).Lateral.Pursuit.nWeightHeadingErr.Value = 0.5;      % (no units)
        Driver.(VehName).Lateral.class.Value               = 'Stanley';  % Lat Driver Type 

        Driver.(VehName).Long.mVehicle.Units         = 'kg';
        Driver.(VehName).Long.mVehicle.Comments      = 'Vehicle.Chassis.Body.m.Value';
        Driver.(VehName).Long.FTractive.Units        = 'N';
        Driver.(VehName).Long.tDriver.Units          = 's';
        Driver.(VehName).Long.xPreview.Units         = 'm';
        Driver.(VehName).Long.NDragRoll.Units        = 'N';
        Driver.(VehName).Long.NDragRollDriveline.Units = 'N*s/m';
        Driver.(VehName).Long.NDragAero.Units        = 'N*s^2/m^2';
        Driver.(VehName).Long.gGravity.Units         = 'm/s^2';
        Driver.(VehName).Long.fAccelCutoff.Units     = '1/s';
        Driver.(VehName).Long.fBrakeCutoff.Units     = '1/s';
        Driver.(VehName).Long.FFLookahead.Units        = 's';
        Driver.(VehName).Vis.clr = [1 0.4 0.4];
        Driver.(VehName).Long.NRollingResistance.Units = '1';
        Driver.(VehName).Long.NRoadFriction.Units      = '1';
        Driver.(VehName).Vis.opc = 0.2*0;
        Driver.(VehName).Long.Kp.Units                 = '1';
        Driver.(VehName).Long.Ki.Units                 = '1';
        Driver.(VehName).Long.gMaxAccel.Units          = 'm/s^2';
        Driver.(VehName).Long.gMaxDecel.Units          = 'm/s^2';

        % Add to DDatabase
        DDatabase.(ManvName).(VehName).Long     = Driver.(VehName).Long;
        DDatabase.(ManvName).(VehName).Lateral  = Driver.(VehName).Lateral;
        DDatabase.(ManvName).(VehName).Type     = ManvName;
        DDatabase.(ManvName).(VehName).Instance = VehName;
        DDatabase.(ManvName).(VehName).Vis      = Driver.(VehName).Vis;    
    end
end


%% Assemble database of drivers - closed loop, longitudinal only

% Get list of maneuver names (long only)
Mnames = cl_manv_longOnly;
num_M  = length(Mnames);

% Get list of vehicle names
Vnames = fieldnames(Driver);
num_V  = size(Vnames,1);

% Loop over list of maneuvers
for Mi = 1:num_M
    % Loop over list of vehicles
	ManvName = Mnames{Mi};
    for Vi = 1:num_V
    	VehName = Vnames{Vi};

        % Add placeholder Units and Comments
        LoNames = fieldnames(Driver.(VehName).drvCycle.Long);
        for LOi = 1:length(LoNames)
            LoName = LoNames{LOi};
            Driver.(VehName).drvCycle.Long.(LoName).Units    = '';
            Driver.(VehName).drvCycle.Long.(LoName).Comments = '';
        end
        
        % Add placeholder Units and Comments
        FNames = fieldnames(Driver.(VehName).drvCycle.Filter);
        for Fi = 1:length(FNames)
            FName = FNames{Fi};
            Driver.(VehName).drvCycle.Filter.(FName).Units    = '';
            Driver.(VehName).drvCycle.Filter.(FName).Comments = '';
        end

        % Add Specific Units and Comments
        Driver.(VehName).drvCycle.Long.Ki.Comments   = 'Integral gain longitudinal driver';
        Driver.(VehName).drvCycle.Long.Kp.Comments   = 'Proportional gain longitudinal driver';

        Driver.(VehName).drvCycle.Filter.Reference.Units = 'Hz';
        Driver.(VehName).drvCycle.Filter.Measured.Units  = 'Hz';

        Driver.(VehName).Vis.clr = [1 0.4 0.4];
        Driver.(VehName).Vis.opc = 0.2*0;

        % Add to DDatabase
        DDatabase.(ManvName).(VehName).Long     = Driver.(VehName).drvCycle.Long;
        DDatabase.(ManvName).(VehName).Filter   = Driver.(VehName).drvCycle.Filter;
        DDatabase.(ManvName).(VehName).Type     = ManvName;
        DDatabase.(ManvName).(VehName).Instance = VehName;
        DDatabase.(ManvName).(VehName).Vis      = Driver.(VehName).Vis;                
    end
end
assignin('base','DDatabase',DDatabase);