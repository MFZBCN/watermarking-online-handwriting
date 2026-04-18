% DCT Nonblind watermarking
% Description available in the reference:
% Faundez-Zanuy, M. Online Signature Watermarking in the Transform Domain. 
% Cogn Comput 17, 79 (2025). 
% https://doi.org/10.1007/s12559-025-10436-y
clear; close all; clc;
rng(0);

addpath('../io', '../utils', '../dctnonblind');

% Example input file included in the repository
inputFile = '../examples/0002v00.fpg';

% Read signature
[signal, numSamples, numComponents, sampleRate] = read_fpg_signature(inputFile); 
if isempty(signal) || numSamples == 0
    error('Could not read signature file: %s', inputFile);
end

% Center X/Y
signal(:,1:2) = center_signature_xy(signal(:,1:2));
signalXY = signal(:,1:2);

% DCT watermarking parameters
numBits = 1;      % Multibit watermark: bits per sample and per coordinate
alpha = 10;       % Embedding strength

% Generate watermark
watermarkXY = generate_dct_watermark(size(signalXY,1), numBits);

% Embed watermark
watermarkedXY = embed_dct_watermark_nonblind(signalXY, watermarkXY, alpha, numBits);

% Extract watermark (non-blind: requires original signal)
extractedWatermark = extract_dct_watermark_nonblind(signalXY, watermarkedXY, alpha, numBits);

% Evaluate distortion and extraction error
[mseValue, maeValue, bitErrorPercent] = evaluate_dct_watermark( ...
    signalXY, watermarkedXY, watermarkXY, extractedWatermark, numBits);

% Sample-by-sample difference
diffXY = watermarkedXY - signalXY;
diffDist = sqrt(sum(diffXY.^2, 2));

fprintf('Input file: %s\n', inputFile);
fprintf('DCT watermarking (non-blind)\n');
fprintf('numBits = %d\n', numBits);
fprintf('alpha = %g\n', alpha);
fprintf('MSE = %g\n', mseValue);
fprintf('MAE = %g\n', maeValue);
fprintf('Bit error rate = %g %%\n', bitErrorPercent);
fprintf('Mean abs. difference in X = %g\n', mean(abs(diffXY(:,1))));
fprintf('Mean abs. difference in Y = %g\n', mean(abs(diffXY(:,2))));
fprintf('Max abs. difference in X = %g\n', max(abs(diffXY(:,1))));
fprintf('Max abs. difference in Y = %g\n', max(abs(diffXY(:,2))));
fprintf('Mean Euclidean difference = %g\n', mean(diffDist));
fprintf('Max Euclidean difference = %g\n', max(diffDist));

figure('Name', 'DCT watermarking');

subplot(3,1,1);
plot(signalXY(:,1), signalXY(:,2), 'k', 'LineWidth', 1.2);
grid on;
axis equal;
title('Original');
xlabel('X');
ylabel('Y');
set(gca, 'FontSize', 12);

subplot(3,1,2);
plot(watermarkedXY(:,1), watermarkedXY(:,2), 'b', 'LineWidth', 1.2);
grid on;
axis equal;
title(sprintf('DCT watermarked (%d bits, \\alpha = %g)', numBits, alpha));
xlabel('X');
ylabel('Y');
set(gca, 'FontSize', 12);

subplot(3,1,3);
plot(diffXY(:,1), 'b', 'LineWidth', 1.0); hold on;
plot(diffXY(:,2), 'r', 'LineWidth', 1.0);
plot(diffDist, 'k', 'LineWidth', 1.0);
grid on;
title('Difference between original and DCT watermarked');
xlabel('Sample index');
ylabel('Difference');
legend('\DeltaX', '\DeltaY', 'Euclidean distance');
set(gca, 'FontSize', 12);