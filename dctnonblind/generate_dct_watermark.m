function watermarkXY = generate_dct_watermark(numSamples, numBits)
%GENERATE_DCT_WATERMARK Generate a random watermark for DCT watermarking.
%   watermarkXY = generate_dct_watermark(numSamples, numBits)
%
%   Inputs:
%       numSamples - number of samples
%       numBits    - number of bits per sample
%
%   Output:
%       watermarkXY - [numSamples x 2] integer watermark
%
%   Notes:
%   - If numBits = 1, values are in {0,1}.
%   - If numBits > 1, values are in [0, 2^numBits - 1].

    if ~isscalar(numSamples) || numSamples < 1 || numSamples ~= floor(numSamples)
        error('numSamples must be a positive integer.');
    end

    if ~isscalar(numBits) || numBits < 1 || numBits ~= floor(numBits)
        error('numBits must be a positive integer.');
    end

    maxValue = 2^numBits - 1;
    watermarkXY = randi([0, maxValue], numSamples, 2);
end