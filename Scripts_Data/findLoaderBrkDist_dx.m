function BrakingDist = findLoaderBrkDist_dx(logsoutRes)

brakeSigTmp = logsoutRes.find('BrakeSignal');
% Start of the braking event
brakeStartIdx = find(diff(brakeSigTmp.Values.Data)==1,1)+1;
% Speed signal
if ~isempty(brakeStartIdx)
    % Calculate distance from speed
    px = logsoutRes.get('Loader').Values.World.x.Data;
    py = logsoutRes.get('Loader').Values.World.y.Data;
    pz = logsoutRes.get('Loader').Values.World.z.Data;
    BrakingDist = sqrt((px(brakeStartIdx)-px(end))^2+(py(brakeStartIdx)-py(end))^2+(pz(brakeStartIdx)-pz(end))^2);
else
    BrakingDist = NaN;
end