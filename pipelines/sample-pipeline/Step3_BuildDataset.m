clear;
addpath(fullfile('..', '..', 'functions'));

load('landmarks.mat');

maskPadding = [5, 5];
maskColor = [.75 .75 .75];
maskLineColor = [.60 .60 .60];
maskLineWidth = 1;

datasetDir = 'imgs-dataset';

%%
%  Generate masked face images
%
if ~exist(datasetDir, 'dir')
	mkdir(datasetDir);
end

lmInfo = lmInfo(arrayfun(@(lm) ~isempty(lm.pnts), lmInfo));
fprintf('building dataset with %d images ', length(lmInfo));
for i = 1:length(lmInfo)
	[maskX, maskY] = maskOutline(lmInfo(i), maskPadding);

	hfig = figure('Color', [1 1 1]);
	imshow(imread(lmInfo(i).file), 'Border', 'tight', 'Interpolation', 'bilinear');
	imgClean = getframe(hfig.Children(1)).cdata;
	imwrite(getframe(hfig.Children(1)).cdata, ...
		fullfile(datasetDir, strcat(lmInfo(i).imgId, '-clean.png')));

	patch(maskX, maskY, maskColor, 'LineWidth', maskLineWidth, 'EdgeColor', maskLineColor);
	imwrite(getframe(hfig.Children(1)).cdata, ...
		fullfile(datasetDir, strcat(lmInfo(i).imgId, '-masked.png')));
	close(hfig);
	fprintf('.');
end
fprintf(' done.\n');



%%
%  All done, wrapping up
%
fprintf('all done, please check %s%s\n\n', datasetDir, filesep);
