function extractedWatermark = extract_dct_watermark_nonblind(originalXY, watermarkedXY, alpha, numBits)
%EXTRACT_DCT_WATERMARK_NONBLIND Extract a DCT-domain non-blind watermark.
%   extractedWatermark = extract_dct_watermark_nonblind(originalXY, watermarkedXY, alpha, numBits)
%
%   Inputs:
%       originalXY        - [N x 2] original signal
%       watermarkedXY     - [N x 2] watermarked signal
%       alpha             - embedding strength
%       numBits           - number of bits per sample
%
%   Output:
%       extractedWatermark - [N x 2] extracted watermark
%
%   Notes:
%   - The same function is used for both single-bit and multi-bit extraction.
%   - If numBits = 1, output values are clipped to {0,1}.
%   - If numBits > 1, output values are clipped to [0, 2^numBits - 1].

    if size(originalXY,2) ~= 2 || size(watermarkedXY,2) ~= 2
        error('originalXY and watermarkedXY must be N-by-2 matrices.');
    end

    if ~isequal(size(originalXY), size(watermarkedXY))
        error('originalXY and watermarkedXY must have the same size.');
    end

    if ~isscalar(alpha) || ~isfinite(alpha) || alpha <= 0
        error('alpha must be a positive finite scalar.');
    end

    if ~isscalar(numBits) || numBits < 1 || numBits ~= floor(numBits)
        error('numBits must be a positive integer.');
    end

    maxValue = 2^numBits - 1;

    originalX = double(originalXY(:,1));
    originalY = double(originalXY(:,2));
    watermarkedX = double(watermarkedXY(:,1));
    watermarkedY = double(watermarkedXY(:,2));

    extractedX = round((dct(watermarkedX) - dct(originalX)) / alpha);
    extractedY = round((dct(watermarkedY) - dct(originalY)) / alpha);

    extractedX = min(extractedX, maxValue);
    extractedY = min(extractedY, maxValue);

    extractedX = max(extractedX, 0);
    extractedY = max(extractedY, 0);

    extractedWatermark = [extractedX, extractedY];
end