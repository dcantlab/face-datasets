clear;

datasetDir = 'imgs-dataset';
maskedImgs = dir(fullfile(datasetDir, '*-masked.png'));

%%
%  This step generates a thumbnail image and is not required for dataset generation. 
%  The script is designed specifically for 5 pairs of clean and masked face images.
%
imgmats = {};
for i = 1:length(maskedImgs)
	maskedImg = maskedImgs(i).name;
	cleanImg  = strrep(maskedImg, '-masked.png', '-clean.png');

	imgmats{1, i} = imread(fullfile(datasetDir, cleanImg));  %#ok<SAGROW>
	imgmats{2, i} = imread(fullfile(datasetDir, maskedImg)); %#ok<SAGROW>
end



%%
%  Generate tumbnails image
%
imHs = cellfun(@(i) size(i, 1), imgmats(:, 1));
imWs = cellfun(@(i) size(i, 2), imgmats(1, :));

timg = uint8(zeros([sum(imHs), sum(imWs), 3]));
for r = 1:length(imHs)
	baseH = sum(imHs(1:(r - 1)));
	for c = 1:length(imWs)
		baseW = sum(imWs(1:(c - 1)));
		timg(baseH + (1:imHs(r)), baseW + (1:imWs(c)), :) = imgmats{r, c};
	end
end

timg = imresize(timg, 0.5);
imwrite(timg, 'thumbnails.jpg', 'Quality', 90);
