clear
clc


right = imread('C:\Users\oggyu\Downloads\cones-png-2\cones\im6.png');
left = imread('C:\Users\oggyu\Downloads\cones-png-2\cones\im2.png');
left = rgb2gray(left);
right = rgb2gray(right);
figure(1) 
imshow(left);
figure(2)
imshow(right);
left = im2double(left);
right  = im2double(right);




blockSize = 13 ;
halfBlock = floor(blockSize/2);

rowStart = 1+halfBlock;
colStart = 1+halfBlock; 
rowEnd = size(right,1)-halfBlock;
colEnd = size(right,2)-halfBlock; 

previouse = 0 ; 
disparityMatrix = zeros(size(right));
miniMat = zeros(size(right));

for row = rowStart:rowEnd
    for col1 = colStart:colEnd
        
        checkMin = ones(1,65).*1000000;
        template = right(row-halfBlock:row+halfBlock,col1-halfBlock:col1+halfBlock);
        tail = col1 + 64;
        if((col1+64)>colEnd)
           tail = colEnd;
        end
        for col = col1:tail             
            toCompare = left(row-halfBlock:row+halfBlock,col-halfBlock:col+halfBlock);
            squaredDiff = (toCompare-template).^2;
            magni = sum(sum(squaredDiff));
            checkMin(col-col1+1) = magni;
        end
        [mini,index] = min(checkMin);
%         if(mini>0.1)
%             index = 64;
%         end
        disparityMatrix(row,col1) = index - 1;        
        miniMat(row,col1) = mini; 
    end
end
pos = 81; 

k = disparityMatrix./64;
figure(3)
imshow(k) ; 



