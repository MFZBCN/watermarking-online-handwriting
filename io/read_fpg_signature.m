function [samples, numSamples, numComponents, sampleRate] = read_fpg_signature(filePath)
%READ_FPG_SIGNATURE Read an MCYT FPG signature file.
%   samples       : [numSamples x numComponents]
%   numSamples    : number of vectors
%   numComponents : components per vector
%   sampleRate    : sampling rate if available

    samples = zeros(0, 0);
    numSamples = 0;
    numComponents = 0;
    sampleRate = 0;

    fileId = fopen(filePath, 'rb');
    if fileId == -1
        return;
    end

    cleanupObj = onCleanup(@() fclose(fileId)); %#ok<NASGU>

    signatureId = fread(fileId, 4, 'char');
    if numel(signatureId) ~= 4 || ~all(signatureId' == uint8('FPG '))
        samples = zeros(0, 0);
        return;
    end

    headerSize = fread(fileId, 1, 'uint16');
    versionFlag = 1;
    if ismember(headerSize, [48, 60])
        versionFlag = 2;
    end

    fileFormat = fread(fileId, 1, 'uint16');
    if fileFormat ~= 4
        samples = zeros(0, 0);
        return;
    end

    fread(fileId, 1, 'uint16');              % Legacy field, unused here
    fread(fileId, 1, 'uint16');              % Number of channels, unused here
    fread(fileId, 1, 'uint32');              % Sampling period, unused here
    resolutionBits = fread(fileId, 1, 'uint16');
    fseek(fileId, 4, 'cof');                 % Reserved
    fread(fileId, 1, 'uint32');              % Coefficient, unused here
    numComponents = fread(fileId, 1, 'uint32');
    numSamples = fread(fileId, 1, 'uint32');
    fread(fileId, 1, 'uint16');              % Normalization type, unused here

    if versionFlag == 2
        sampleRate = fread(fileId, 1, 'uint32');
        fread(fileId, 1, 'uint32');          % Window size, unused here
        fread(fileId, 1, 'uint32');          % Overlapped samples, unused here
    end

    fseek(fileId, headerSize - 12, 'bof');
    fread(fileId, 1, 'uint32');              % Data chunks, unused here
    fread(fileId, 1, 'uint32');              % Chunk delta, unused here
    fread(fileId, 1, 'uint32');              % Delta change, unused here

    fseek(fileId, headerSize, 'bof');

    switch resolutionBits
        case 8
            dataType = 'uint8';
        case 16
            dataType = 'int16';
        case 32
            dataType = 'float32';
        otherwise
            dataType = 'float64';
    end

    totalValues = double(numSamples) * double(numComponents);
    rawData = fread(fileId, totalValues, dataType);

    if numel(rawData) ~= totalValues
        samples = zeros(0, 0);
        numSamples = 0;
        numComponents = 0;
        sampleRate = 0;
        return;
    end

    samples = reshape(rawData, [numComponents, numSamples])';
end
