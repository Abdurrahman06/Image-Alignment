clear all; close all; clc;
%%
startingFolder = 'C:\Users\TSPC\Documents\MATLAB\ComputerVision\MyImageAlignmentProject\framework';
if ~exist(startingFolder, 'dir')
  % If that folder doesn't exist, just start in the current folder.
  startingFolder = pwd;
end
% Get the name of the file that the user wants to use.
defaultFileName = fullfile(startingFolder, '*.*');
[baseFileName, folder] = uigetfile(defaultFileName, 'Select a file');
if baseFileName == 0
  % User clicked the Cancel button.
  return;
end
fullFileName = fullfile(folder, baseFileName);
img1 = imread(fullFileName);
%%
startingFolder = 'C:\Users\TSPC\Documents\MATLAB\ComputerVision\MyImageAlignmentProject\framework';
if ~exist(startingFolder, 'dir')
  % If that folder doesn't exist, just start in the current folder.
  startingFolder = pwd;
end
% Get the name of the file that the user wants to use.
defaultFileName = fullfile(startingFolder, '*.*');
[baseFileName, folder] = uigetfile(defaultFileName, 'Select a file');
if baseFileName == 0
  % User clicked the Cancel button.
  return;
end
fullFileName = fullfile(folder, baseFileName);
img2 = imread(fullFileName);
%% Select 4 Points For Each Image
   figure,imshow(img1),[x0,y0] = getpts;
   x1(1,:)=transpose(round(x0));
   x1(2,:)=transpose(round(y0));
%    x1(3,:)=1;
   figure,imshow(img2),[x,y] = getpts;
   x2(1,:)=transpose(round(x));
   x2(2,:)=transpose(round(y));
%    x2(3,:)=1;
%% Compute H matrix by using DLT
[H, A] = dlt_homography(x2, x1);
H_inv = inv(H);
%%
maxL = max(x1(1,:));
minL = min(x1(1,:));
maxH = max(x1(2,:));
minH = min(x1(2,:));
mframe_L = max(x2(1,:));
mframe_H = max(x2(2,:));
miframe_L = min(x2(1,:));
miframe_H = min(x2(2,:));
for i=minL:maxL
    for j=minH:maxH
        coords = H_inv*[i,j,1]';
        coords = [coords(1)/coords(3); coords(2)/coords(3)];
        if (((coords(1) < mframe_L) && (coords(1) > miframe_L)) ...
                && ((coords(2) < mframe_H) && (coords(2) > miframe_H)))
            % Repeat bilinear interpolation 3 times for RGB pixels
            img1(j,i,1) = bilinear_interp(img2(:,:,1), [coords(1), coords(2)]);
            img1(j,i,2) = bilinear_interp(img2(:,:,2), [coords(1), coords(2)]);
            img1(j,i,3) = bilinear_interp(img2(:,:,3), [coords(1), coords(2)]);
        end
    end
end

% Save the image to a file, display it
hacked_image = 'ImageP.png';
imwrite(img1, hacked_image);
imshow(img1);
%------------------
   