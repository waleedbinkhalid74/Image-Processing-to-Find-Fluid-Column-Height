function redbox = RedBoxDetector(image)
% im1 = imread(imAdd);
% image = imresize(image, 0.25);
[h, v, l] = size(image);
% imtool(im1small);
im1=image;
% % Green
% imG = image;
% for k=1:h
%     for j=1:v
%         if (imG(k,j,1)>120 && imG(k,j,1)<220 && imG(k,j,2)>20 && imG(k,j,3)>20 && imG(k,j,2)<95 && imG(k,j,3)<95)
%             imG(k,j,:) = 255;
%         else
%             imG(k,j,:)=0;
%         end
%     end
% end
redmask = im1(:,:,1);
greyscale = rgb2gray(im1);
finalim = imsubtract(redmask, greyscale);
finalim = im2bw(finalim, 0.18);
imGA = finalim;
imGBW = im2bw(imGA);
% figure;
% imshow(imGBW);
imGBW = bwareaopen(imGBW, 50);
imGBW = imfill(imGBW, 'holes');
figure;
imshow(imGA);
redbox = regionprops(imGBW, 'BoundingBox');