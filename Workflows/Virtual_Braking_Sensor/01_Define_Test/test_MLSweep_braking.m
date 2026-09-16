function [testInputs, minMachParams, Init] = test_MLSweep_braking(modelName,minMachParams,testSettings,Init,vSpd,qSlope,qStr,qLift,qTilt,mLoad,stopTime)

Init.Vehicle.pitch = qSlope;
Init.Vehicle.px    = 0;

testInputs = createInputDataset(modelName, "UpdateDiagram", false);

minMachParams.initCond.steerAngle = qStr;

testInputs{1} = timeseries([minMachParams.initCond.steerAngle minMachParams.initCond.steerAngle minMachParams.initCond.steerAngle -minMachParams.initCond.steerAngle]',...
    [0 1 stopTime-1 stopTime]',...
    'Name',testInputs{1}.Name);

% Bucket Tilt Angle - constant for all tests
minMachParams.initCond.bucketAngle = qTilt;
testInputs{3}.time = [0 stopTime]';
testInputs{3}.data = [minMachParams.initCond.bucketAngle minMachParams.initCond.bucketAngle]';

% Boom Lift Angle
minMachParams.initCond.boomAngle = qLift;
testInputs{2} = timeseries([qLift qLift]',...
    [0 stopTime]',...
    'Name',testInputs{2}.Name);

% Vehicle Speed
testInputs{4} = timeseries([0 0 vSpd vSpd]',...
    [0 testSettings.initSettlingTime testSettings.initSettlingTime+testSettings.speedRampTime stopTime]',...
    'Name',testInputs{4}.Name);

assignin('base','targetSpeedMag',abs(vSpd));
assignin('base','bucketLoadMass',mLoad); 