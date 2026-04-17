function [extractedWatermark, recoveredSignal] = extract_de_watermark(watermarkedSignal)
%EXTRACT_DE_WATERMARK Extract DE watermark and recover original X/Y.
%   watermarkedSignal : [N x M], only columns 1 and 2 are processed
%   extractedWatermark: [floor(N/2) x 2]
%   recoveredSignal   : [N x 2]

    if size(watermarkedSignal, 2) < 2
        error('watermarkedSignal must have at least two columns (X and Y).');
    end

    numRows = size(watermarkedSignal, 1);
    numPairs = floor(numRows / 2);

    extractedWatermark = zeros(numPairs, 2);
    recoveredSignal = watermarkedSignal(:,1:2);

    for pairIndex = 1:numPairs
        row1 = 2 * pairIndex - 1;
        row2 = 2 * pairIndex;

        [x1Recovered, x2Recovered, bitX] = de_extract_pair( ...
            watermarkedSignal(row1,1), watermarkedSignal(row2,1));

        [y1Recovered, y2Recovered, bitY] = de_extract_pair( ...
            watermarkedSignal(row1,2), watermarkedSignal(row2,2));

        recoveredSignal(row1,1) = x1Recovered;
        recoveredSignal(row2,1) = x2Recovered;
        recoveredSignal(row1,2) = y1Recovered;
        recoveredSignal(row2,2) = y2Recovered;

        extractedWatermark(pairIndex,1) = bitX;
        extractedWatermark(pairIndex,2) = bitY;
    end

    if mod(numRows, 2) == 1
        recoveredSignal(numRows,1:2) = watermarkedSignal(numRows,1:2);
    end
end
