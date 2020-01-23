datadir = fullfile(toolboxdir('vision'),'visiondata');
ttgTruth(1:4,:)
ttgTruth.imageFilename = fullfile(datadir,ttgTruth.imageFilename);
summary(ttgTruth)
allboxes = vertcat(ttgTruth.Stapler{:});
aspectRatio = allboxes(:,3) ./ allboxes(:,4);
area = prod(allboxes(:,3:4),2);
figure; scatter(area,aspectRatio); xlabel("Box Area"); ylabel("Aspect Ratio (width/height)");
title("Box area vs. Aspect ratio");
%% To determine the bounding boxes
numAnchors = 4;
[clusterAssignments,anchorBoxes,sumd] = kmedoids(allboxes(:,3:4),numAnchors,'Distance',@iouDistanceMetric);
function dist = iouDistanceMetric(boxWidthHeight,allBoxWidthHeight)
% Return the IoU distance metric. The bboxOverlapRatio function
% is used to produce the IoU scores. The output distance is equal
% to 1 - IoU.

% Add x and y coordinates to box widths and heights so that
% bboxOverlapRatio can be used to compute IoU.
boxWidthHeight = prefixXYCoordinates(boxWidthHeight);
allBoxWidthHeight = prefixXYCoordinates(allBoxWidthHeight);

% Compute IoU distance metric.
dist = 1 - bboxOverlapRatio(allBoxWidthHeight, boxWidthHeight);
end

function boxWidthHeight = prefixXYCoordinates(boxWidthHeight)
% Add x and y coordinates to boxes.
n = size(boxWidthHeight,1);
boxWidthHeight = [ones(n,2) boxWidthHeight];
end

%%
 
