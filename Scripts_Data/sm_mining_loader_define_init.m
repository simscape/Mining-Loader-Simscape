function IDatabase = sm_mining_loader_define_init %(MDatabase)

whlRad = evalin('base','minMachParams.contact.tireRad')/1000;
Init = struct;
Init.Instance = 'Tractor';
Init.Type = 'Flat';
Init.Vehicle.px = 0;  % m
Init.Vehicle.py = 0;  % m
Init.Vehicle.pz = 0.55*0;  % m
Init.Vehicle.vx = 0;
Init.Vehicle.vy = 0;
Init.Vehicle.vz = 0;
Init.Vehicle.yaw = -pi/2*0;
Init.Vehicle.pitch = 0;
Init.Vehicle.roll = 0;
Init.Wheel.wRFL    = 0;
Init.Wheel.wRFR    = 0;
Init.Wheel.wRRL    = 0;
Init.Wheel.wRRR    = 0;
Init.Wheel.wFL    = 0;
Init.Wheel.wFR    = 0;

% Original paths all start at [0 0 0] along +x
IDatabase.Flat      = Init;
%IDatabase.Passes4Curve_Loop = Init;
%IDatabase.Triangle_12Passes = Init;

%IDatabase.Orchard_2Passes   = Init;
%{
IDatabase.Orchard_2Passes.Chassis.sChassis.Value = [...
    MDatabase.Orchard_2Passes.Trajectory.x.Value(1) ...
    MDatabase.Orchard_2Passes.Trajectory.y.Value(1) ...
    MDatabase.Orchard_2Passes.Trajectory.z.Value(1)];

IDatabase.Uneven_Road   = Init;
IDatabase.Uneven_Road.Chassis.sChassis.Value = [...
    MDatabase.Uneven_Road.Trajectory.x.Value(1) ...
    MDatabase.Uneven_Road.Trajectory.y.Value(1) ...
    MDatabase.Uneven_Road.Trajectory.z.Value(1)+0.50];


IDatabase.Testrig           = Init;
IDatabase.Testrig.Chassis.vChassis.Value = 0;
IDatabase.Testrig.Axle1.nWheel.Value     = [0 0 0.88];
IDatabase.Testrig.Axle1.nWheel.Value     = [0 0 0.88];


%sm_tractor_steering_define_init_test_centre
%IDatabase.Test_Centre       = Init;

%Init = IDatabase.Passes4_Loop;
%}