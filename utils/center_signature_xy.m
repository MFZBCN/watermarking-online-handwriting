function centeredSignal = center_signature_xy(xySignal, targetX, targetY)
%CENTER_SIGNATURE_XY Shift X/Y coordinates to a target center.
%   xySignal : [N x 2]
%   targetX  : target X center, default 0
%   targetY  : target Y center, default 0

    if nargin < 2
        targetX = 0;
    end
    if nargin < 3
        targetY = 0;
    end

    if size(xySignal, 2) ~= 2
        error('xySignal must be an N-by-2 matrix.');
    end

    meanX = round(mean(xySignal(:,1)));
    meanY = round(mean(xySignal(:,2)));

    centeredSignal = xySignal;
    centeredSignal(:,1) = xySignal(:,1) + (targetX - meanX);
    centeredSignal(:,2) = xySignal(:,2) + (targetY - meanY);
end
