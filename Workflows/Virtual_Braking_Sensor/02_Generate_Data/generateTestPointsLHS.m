function [allTests] = generateTestPointsLHS(numRuns,minMachParams)

%GENERATETESTPOINTS Generate parameter sweep combinations.
%
% Inputs
%   minMachParams         Vehicle parameter structure
%   numBoomPoints         Number of boom angle points
%   numVehSpeedPoints     Number of vehicle speed points
%   numSlopePoints        Number of slope points
%   numBucketLoadPoints   Number of bucket load points
%
% Outputs
%   allTests              Table containing all parameter combinations
%   testPoints            Structure containing individual sweep vectors

%% Boom Lift

%numRuns = 1000; % Run 1000 runs
numVarying = 4;
% numRuns = 2; % Test mode

% Create a doe table for the varying inputs, scaling by the range of the input variables
doeTable = array2table(lhsdesign(numRuns,numVarying),VariableNames=["BoomAngle","VehicleSpeed","Slope","BucketLoad"]);
%minBounds = parTableVal.Min(useIdx)';
minBounds = [0, minMachParams.maxVehSpeed.reverse,minMachParams.terrain.maxSlope,0]; % Sign reverse on slope on purpose
%maxBounds = parTableVal.Max(useIdx)';
maxBounds = [minMachParams.boomLift.maxAngle, minMachParams.maxVehSpeed.forward,minMachParams.terrain.minSlope,minMachParams.bucketLoad.full];
doeTable = doeTable.*(maxBounds-minBounds) + minBounds;

% Add rows to runTable
%inputValues = parTableVal.Default;
for row=1:height(doeTable)
    runRow = array2table([0 0 0 0],VariableNames=["BoomAngle","VehicleSpeed","Slope","BucketLoad"]);
    runTable(row,:) = doeTable(row,:);
    %runTable = [runTable; runRow];
end

% Add worst case conditions
%runRow = array2table(maxBounds,VariableNames=["BoomAngle","VehicleSpeed","Slope","BucketLoad"]);
%runTable = [runTable; runRow];
%runRow = array2table([maxBounds(1) minBounds(2) minBounds(3) maxBounds(4)],VariableNames=["BoomAngle","VehicleSpeed","Slope","BucketLoad"]);
%runTable = [runTable; runRow];

allTests = runTable;

end