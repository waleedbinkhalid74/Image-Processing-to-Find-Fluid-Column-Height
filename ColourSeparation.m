function [factorOfConv, baseTape] = ColourSeparation(image)
redbox = RedBoxDetector(image);
% figure;
% % imshow(image);
% for k = 1:length(redbox)
%     rectangle('Position', redbox(k).BoundingBox,'EdgeColor','b');
% end
hInPixels = redbox(1).BoundingBox(4);
baseTape = redbox(1).BoundingBox(2) + redbox(1).BoundingBox(4);
factorOfConv = 42/hInPixels;
