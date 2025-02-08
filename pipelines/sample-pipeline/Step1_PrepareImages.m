clear;

srcImgDir  = 'imgs-source';
grayImgDir = 'imgs-grayscale';

imgFiles = dir(fullfile(srcImgDir, '*.jpg'));

%%
%  Generate grayscale images
%
fprintf('generating grayscale images under %s%s ...', grayImgDir, filesep);
if ~exist(grayImgDir, 'dir')
	mkdir(grayImgDir);
end

for i = 1:length(imgFiles)
	img = imread(fullfile(srcImgDir, imgFiles(i).name));
	grayImg = rgb2gray(im2double(img));
	dstFile = regexprep(imgFiles(i).name, '\.(jpe?g|png|tiff?|bmp)$', '.png');
	imwrite(grayImg, fullfile(grayImgDir, dstFile));
end
fprintf(' done.\n');



%%
%  Wrapping up
%
fprintf('all set, please proceed to Step2_DetectLandmarks\n\n');
