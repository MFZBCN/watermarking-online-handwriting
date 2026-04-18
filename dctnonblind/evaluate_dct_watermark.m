function [mseValue, maeValue, bitErrorPercent] = evaluate_dct_watermark(originalXY, watermarkedXY, watermarkXY, extractedWatermark, numBits)
%EVALUATE_DCT_WATERMARK Evaluate DCT watermarking distortion and BER.
%   [mseValue, maeValue, bitErrorPercent] = evaluate_dct_watermark( ...
%       originalXY, watermarkedXY, watermarkXY, extractedWatermark, numBits)

    if ~isequal(size(originalXY), size(watermarkedXY))
        error('originalXY and watermarkedXY must have the same size.');
    end

    if ~isequal(size(watermarkXY), size(extractedWatermark))
        error('watermarkXY and extractedWatermark must have the same size.');
    end

    if ~isscalar(numBits) || numBits < 1 || numBits ~= floor(numBits)
        error('numBits must be a positive integer.');
    end

    mseValue = mean((double(originalXY) - double(watermarkedXY)).^2, 'all');
    maeValue = mean(abs(double(originalXY) - double(watermarkedXY)), 'all');

    originalXBits = dec2bin(uint16(watermarkXY(:,1)), numBits) == '1';
    originalYBits = dec2bin(uint16(watermarkXY(:,2)), numBits) == '1';
    extractedXBits = dec2bin(uint16(extractedWatermark(:,1)), numBits) == '1';
    extractedYBits = dec2bin(uint16(extractedWatermark(:,2)), numBits) == '1';

    errorBitsX = sum(xor(originalXBits, extractedXBits), 'all');
    errorBitsY = sum(xor(originalYBits, extractedYBits), 'all');

    totalBits = 2 * size(watermarkXY,1) * numBits;
    bitErrorPercent = 100 * (errorBitsX + errorBitsY) / totalBits;
end