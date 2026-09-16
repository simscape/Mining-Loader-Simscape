function BrakingDist = findLoaderBrkDist_estim(logsoutRes)

brakeSigTmp = logsoutRes.find('BrakeSignal');
% Start of the braking event
brakeStartIdx = find(diff(brakeSigTmp.Values.Data)==1,1)+1;

% If estimate is active, record estimate
xBrk = logsoutRes.get('Loader').Values.Sensor.xBrk.Data;
if(max(abs(xBrk))>1e-2)
    tBrk = logsoutRes.get('Loader').Values.World.x.Time(brakeStartIdx);
    BrakingDist = interp1(...
        logsoutRes.get('Loader').Values.Sensor.xBrk.Time, ...
        xBrk,tBrk);
else
    BrakingDist = NaN;
end