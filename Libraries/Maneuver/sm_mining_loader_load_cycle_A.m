%% Init Params

minMachParams.initCond.bucketAngle = 0;
minMachParams.Control.Tilt.initPos  = minMachParams.initCond.bucketAngle;

Init.Vehicle.pitch = 0;
Init.Vehicle.px = 5;

% Trajectory for driver model

% To first corner
phaseA.x.Value  = [linspace(-10,-1,10) linspace(0,0.9,10) linspace(1,48,48) 50*ones(1,30)];
phaseA.y.Value  = [linspace(  0, 0,10) linspace(0,0  ,10) linspace(0, 0,48) linspace( -2,-30, 30)];
yIndSlowEnd     = find(phaseA.y.Value<=-18,1);
yIndSlowSta     = find(phaseA.y.Value<=-10,1);
phaseA.vx.Value = phaseA.x.Value*0+5;
phaseA.vx.Value(yIndSlowSta:yIndSlowEnd) = linspace(5,0,yIndSlowEnd-yIndSlowSta+1);
phaseA.vx.Value(yIndSlowEnd:end) = 0;

phaseB.x.Value = [linspace(78,-5,83) ];
phaseB.y.Value = [linspace(6, 6, 83) ];
yIndSlowEnd     = find(phaseB.x.Value<=11,1);
yIndSlowSta     = find(phaseB.x.Value<=6,1);
phaseB.vx.Value = phaseB.y.Value*0+5;
phaseB.vx.Value(yIndSlowSta:yIndSlowEnd) = linspace(5,0,yIndSlowEnd-yIndSlowSta+1);
phaseB.vx.Value(yIndSlowEnd:end) = 0;

Maneuver.Trajectory.x.Value = [phaseA.x.Value phaseB.x.Value];
Maneuver.Trajectory.y.Value = [phaseA.y.Value phaseB.y.Value];
Maneuver.Trajectory.vx.Value =[phaseA.vx.Value phaseB.vx.Value];

clear phaseA phaseB yIndSlowSta yIndSlowEnd

Maneuver.Trajectory.z.Value = Maneuver.Trajectory.y.Value*0;
Maneuver.Trajectory.aYaw.Value = [0 atan2(diff(Maneuver.Trajectory.y.Value),diff(Maneuver.Trajectory.x.Value))];
Maneuver.Trajectory.xTrajectory.Value = cumsum([0 sqrt((diff(Maneuver.Trajectory.x.Value).^2+diff(Maneuver.Trajectory.y.Value).^2))]);

% Parameters for driver model
Maneuver.xPreview.x.Value = [0 5 10]+10;
Maneuver.xPreview.v.Value = [0 5 10];
Maneuver.xMaxLat.Value = 3;
Maneuver.vMinTarget.Value = 5;
Maneuver.vGain.Value = 1;

Maneuver.nPreviewPoints.Value = 5;
Maneuver.nPreviewPoints.Units = '';
Maneuver.nPreviewPoints.Comments = 'For Pure Pursuit Driver';

% Open loop commands for implement
Maneuver.Impl.Boom.t.Value = [0 1 79 80 85 150];
Maneuver.Impl.Boom.q.Value = [0 0  0  0 35 35];

Maneuver.Impl.Bucket.t.Value = [0   82  86  160  165  175];
Maneuver.Impl.Bucket.q.Value = [0    0 -45  -45   45   45];

% Override and open loop commands for reverse phase of maneuver
Maneuver.Override.aSteer.t.Value  = [0 80 86     120 125 150  158  159  160];
Maneuver.Override.aSteer.On.Value = [0  0  1       1   0   0    0    1    1];
Maneuver.Steer.t.Value       =      [0 80 86 100 106 115 119 123 150 158 160];
Maneuver.Steer.aWheel.Value  =      [0  0  0   0  13  13 -10   0   0   0   0]/15*(25/(180/pi));

Maneuver.Override.Accel.t.Value   = [0 79 80     120 125 149 150];
Maneuver.Override.Accel.On.Value  = [0  0  0       0   0   0   0];
Maneuver.Accel.t.Value       =      [0 80 86  100 105 115 120 150];
Maneuver.Accel.rPedal.Value  =      [0  0  0    0   0   0   0   0];

Maneuver.Override.Brake.t.Value    = [0 80 86     149 150];
Maneuver.Override.Brake.On.Value   = [0  0  0       0   0];
Maneuver.Brake.t.Value             = [0 80 86  100 105 115 120 150];
Maneuver.Brake.rPedal.Value        = [0  0  0    0   0   0   0   0];

Maneuver.Override.vTarget.t.Value  = [0 94 95 100 108 120 125 150];
Maneuver.Override.vTarget.On.Value = [0  0  1   1   1   1   0   0];
Maneuver.vTarget.t.Value           = [0 94 95  100 110 120 121 150];
Maneuver.vTarget.kph.Value         = [0  0  -5  -5  -5  0   0   0];


