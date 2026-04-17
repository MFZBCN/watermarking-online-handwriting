function watermarkedSignal = embed_lsb_watermark(signal, numLsbBits, watermarkX, watermarkY)
%EMBED_LSB_WATERMARK Replace the numLsbBits least significant bits of X and Y.
%   signal       : [N x M], watermark is applied to columns 1 and 2
%   numLsbBits   : integer >= 1
%   watermarkX   : [N x 1], values in [0, 2^numLsbBits - 1]
%   watermarkY   : [N x 1], values in [0, 2^numLsbBits - 1]

    if size(signal, 2) < 2
        error('signal must have at least two columns (X and Y).');
    end

    if ~isscalar(numLsbBits) || numLsbBits < 1 || numLsbBits ~= floor(numLsbBits)
        error('numLsbBits must be an integer greater than or equal to 1.');
    end

    numRows = size(signal, 1);
    if ~isequal(size(watermarkX), [numRows, 1]) || ~isequal(size(watermarkY), [numRows, 1])
        error('watermarkX and watermarkY must be column vectors with size(signal,1) rows.');
    end

    maxWatermarkValue = 2^numLsbBits - 1;
    if any(watermarkX < 0 | watermarkX > maxWatermarkValue) || ...
       any(watermarkY < 0 | watermarkY > maxWatermarkValue)
        error('Watermark values must be in the range [0, 2^numLsbBits - 1].');
    end

    watermarkedSignal = signal;
    quantizationStep = 2^numLsbBits;

    watermarkedSignal(:,1) = quantizationStep * floor(double(signal(:,1)) / quantizationStep) + double(watermarkX);
    watermarkedSignal(:,2) = quantizationStep * floor(double(signal(:,2)) / quantizationStep) + double(watermarkY);
end
