modelName = 'Mining_Loader_Sweep';
open_system(modelName);
set_param([modelName '/Mining Loader'],...
    'popup_steer_actuation','Hinge Motion',...
    'popup_lift_actuation','Hinge Motion',...
    'popup_tilt_actuation','Hinge Motion'...
    )

bucketLoadMass = 0;

testInputs = createInputDataset(modelName, "UpdateDiagram", false);

% Steering Angle - constant for all tests
%testInputs{1}.time = [0 stopTime]';
%testInputs{1}.data = [minMachParams.initCond.steerAngle minMachParams.initCond.steerAngle]';


minMachParams.initCond.steerAngle = -45;

testInputs{1} = timeseries([minMachParams.initCond.steerAngle minMachParams.initCond.steerAngle -minMachParams.initCond.steerAngle -minMachParams.initCond.steerAngle]',...
    [0 1 stopTime-1 stopTime]',...
    'Name',testInputs{1}.Name);

% Bucket Tilt Angle - constant for all tests
testInputs{3}.time = [0 stopTime]';
testInputs{3}.data = [minMachParams.initCond.bucketAngle minMachParams.initCond.bucketAngle]';

% Boom Lift Angle
testInputs{2} = timeseries([0 0]',...
    [0 stopTime]',...
    'Name',testInputs{2}.Name);



% Vehicle Speed
%testInputs{4} = timeseries([0 0 FullTestInputs.VehicleSpeed(testIdxToRun) FullTestInputs.VehicleSpeed(testIdxToRun)]',...
%    [0 testSettings.initSettlingTime testSettings.initSettlingTime+testSettings.speedRampTime stopTime]',...
%    'Name',testInputs{4}.Name);
testInputs{4}.time = [0 stopTime]';
testInputs{4}.data = [0 0]';

extInput_Mining_Loader_Sweep = testInputs;

out = sim('Mining_Loader_Sweep');

minMachParams.initCond.steerAngle = 0;

xStrLData = out.simlog_Mining_Loader_Sweep.Mining_Loader.Vehicle.Steer.Actuation.Hinge.Cylindrical_Left.Pz.p.series.values;
xStrRData = out.simlog_Mining_Loader_Sweep.Mining_Loader.Vehicle.Steer.Actuation.Hinge.Cylindrical_Right.Pz.p.series.values;
qFntRData = out.simlog_Mining_Loader_Sweep.Mining_Loader.Vehicle.Steer.Actuation.Hinge.Revolute_Front_Rear.Rz.q.series.values('deg');

%xStrLData  = out.logsout_Mining_Loader_Sweep.get('Loader').Values.Vehicle.Steer.L.p.Data;
%xStrRData  = out.logsout_Mining_Loader_Sweep.get('Loader').Values.Vehicle.Steer.R.p.Data;
%qFntRData  = out.logsout_Mining_Loader_Sweep.get('Loader').Values.Vehicle.Steer.H.q.Data;

[qFntRUnique,ia] = unique(qFntRData,"stable"); 
xStrLUnique = xStrLData(ia);
xStrRUnique = xStrRData(ia);

qSteer = -44:1:44;

xStrL = interp1(qFntRUnique,xStrLUnique,qSteer);
xStrR = interp1(qFntRUnique,xStrRUnique,qSteer);

figure(99)
plot(qFntRData,xStrLData,'--','Marker','d','DisplayName','RawL')
hold on
plot(qFntRData,xStrRData,'--','Marker','d','DisplayName','RawR')
plot(qSteer,xStrL,'k+','DisplayName','Table L')
plot(qSteer,xStrR,'k+','DisplayName','Table R')
hold off

legend('Location','Best')
xlabel('Steering Hinge Angle (deg)')
ylabel('Steer Cylinder Position (m)')
title('Cylinder Position vs. Steer Angle')

%save Table_Kinematics_Steer qSteer xStrL xStrR