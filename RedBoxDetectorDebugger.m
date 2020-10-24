clear;
imAdd = 'snap8.jpg';
im1 = imread(imAdd);
im1 = imresize(im1, 0.25);
[h, v, l] = size(im1);

redmask = im1(:,:,1);
greyscale = rgb2gray(im1);
finalim = imsubtract(redmask, greyscale);
finalim = im2bw(finalim, 0.1);
imGA = finalim;
imGA = bwareaopen(imGA,100);
imGA = imfill(imGA, 'holes');
figure;
imshow(imGA);
redbox = regionprops(imGA, 'BoundingBox');
noBB = length(redbox);
noBB = int16(noBB);

for k = 1:noBB
    rectangle('Position', redbox(k).BoundingBox,'EdgeColor','b');
end

% imtool(im1);  
% red = [255 0 0];
% angleThreshold = 50;
% im1 = double(im1);
% % % % Red
% imG = im1;
% for k=1:h
%     for j=1:v
%         pixel = [im1(k,j,1) im1(k,j,2) im1(k,j,3)];
%         angle = acosd(dot(red/norm(red), pixel/norm(pixel)));
%         isred = angle<=angleThreshold;
%         if isred == true
%             imG(k,j,:) = 255;
%         else
%             imG(k,j,:)=0;
%         if (imG(k,j,1)>120 && imG(k,j,1)<220 && imG(k,j,2)>20 && imG(k,j,3)>20 && imG(k,j,2)<95 && imG(k,j,3)<95)
%             imG(k,j,:) = 255;
%         else
%             imG(k,j,:)=0;
%         end
%     
%         end
%     end
% end
% imshow(im1);    

% imGBW = im2bw(imG);
% % figure;
% % imshow(imGBW);

% imGA = imfill(imGA, 'holes');
% % figure;
% imshow(imGA);
% redbox = regionprops(imGA, 'BoundingBox')
% noBB = length(redbox);
% noBB = int16(noBB);
% 
% for k = 1:noBB
%     rectangle('Position', redbox(k).BoundingBox,'EdgeColor','b');
% end