function BrakingDist = findLoaderBrkDist_integVel(logsoutRes)

brakeSigTmp = logsoutRes.find('BrakeSignal');
% Start of the braking event
brakeStartIdx = find(diff(brakeSigTmp.Values.Data)==1,1)+1;
% Speed signal
if ~isempty(brakeStartIdx)
    % Calculate distance from speed
    speedSig = logsoutRes.find('BodyVx');
    speedSigMPS = abs(speedSig.Values.Data*1000/3600);
    BrakingDist = trapz(speedSig.Values.Time(brakeStartIdx:end),speedSigMPS(brakeStartIdx:end));
end