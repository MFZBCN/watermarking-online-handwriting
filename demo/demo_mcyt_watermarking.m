clear; close all; clc;
rng(1);

addpath('../io', '../de', '../lsb', '../utils');

% Example input file included in the repository
inputFile = '../examples/0002v00.fpg';

% Read signature
[signal, numSamples, numComponents, sampleRate] = read_fpg_signature(inputFile);
if isempty(signal) || numSamples == 0
    error('Could not read signature file: %s', inputFile);
end

% Center X/Y
signal(:,1:2) = center_signature_xy(signal(:,1:2));

% ---------------- DE watermarking ----------------
numRows = size(signal, 1);
numPairs = floor(numRows / 2);
deWatermark = randi([0, 1], numPairs, 2);

signalDe = embed_de_watermark(signal, deWatermark);
[deWatermarkExtracted, signalRecoveredDe] = extract_de_watermark(signalDe);

deWatermarkOk = isequal(deWatermark, deWatermarkExtracted);
deRecoveryError = max(abs(signal(:,1:2) - signalRecoveredDe(:,1:2)), [], 'all');

% Difference between original and DE-watermarked signal
deDiff = signalDe(:,1:2) - signal(:,1:2);
deDist = sqrt(sum(deDiff.^2, 2));

fprintf('Input file: %s\n', inputFile);
fprintf('DE watermark exact extraction: %d\n', deWatermarkOk);
fprintf('DE max absolute recovery error: %g\n', deRecoveryError);
fprintf('DE mean abs. difference in X: %g\n', mean(abs(deDiff(:,1))));
fprintf('DE mean abs. difference in Y: %g\n', mean(abs(deDiff(:,2))));
fprintf('DE max abs. difference in X: %g\n', max(abs(deDiff(:,1))));
fprintf('DE max abs. difference in Y: %g\n', max(abs(deDiff(:,2))));
fprintf('DE mean Euclidean difference: %g\n', mean(deDist));
fprintf('DE max Euclidean difference: %g\n', max(deDist));

figure('Name', 'DE watermarking');

subplot(4,1,1);
plot(signal(:,1), signal(:,2), 'k', 'LineWidth', 1.2);
grid on; axis equal;
title('Original');
xlabel('X'); ylabel('Y');

subplot(4,1,2);
plot(signalDe(:,1), signalDe(:,2), 'b', 'LineWidth', 1.2);
grid on; axis equal;
title('DE watermarked');
xlabel('X'); ylabel('Y');

subplot(4,1,3);
plot(signalRecoveredDe(:,1), signalRecoveredDe(:,2), 'r', 'LineWidth', 1.2);
grid on; axis equal;
title('DE recovered');
xlabel('X'); ylabel('Y');

subplot(4,1,4);
plot(deDiff(:,1), 'b', 'LineWidth', 1.0); hold on;
plot(deDiff(:,2), 'r', 'LineWidth', 1.0);
plot(deDist, 'k', 'LineWidth', 1.0);
grid on;
title('Difference between original and DE-watermarked signal');
xlabel('Sample index');
ylabel('Difference');
legend('\DeltaX', '\DeltaY', 'Euclidean distance');

% ---------------- LSB watermarking ----------------
maxLsbBits = 5;

for numLsbBits = 1:maxLsbBits
    lsbWatermarkX = randi([0, 2^numLsbBits - 1], numRows, 1);
    lsbWatermarkY = randi([0, 2^numLsbBits - 1], numRows, 1);

    signalLsb = embed_lsb_watermark(signal, numLsbBits, lsbWatermarkX, lsbWatermarkY);
    lsbWatermarkExtracted = extract_lsb_watermark(signalLsb, numLsbBits);

    lsbWatermarkOriginal = [lsbWatermarkX, lsbWatermarkY];
    lsbWatermarkOk = isequal(lsbWatermarkOriginal, lsbWatermarkExtracted);

    % Difference between original and LSB-watermarked signal
    lsbDiff = signalLsb(:,1:2) - signal(:,1:2);
    lsbDist = sqrt(sum(lsbDiff.^2, 2));

    fprintf('\nLSB (%d bits) exact extraction: %d\n', numLsbBits, lsbWatermarkOk);
    fprintf('LSB (%d bits) mean abs. difference in X: %g\n', numLsbBits, mean(abs(lsbDiff(:,1))));
    fprintf('LSB (%d bits) mean abs. difference in Y: %g\n', numLsbBits, mean(abs(lsbDiff(:,2))));
    fprintf('LSB (%d bits) max abs. difference in X: %g\n', numLsbBits, max(abs(lsbDiff(:,1))));
    fprintf('LSB (%d bits) max abs. difference in Y: %g\n', numLsbBits, max(abs(lsbDiff(:,2))));
    fprintf('LSB (%d bits) mean Euclidean difference: %g\n', numLsbBits, mean(lsbDist));
    fprintf('LSB (%d bits) max Euclidean difference: %g\n', numLsbBits, max(lsbDist));

    figure('Name', sprintf('LSB watermarking - %d bits', numLsbBits));

    subplot(3,1,1);
    plot(signal(:,1), signal(:,2), 'k', 'LineWidth', 1.2);
    grid on; axis equal;
    title('Original');
    xlabel('X'); ylabel('Y');

    subplot(3,1,2);
    plot(signalLsb(:,1), signalLsb(:,2), 'b', 'LineWidth', 1.2);
    grid on; axis equal;
    title(sprintf('LSB watermarked (%d bits)', numLsbBits));
    xlabel('X'); ylabel('Y');

    subplot(3,1,3);
    plot(lsbDiff(:,1), 'b', 'LineWidth', 1.0); hold on;
    plot(lsbDiff(:,2), 'r', 'LineWidth', 1.0);
    plot(lsbDist, 'k', 'LineWidth', 1.0);
    grid on;
    title(sprintf('Difference between original and LSB watermarked (%d bits)', numLsbBits));
    xlabel('Sample index');
    ylabel('Difference');
    legend('\DeltaX', '\DeltaY', 'Euclidean distance');
end