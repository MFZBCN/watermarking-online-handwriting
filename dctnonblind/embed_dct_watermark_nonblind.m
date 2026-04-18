function watermarkedSignal = embed_dct_watermark_nonblind(signalXY, watermarkXY, alpha, numBits)
%EMBED_DCT_WATERMARK_NONBLIND Embed a DCT-domain non-blind watermark.
%   watermarkedSignal = embed_dct_watermark_nonblind(signalXY, watermarkXY, alpha, numBits)
%
%   Inputs:
%       signalXY      - [N x 2] original signal
%       watermarkXY   - [N x 2] watermark values
%       alpha         - embedding strength
%       numBits       - number of bits per sample
%
%   Output:
%       watermarkedSignal - [N x 2] watermarked signal
%
%   Notes:
%   - The same function is used for both single-bit and multi-bit watermarking.
%   - numBits = 1 corresponds to the single-bit case.
%   - numBits > 1 corresponds to the multi-bit case.

    if size(signalXY,2) ~= 2
        error('signalXY must be an N-by-2 matrix.');
    end

    if ~isequal(size(signalXY), size(watermarkXY))
        error('watermarkXY must have the same size as signalXY.');
    end

    if ~isscalar(alpha) || ~isfinite(alpha) || alpha <= 0
        error('alpha must be a positive finite scalar.');
    end

    if ~isscalar(numBits) || numBits < 1 || numBits ~= floor(numBits)
        error('numBits must be a positive integer.');
    end

    maxValue = 2^numBits - 1;
    if any(watermarkXY(:) < 0) || any(watermarkXY(:) > maxValue) || ...
       any(watermarkXY(:) ~= floor(watermarkXY(:)))
        error('watermarkXY values must be integers in the range [0, 2^numBits - 1].');
    end

    originalX = double(signalXY(:,1));
    originalY = double(signalXY(:,2));
    watermarkX = double(watermarkXY(:,1));
    watermarkY = double(watermarkXY(:,2));

    dctOriginalX = dct(originalX);
    dctOriginalY = dct(originalY);

    dctWatermarkedX = dctOriginalX + alpha * watermarkX;
    dctWatermarkedY = dctOriginalY + alpha * watermarkY;

    watermarkedX = round(idct(dctWatermarkedX));
    watermarkedY = round(idct(dctWatermarkedY));

    watermarkedSignal = [watermarkedX, watermarkedY];
end