clear;
addpath(fullfile('..', '..', 'functions'));

lmInfoFile = 'landmarks.mat';
lmInfoVars = {'srcImgDir', 'grayImgDir', 'lmImgDir', 'imgFiles', 'lmInfo'};
lmInfo = struct([]);

srcImgDir  = 'imgs-source';
grayImgDir = 'imgs-grayscale';
lmImgDir   = 'imgs-landmarks';

imgFiles = dir(fullfile(srcImgDir, '*.jpg'));

%%
%  Initialize MatConvNet and OpenFace
%
initMatConvNet();
[~, modelArgs] = initOpenFace();



%%
%  Detect facial landmarks
%
if ~exist(lmImgDir, 'dir')
	mkdir(lmImgDir);
end

fprintf('detecting landmarks from %d images ', length(imgFiles));
for i = 1:length(imgFiles)
	imgFile  = fullfile(srcImgDir,  imgFiles(i).name);

	lm = detectLandmarks(imread(imgFile), modelArgs);
	lm.imgId = regexprep(imgFiles(i).name, '\.(jpe?g|png|tiff?|bmp)$', '');
	lm.file  = fullfile(grayImgDir, strcat(lm.imgId, '.png'));
	if isempty(lm.pnts)
		fprintf('!');
	else
		fprintf('.');
		imwrite(renderLandmarks(lm), fullfile(lmImgDir, strcat(lm.imgId, '.png')));	
	end

	lmInfo = cat(1, lmInfo, lm);
	save(lmInfoFile, lmInfoVars{:});
end
fprintf(' done.\n');



%%
%  Wrapping up
%
fprintf('all set, please proceed to Step3_BuildDataset\n\n');
