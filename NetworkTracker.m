%% network tracker
clear;
clc;
tic;
data = imread('H:\Ross Lab\RossLab Code\Network\QD_1to10_ch1005_mtslines_binarynetwork.tif');
sd = size(data);
tempres = zeros(sd(1),sd(2));
figure;
imshow(data);
res1 = imcomplement(data);%data;
%res1 = rgb2gray(data);
th = graythresh(res1);
bw = im2bw(res1,th*0.05);
bwa = bwareaopen(bw,100);
se = strel('disk',3);
dilim = imdilate(bwa,se);
%dilim = imerode(dilim,se);
figure;
imshow(dilim);

%% network tracker
res = dilim;
%D = bwdist(~res);
H = fspecial('gaussian',3);
D = imfilter(res,H);
figure;
imshow(D);
D = -D;
D(~res) = -Inf;
L = watershed(D,8);
rgb = label2rgb(L,'jet',[0.5 0.5 0.5]);
figure;
imshow(rgb);
loc = find(L == 0);
tempres(loc) = 1;
bwtemp = im2bw(tempres);
s = bwmorph(bwtemp,'skel',Inf);
imagesc(s);
br = bwmorph(s,'branchpoints');
[y x] = find(br == 1);
%imagesc(finim)
len = size(x);
for ctr = 1:len(1)
    s(y(ctr)-2:y(ctr)+2,x(ctr)-2:x(ctr)+2) = 0;
end
figure;
[finy finx] = find(s == 1);
imagesc(res)
hold;
scatter(finx,finy,'.');
colormap cool;

%% statistics
CC = bwconncomp(s);
numPixels = cellfun(@numel,CC.PixelIdxList);
figure;
bin = 0:20:1000;
[hy hx] = hist(numPixels,bin);
plot(hx,hy);
toc;