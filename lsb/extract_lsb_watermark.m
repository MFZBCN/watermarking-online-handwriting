function extractedWatermark = extract_lsb_watermark(watermarkedSignal, numLsbBits)
%EXTRACT_LSB_WATERMARK Extract the numLsbBits least significant bits from X and Y.
%   watermarkedSignal : [N x M], only columns 1 and 2 are used
%   extractedWatermark: [N x 2]

    if size(watermarkedSignal, 2) < 2
        error('watermarkedSignal must have at least two columns (X and Y).');
    end

    if ~isscalar(numLsbBits) || numLsbBits < 1 || numLsbBits ~= floor(numLsbBits)
        error('numLsbBits must be an integer greater than or equal to 1.');
    end

    modulusValue = 2^numLsbBits;

    extractedWatermarkX = mod(watermarkedSignal(:,1), modulusValue);
    extractedWatermarkY = mod(watermarkedSignal(:,2), modulusValue);

    extractedWatermark = [extractedWatermarkX, extractedWatermarkY];
end
