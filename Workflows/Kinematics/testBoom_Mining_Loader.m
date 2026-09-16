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
testInputs{3}.time = [0 stopTime]';
testInputs{3}.data = [minMachParams.initCond.bucketAngle minMachParams.initCond.bucketAngle]';

% Boom Lift Angle
testInputs{2} = timeseries([...
    minMachParams.boomLift.minAngle-1 minMachParams.boomLift.minAngle-1 ...
    minMachParams.boomLift.maxAngle+1 minMachParams.boomLift.maxAngle+1]',...
    [0 1 stopTime-1 stopTime]',...
    'Name',testInputs{2}.Name);

% Vehicle Speed
%testInputs{4} = timeseries([0 0 FullTestInputs.VehicleSpeed(testIdxToRun) FullTestInputs.VehicleSpeed(testIdxToRun)]',...
%    [0 testSettings.initSettlingTime testSettings.initSettlingTime+testSettings.speedRampTime stopTime]',...
%    'Name',testInputs{4}.Name);
testInputs{4}.time = [0 stopTime]';
testInputs{4}.data = [0 0]';

extInput_Mining_Loader_Sweep = testInputs;

out=sim('Mining_Loader_Sweep');

xLiftLData = out.logsout_Mining_Loader_Sweep.get('Loader').Values.Vehicle.Lift.L.p.Data;
xLiftRData = out.logsout_Mining_Loader_Sweep.get('Loader').Values.Vehicle.Lift.R.p.Data;
qBoomData = out.logsout_Mining_Loader_Sweep.get('Loader').Values.Vehicle.Lift.H.q.Data;

[qFntRUnique,ia] = unique(qBoomData,"stable"); 
xLiftLUnique = xLiftLData(ia);
xLiftRUnique = xLiftRData(ia);

qLift = minMachParams.boomLift.minAngle:1:minMachParams.boomLift.maxAngle;

xLiftL = interp1(qFntRUnique,xLiftLUnique,qLift);
xLiftR = interp1(qFntRUnique,xLiftRUnique,qLift);

figure(99)
plot(qBoomData,xLiftLData,'--','Marker','d','DisplayName','RawL')
hold on
plot(qBoomData,xLiftRData,'--','Marker','o','DisplayName','RawR')
plot(qLift,xLiftL,'bx','DisplayName','Table L')
plot(qLift,xLiftR,'r+','DisplayName','Table R')
hold off
legend('Location','Best')
xlabel('Boom Lift Angle (deg)')
ylabel('Lift Cylinder Position (m)')
title('Cylinder Position vs. Lift Angle')

%save Table_Kinematics_Lift qLift xLiftL xLiftR
