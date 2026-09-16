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
testInputs{1}.time = [0 stopTime]';
testInputs{1}.data = [0 0]';

% Bucket Tilt Angle - constant for all tests
%testInputs{3}.time = [0 stopTime]';
%testInputs{3}.data = [minMachParams.initCond.bucketAngle minMachParams.initCond.bucketAngle]';

testInputs{3} = timeseries([...
    minMachParams.bucketTilt.minAngle-1 minMachParams.bucketTilt.minAngle-1 ...
    minMachParams.bucketTilt.maxAngle+1 minMachParams.bucketTilt.maxAngle+1]',...
    [0 1 stopTime-1 stopTime]',...
    'Name',testInputs{2}.Name);


% Boom Lift Angle
%testInputs{2} = timeseries([...
%    minMachParams.boomLift.minAngle-1 minMachParams.boomLift.minAngle-1 ...
%    minMachParams.boomLift.maxAngle+1 minMachParams.boomLift.maxAngle+1]',...
%    [0 1 stopTime-1 stopTime]',...
%    'Name',testInputs{2}.Name);
testInputs{2}.time = [0 stopTime]';
testInputs{2}.data = [0+45 0+45]';

% Vehicle Speed
%testInputs{4} = timeseries([0 0 FullTestInputs.VehicleSpeed(testIdxToRun) FullTestInputs.VehicleSpeed(testIdxToRun)]',...
%    [0 testSettings.initSettlingTime testSettings.initSettlingTime+testSettings.speedRampTime stopTime]',...
%    'Name',testInputs{4}.Name);
testInputs{4}.time = [0 stopTime]';
testInputs{4}.data = [0 0]';

extInput_Mining_Loader_Sweep = testInputs;

out=sim('Mining_Loader_Sweep');

xTiltData = out.logsout_Mining_Loader_Sweep.get('Loader').Values.Vehicle.Tilt.A.p.Data;
qTiltData = out.logsout_Mining_Loader_Sweep.get('Loader').Values.Vehicle.Tilt.H.q.Data;

[qTiltUnique,ia] = unique(qTiltData,"stable"); 
xTiltUnique = xTiltData(ia);

qTilt = minMachParams.bucketTilt.minAngle:1:minMachParams.bucketTilt.maxAngle;

xTilt = interp1(qTiltUnique,xTiltUnique,qTilt);

figure(99)
plot(qTiltData,xTiltData,'--','Marker','d','DisplayName','RawL')
hold on
plot(qTilt,xTilt,'kx','DisplayName','Table L')
hold off

legend('Location','Best')
xlabel('Bucket Tilt Angle (deg)')
ylabel('Tilt Cylinder Position (m)')
title('Cylinder Position vs. Tilt Angle')

%save Table_Kinematics_Tilt qTilt xTilt
