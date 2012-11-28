function sess = copy_files_to_relative_directory(filenames, targetDir)

if ~exist(targetDir, 'dir');
    mkdir(targetDir);
end

if ~iscell(filenames{1})
    filenames = {filenames};
end

sess = cell(length(filenames), 1);
for nrSess = 1: length(filenames)
    filesOneSess = filenames{nrSess};
    for nrFile = 1: length(filesOneSess)
        nrKomma = find(filesOneSess{nrFile} == ',');
        if ~isempty(nrKomma)
            filesOneSess{nrFile} = filesOneSess{nrFile}(1:(nrKomma-1));
        end
    end
    exampleFile = [filesOneSess{1} filesep];
    fileSepsFrom = find(exampleFile == filesep);
    fileSepsTo = [find(targetDir == filesep) length(targetDir)+1];
    for nrFileSep = 2: min([length(fileSepsFrom) length(fileSepsTo)])
        fromString = exampleFile((fileSepsFrom(nrFileSep-1)+1) : (fileSepsFrom(nrFileSep)-1));
        toString = targetDir((fileSepsTo(nrFileSep-1)+1) : (fileSepsTo(nrFileSep)-1));

        if ~strcmp(targetDir(1:(fileSepsTo(nrFileSep)-1)),exampleFile(1:(fileSepsFrom(nrFileSep))-1))
            break
        end
    end
    fromFiles = filesOneSess;
    toFiles = cellfun(@strrep, filesOneSess, repmat({fromString}, size(filesOneSess)), repmat({toString}, size(filesOneSess)), 'UniformOutput', false);

    for nrFile = 1: length(fromFiles)
        specificTargetDir = fileparts(toFiles{nrFile});
        if ~exist(specificTargetDir, 'dir')
            mkdir(specificTargetDir);
        end
        if strcmp(fromFiles{nrFile}, toFiles{nrFile}) == 0
            movefile(fromFiles{nrFile}, toFiles{nrFile});
        end
    end

    sess{nrSess} = toFiles;
end