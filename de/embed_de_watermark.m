function watermarkedSignal = embed_de_watermark(signal, watermarkBits)
%EMBED_DE_WATERMARK Embed a 1-bit DE watermark in X and Y.
%   signal         : [N x M], watermark is applied to columns 1 and 2
%   watermarkBits  : [floor(N/2) x 2], binary values

    if size(signal, 2) < 2
        error('signal must have at least two columns (X and Y).');
    end

    numRows = size(signal, 1);
    numPairs = floor(numRows / 2);

    if ~isequal(size(watermarkBits), [numPairs, 2])
        error('watermarkBits must be floor(size(signal,1)/2)-by-2.');
    end

    if any(watermarkBits(:) ~= 0 & watermarkBits(:) ~= 1)
        error('watermarkBits must contain only 0 or 1.');
    end

    watermarkedSignal = signal;

    for pairIndex = 1:numPairs
        row1 = 2 * pairIndex - 1;
        row2 = 2 * pairIndex;

        for columnIndex = 1:2
            sample1 = double(signal(row1, columnIndex));
            sample2 = double(signal(row2, columnIndex));
            watermarkBit = double(watermarkBits(pairIndex, columnIndex));

            differenceValue = sample1 - sample2;
            averageValue = floor((sample1 + sample2) / 2);
            expandedDifference = 2 * differenceValue + watermarkBit;

            sample1Watermarked = averageValue + floor((expandedDifference + 1) / 2);
            sample2Watermarked = averageValue - floor(expandedDifference / 2);

            watermarkedSignal(row1, columnIndex) = sample1Watermarked;
            watermarkedSignal(row2, columnIndex) = sample2Watermarked;
        end
    end
end
