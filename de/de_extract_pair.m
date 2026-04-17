function [sample1Recovered, sample2Recovered, extractedBit] = de_extract_pair(sample1Watermarked, sample2Watermarked)
%DE_EXTRACT_PAIR Recover one DE pair and its embedded bit.

    expandedDifference = double(sample1Watermarked) - double(sample2Watermarked);
    extractedBit = mod(expandedDifference, 2);

    originalDifference = floor(expandedDifference / 2);
    averageValue = floor((double(sample1Watermarked) + double(sample2Watermarked)) / 2);

    sample1Recovered = averageValue + floor((originalDifference + 1) / 2);
    sample2Recovered = averageValue - floor(originalDifference / 2);
end
