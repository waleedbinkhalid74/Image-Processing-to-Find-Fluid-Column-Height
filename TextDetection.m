function letter = TextDetection(image)
%% Automatically Detect and Recognize Text in Natural Images
% This example shows how to detect regions containing text in an
% image. It is a common task performed on unstructured scenes, for
% example when capturing video from a moving vehicle for the purpose
% of alerting a driver about a road sign. Segmenting out the text 
% from a cluttered scene greatly helps with additional tasks 
% such as optical character recognition (OCR). 
%
% The automated text detection algorithm in this example starts with
% a large number of text region candidates and progressively removes those 
% less likely to contain text. To highlight this algorithm's flexibility,
% it is applied to images containing a road sign, a poster and a set 
% of license plates.
%
%   Copyright 2014 The MathWorks, Inc.

%% Step 1: Load image
% Load the image. The text can be rotated in plane, but significant out of
% plane rotations may require additional pre-processing.
colorImage = image;

% % figure; imshow(colorImage); title('Original image')
% 
% %% Step 2: Detect MSER Regions
% % Since text characters usually have consistent color, we begin
% % by finding regions of similar intensities in the image using the MSER
% % region detector [1].
% 
% % Detect and extract regions
% grayImage = rgb2gray(colorImage);
% % imshow(grayImage);
% mserRegions = detectMSERFeatures(grayImage,'RegionAreaRange',[200, 600]);
% mserRegionsPixels = vertcat(cell2mat(mserRegions.PixelList));  % extract regions
% 
% % Visualize the MSER regions overlaid on the original image
% % figure; imshow(colorImage); hold on;
% % plot(mserRegions, 'showPixelList', true,'showEllipses',false);
% % title('MSER regions');
% %%
% Some of these regions include extra background pixels. At this stage, the
% letter E and D in "TOWED" combine into one region. Also notice that the
% space between bricks is included.

%% Step 3: Use Canny Edge Detector to Further Segment the Text
% Since written text is typically placed on clear background, it tends
% to produce high response to edge detection. Furthermore, an intersection
% of MSER regions with the edges is going to produce regions that are
% % even more likely to belong to text.
% 
% % Convert MSER pixel lists to a binary mask
% mserMask = false(size(grayImage));
% ind = sub2ind(size(mserMask), mserRegionsPixels(:,2), mserRegionsPixels(:,1));
% mserMask(ind) = true;
% 
% % Run the edge detector
% edgeMask = edge(grayImage, 'Canny');
% 
% % Find intersection between edges and MSER regions
% edgeAndMSERIntersection = edgeMask & mserMask; 
% figure; imshowpair(edgeMask, edgeAndMSERIntersection, 'montage'); 
% title('Canny edges and intersection of canny edges with MSER regions')

% %%
% % Note that the original MSER regions in |mserMask| still contain 
% % pixels that are not part of the text. We can use the edge mask
% % together with edge gradients to eliminate those regions.
% %
% % Grow the edges outward by using image gradients around edge locations. 
% % <matlab:edit(fullfile(matlabroot,'toolbox','vision','visiondemos','helperGrowEdges.m')) |helperGrowEdges|>
% % helper function.
% 
% [~, gDir] = imgradient(grayImage);
% % You must specify if the text is light on dark background or vice versa
% gradientGrownEdgesMask = helperGrowEdges(edgeAndMSERIntersection, gDir, 'LightTextOnDark');
% % figure; imshow(gradientGrownEdgesMask); title('Edges grown along gradient direction')
% 
% %%
% % This mask can now be used to remove pixels that are within the MSER
% % regions but are likely not part of text.
% 
% % Remove gradient grown edge pixels
% edgeEnhancedMSERMask = ~gradientGrownEdgesMask & mserMask; 
% 
% % Visualize the effect of segmentation
% % figure; imshowpair(mserMask, edgeEnhancedMSERMask, 'montage'); 
% % title('Original MSER regions and segmented MSER regions')
% 
% %%
% % In this image, letters have been further separated from the background and
% % many of the non-text regions have been separated from text.
% 
% %% Step 4: Filter Character Candidates Using Connected Component Analysis
% % Some of the remaining connected components can now be removed by using
% % their region properties. The thresholds used below may vary for 
% % different fonts, image sizes, or languages.
% 
% connComp = bwconncomp(edgeEnhancedMSERMask); % Find connected components
% stats = regionprops(connComp,'Area','Eccentricity','Solidity');
% 
% % Eliminate regions that do not follow common text measurements
% regionFilteredTextMask = edgeEnhancedMSERMask;
% 
% regionFilteredTextMask(vertcat(connComp.PixelIdxList{[stats.Eccentricity] > .995})) = 0;
% regionFilteredTextMask(vertcat(connComp.PixelIdxList{[stats.Area] < 200 | [stats.Area] > 600})) = 0;
% regionFilteredTextMask(vertcat(connComp.PixelIdxList{[stats.Solidity] < .4})) = 0;
% 
% % Visualize results of filtering
% % figure; imshowpair(edgeEnhancedMSERMask, regionFilteredTextMask, 'montage'); 
% % title('Text candidates before and after region filtering')
% 
% %% Step 5: Filter Character Candidates Using the Stroke Width Image
% % Another useful discriminator for text in images is the variation in 
% % stroke width within each text candidate. Characters in most languages 
% % have a similar stroke width or thickness throughout. It is therefore
% % useful to remove regions where the stroke width exhibits too much 
% % variation [1]. The stroke width image below is computed using the
% % <matlab:edit(fullfile(matlabroot,'toolbox','vision','visiondemos','helperStrokeWidth.m')) |helperStrokeWidth|>
% % helper function.
% 
% distanceImage    = bwdist(~regionFilteredTextMask);  % Compute distance transform
% strokeWidthImage = helperStrokeWidth(distanceImage); % Compute stroke width image
% 
% % Show stroke width image
% % figure; imshow(strokeWidthImage); 
% % caxis([0 max(max(strokeWidthImage))]); axis image, colormap('jet'), colorbar;
% % title('Visualization of text candidates stroke width')
% %%
% % Note that most non-text regions show a large variation in stroke width.
% % These can now be filtered using the coefficient of stroke width variation.
% 
% % Find remaining connected components
% connComp = bwconncomp(regionFilteredTextMask);
% afterStrokeWidthTextMask = regionFilteredTextMask;
% for i = 1:connComp.NumObjects
%     strokewidths = strokeWidthImage(connComp.PixelIdxList{i});
%     % Compute normalized stroke width variation and compare to common value
%     if std(strokewidths)/mean(strokewidths) > 0.35
%         afterStrokeWidthTextMask(connComp.PixelIdxList{i}) = 0; % Remove from text candidates
%     end
% end
% 
% % Visualize the effect of stroke width filtering
% % figure; imshowpair(regionFilteredTextMask, afterStrokeWidthTextMask,'montage'); 
% title('Text candidates before and after stroke width filtering')

%% Step 6: Determine Bounding Boxes Enclosing Text Regions
% To compute a bounding box of the text region, we will first merge the
% individual characters into a single connected component. This can be
% accomplished using morphological closing followed by opening
% to clean up any outliers.
% se1=strel('disk',25);
% se2=strel('disk',7);

% afterMorphologyMask = imclose(afterStrokeWidthTextMask,se1);
% afterMorphologyMask = imopen(afterMorphologyMask,se2);

% Display image region corresponding to afterMorphologyMask 
% displayImage = colorImage; 
% displayImage(~repmat(afterMorphologyMask,1,1,3)) = 0;
% figure; imshow(displayImage); title('Image region under mask created by joining individual characters')
%%
% Find bounding boxes of large regions.
% areaThreshold = 6000; % threshold in pixels
% connComp = bwconncomp(afterMorphologyMask);
% stats = regionprops(connComp,'BoundingBox','Area');
% boxes = round(vertcat(stats(vertcat(stats.Area) > areaThreshold).BoundingBox));
% areaThreshold = 300; % threshold in pixels
% connComp = bwconncomp(afterMorphologyMask);
% stats = regionprops(connComp,'BoundingBox','Area');
% boxes = round(vertcat(stats(vertcat(stats.Area) > areaThreshold).BoundingBox));
% boxes(:,1:2) = boxes(:,1:2)-5;
% boxes(:,3:4) = boxes(:,3:4)+10;

boxes = RedBoxDetector(image);
boxes = boxes.BoundingBox;
boxes(:,1:2) = boxes(:,1:2)+3;
boxes(:,3:4) = boxes(:,3:4)-6;

% cropped = imcrop(colorImage, boxes);

%% Step 7: Perform Optical Character Recognition on Text Region
% The segmentation of text from a cluttered scene can greatly improve OCR results.
% Since our algorithm already produced a well segmented text region, we can use 
% the binary text mask to improve the accuracy of the recognition results.

% inversed = imcomplement(cropped);
% filledIm = imfill(afterStrokeWidthTextMask, 'holes');

% afterStrokeWidthTextMask = imfill(afterStrokeWidthTextMask, 'holes');
% afterStrokeWidthTextMask = bwmorph(afterStrokeWidthTextMask, 'thicken');
% afterStrokeWidthTextMask = bwmorph(afterStrokeWidthTextMask, 'majority');
% afterStrokeWidthTextMask = bwmorph(afterStrokeWidthTextMask, 'bridge');

% imshow(afterStrokeWidthTextMask);

% fillholes
% filled = imfill(afterStrokeWidthTextMask, 'holes');
% holes = filled & ~afterStrokeWidthTextMask;
% bigholes = bwareaopen(holes, 50);
% smallholes = holes & ~bigholes;
% new = afterStrokeWidthTextMask | smallholes;

% figure;
% imshow(new);
% new = afterStrokeWidthTextMask;

bwimage= im2bw(colorImage, 0.6);
% imshow(bwimage);
ocrtxt = ocr(bwimage, boxes,'CharacterSet','ABCDEFGHIJKLMNOP','TextLayout','Block'); % use the binary image instead of the color image
letter = [ocrtxt.Text];
% figure;
% disp('the letter is: ')
% disp(letter)
% imshow(cropped);
% title(letter);