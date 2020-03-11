close all ;
clc;
global EDGEIM;
global ROWS;
global COLS;
global JUNCT;

originalimage = imread('C:\Users\oggyu\Pictures\Camera Roll\1.jpg');
% [image,myRoi] = imcrop(originalimage);
[bw,x,y] = roipoly(originalimage);
% image = rgb2gray(image);

L = superpixels(originalimage,200);
% mroi = images.roi.Rectangle(gca,'Position',myRoi);
% h1 = drawpolygon(gca,'Position',myRoi);
% roiPoints = h1.Position;
roi = poly2mask(x,y,size(L,1),size(L,2));

% roi = images.roi.Rectangle(gca,'Position',myRoi);

BW= grabcut(originalimage,L,roi);
maskedImage = originalimage;
maskedImage(repmat(~BW,[1 1 3])) = 0 ;
figure;
imshow(maskedImage);

[image,myRoi] = imcrop(maskedImage);
image = rgb2gray(image);

canyImg = edge(image,'Canny');
canyImg2 = canyImg;
grayImg = image;
[gx,gy] = imgradientxy(grayImg);
[Gmag,Gdir] = imgradient(gx,gy);


gthresh = 2 / sind(22.5);
status = ones(size(image));               

% 0 is no need to check 
% 1 is need to check 

%status matrix made 
for cols=1:size(image,2)
   for rows=1:size(image,1)
   if(Gmag < gthresh)
        status(rows,cols) = 0;           
   end
   end    
end
levelLineAngle = atand(gx./(-gy));


[maxValRows,maxIndexRows] = max(Gmag);
[maxVal,maxIndexCols] = max(maxValRows);
% seed point is maxindexRows(maxindexCols),maxindexCols
seedPT = [maxIndexRows(maxIndexCols) maxIndexCols];
%now region grow according to levelLineAngle 

[rj, cj, re, ce] = findendsjunctions(canyImg);

[edgelist,edgeim,etype] = edgelink(canyImg);
maxDeviation = 10;
segList = lineseg(edgelist,maxDeviation);
figure(3);
imshow(canyImg);
for i = 1:size(edgelist,2)
    if(size(edgelist{i},1) > 30)
        hold on;
        plot(edgelist{i}(:,2),edgelist{i}(:,1),'Color',[rand rand rand],'LineWidth',2);
    end        
end

figure(4)
imshow(canyImg2);
for i = 1:size(segList,2)
    hold on;
    plot(segList{i}(:,2),segList{i}(:,1),'Color',[rand rand rand],'LineWidth',2);
    
end


count = 0; 

%quiver(gx,gy);