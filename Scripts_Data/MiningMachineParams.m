%% Mining Machine Parameters
% Links to design reference materials
% https://www.youtube.com/watch?v=GdkpGphOpWg
% https://www.epiroc.com/content/dam/epiroc/underground-mining-and-tunneling/lhd/electric-scooptram/scooptram-st14-sg/technical-specification/9869%200237%2001b%20Scooptram%2014%20SG%20Technical%20Specification_digital.pdf

%% Mass
% 42,000 kg target total mass
% Major Structural Components
minMachParams.rearChassis.mass = 8000; % [kg]
minMachParams.topChassis.mass = 5000; % [kg]
minMachParams.frontChassis.mass = 1000; % [kg]
minMachParams.upperRearChassis.mass = 4450; % [kg]
minMachParams.frontFrame.mass = 8600;   
minMachParams.boom.mass = 4400;        
minMachParams.bucket.mass = 4300;      

% Wheels and tires
minMachParams.tire.mass = 500;         
minMachParams.wheel.mass = 400;        

% Z-Bar Linkage Components
minMachParams.bucketTiltRockerArm.mass = 550;
minMachParams.bucketLink.mass = 230;

% Bucket Tilt 
minMachParams.bucketTiltCyl.mass = 320;
minMachParams.bucketTiltRod.mass = 210;

% Boom Lift
minMachParams.boomLiftCyl.mass = 260;  
minMachParams.boomLiftRod.mass = 170;  

% Steering
minMachParams.steerCyl.mass = 130;     
minMachParams.steerRod.mass = 95;      

%% Performance & Motion 
% Functions
minMachParams.steering.minAngle = -42; % [deg]
minMachParams.steering.maxAngle = 42; % [deg]
minMachParams.boomLift.minAngle = -4; % [deg]
minMachParams.boomLift.maxAngle = 45; % [deg]
minMachParams.bucketTilt.minAngle = -45; % [deg]
minMachParams.bucketTilt.maxAngle = 45; % [deg]

% Vehicle
minMachParams.maxVehSpeed.forward = 12; % [km/hr]
minMachParams.maxVehSpeed.reverse = -12; % [km/hr]
minMachParams.maxVehSpeeds.emptyFirstGear = 4.4; % [km/hr] Empty Bucket
minMachParams.maxVehSpeeds.emptySecondGear = 11.1; % [km/hr] Empty Bucket
minMachParams.maxVehSpeeds.emptyThirdGear = 18.5; % [km/hr] Empty Bucket
minMachParams.maxVehSpeeds.emptyFourthGear = 33.2; % [km/hr] Empty Bucket

% Electric Motor
minMachParams.electricMotor.speeds = [0, 800, 1200, 2550]; % [rpm]
minMachParams.electricMotor.torque = [2500, 2500, 1100, 1100]; % [Nm]

% Transmission
minMachParams.transmission.gearRatios = [170, 68, 41, 23];

% Braking
% For Disc Friction Clutch block 
minMachParams.braking.outerDiameter = 60; % [mm] 
minMachParams.braking.innerDiameter = 50; % [mm] 
minMachParams.braking.numPlates = 3; % 
minMachParams.braking.engagementPistonArea = 0.045; % [m^2]

% For Disc Brake block
minMachParams.braking.meanPadRadius = 41.25; % [mm] 
minMachParams.braking.cylinderBore = sqrt(0.045/pi)*2; % [m]
minMachParams.braking.numPads = 2;
minMachParams.braking.breakawayFricVel = 0.01; % [rad/s]
minMachParams.braking.viscousFricCoeff = 0;    % [N*m/(rad/s)]

minMachParams.braking.staticFriction = 0.45;
minMachParams.braking.kineticFriction = 0.35;
minMachParams.brakes.engagementThresholdPres = 2e5; % [Pa]
minMachParams.braking.springPressure = 1.5e7; % [Pa] 
minMachParams.braking.maxHydraulicPres = 2.7e7; % [Pa] 

% Braking
minMachParams.driveshaft.k = 1e7; % [N*m/rad] 
minMachParams.driveshaft.d = 1e5*100; % [N*m*s/rad] 
minMachParams.driveshaft.trqCou = 0; % [N*m] 
minMachParams.driveshaft.sta2Kin = 1.1; % [N*m] 
minMachParams.driveshaft.wTol = 1e-1; % [rad/s] 
minMachParams.driveshaft.J    = 0.01; % [kg*m^2] 

%% Visual
minMachParams.visual.frameRefToBucketEdge = [4.15 0 0.07];
minMachParams.visual.chassisRefToRearEdge = [-3.125 0 0.02];
minMachParams.visual.Ts  = 2e-1;
%minMachParams.visual.clr = [0.3333 1 1];
minMachParams.visual.clr = [1 0 0];
minMachParams.visual.opc = 0.4;

%% Contact
minMachParams.contact.tireRad = 890; % [mm]
minMachParams.contact.stiffness = 1e7; % [N/m]
minMachParams.contact.damping = 1e6*100; % [N/(m/s)]
minMachParams.contact.transRegWidth = 1e-4*100; % [m]
minMachParams.contact.staticCoeff = 0.65; 
minMachParams.contact.dynamicCoeff = 0.5;
minMachParams.contact.critVel = 1e-2*10/10;

%% Susp
minMachParams.suspFront.k = 5e6;
minMachParams.suspFront.d = 1e5;
minMachParams.suspFront.xeq = -0.07/2;

minMachParams.suspRear.k   = 5e6;
minMachParams.suspRear.d   = 1e5;
minMachParams.suspRear.xeq = -0.07/2;


%% Terrain
minMachParams.terrain.maxSlope = 11.31; % [deg] based on 20% grade
minMachParams.terrain.minSlope = -11.31; % [deg] based on 20% grade

%% Initial Conditions
% Function angles
minMachParams.initCond.steerAngle = 0; % [deg]
minMachParams.initCond.boomAngle = 0; % [deg]
minMachParams.initCond.bucketAngle = -45; % [deg]

%% Setup
% Terrain
minMachParams.terrain.slope = 0; % [deg]

% Load cases
minMachParams.bucketLoad.full = 14000; % [kg]
minMachParams.bucketLoad.threeQuarter = minMachParams.bucketLoad.full*0.75; % [kg]
minMachParams.bucketLoad.oneQuarter = minMachParams.bucketLoad.full*0.25; % [kg]
minMachParams.bucketLoad.empty = 0; % [kg]

% Current load
minMachParams.bucketLoad.current = 'oneQuarter'; % full | threeQuarter | oneQuarter | empty
minMachParams.bucketLoad.mass = minMachParams.bucketLoad.(minMachParams.bucketLoad.current); % [kg]

%% Control
minMachParams.Control.Steer.propGain = 5e3;
minMachParams.Control.Steer.intgGain = 2e2;
minMachParams.Control.Steer.dervGain = 5e2;
minMachParams.Control.Steer.initPos  = 0;

minMachParams.Control.Lift.propGain = 5e3*100;
minMachParams.Control.Lift.intgGain = 2e2*100;
minMachParams.Control.Lift.dervGain = 5e2*100;
minMachParams.Control.Lift.initPos  = 0;

minMachParams.Control.Tilt.propGain = -1e5;
minMachParams.Control.Tilt.intgGain = -2e2*1;
minMachParams.Control.Tilt.dervGain = -5e2*10;
minMachParams.Control.Tilt.initPos  = minMachParams.initCond.bucketAngle*0;


%% For parameter tuning
terrainSlope   = minMachParams.terrain.slope;
bucketLoadMass = minMachParams.bucketLoad.mass;
initBoomAngle  = minMachParams.initCond.boomAngle;
stopTime       = 40;
targetSpeedMag = 10;

%% For kinematics lookup tables
minMachParams.kinematics.steer = load('Table_Kinematics_Steer.mat');
minMachParams.kinematics.lift  = load('Table_Kinematics_Lift.mat');
minMachParams.kinematics.tilt  = load('Table_Kinematics_Tilt.mat');

%% For sensor
load gpMdlCompact

