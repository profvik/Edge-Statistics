%% network creator
tic;
clear;
clc;
n_it = 100;
bin = 0:10:1000;
for i = 1:n_it
    disp(i);
imsize = 2048;
fill_frac = 0.20;
width = 1;
res = zeros(imsize,imsize);
tempres = res;
chk = 0;
while chk <= fill_frac
    pos = randi([1 imsize],2,1);
    slope = rand * pi - pi/2;
    m = tan(slope);
    c = pos(2,1) - m*pos(1,1);
    for x = 1:imsize
        y = uint16(m*x+c);
        if y+width <= imsize && y+width > 0 && y-width <= imsize && y-width > 0 && x+width <= imsize && x+width > 0 && x-width <= imsize && x-width > 0
            res(y-width:y+width,x-width:x+width) = 1;
        end
    end
    chk = sum(sum(res))/imsize^2;
end
%figure;
%imshow(res);

%% network tracker
res = im2bw(res);
%D = bwdist(~res);
H = fspecial('gaussian',1);
D = imfilter(res,H);
%figure;
%imshow(D);
D = -D;
D(~res) = -Inf;
L = watershed(D,8);
rgb = label2rgb(L,'jet',[0.5 0.5 0.5]);
%figure;
%imshow(rgb);
loc = find(L == 0);
tempres(loc) = 1;
bwtemp = im2bw(tempres);
s = bwmorph(bwtemp,'skel',Inf);
%imagesc(s);
br = bwmorph(s,'branchpoints');
[y x] = find(br == 1);
%imagesc(finim)
len = size(x);
for ctr = 1:len(1)
    if x(ctr) > 2 && x(ctr) < 510 && y(ctr) > 2 && y(ctr) < 510
    s(y(ctr)-2:y(ctr)+2,x(ctr)-2:x(ctr)+2) = 0;
    end
end
%figure;
[finy finx] = find(s == 1);
%imagesc(res)
%hold;
%scatter(finx,finy,'.');
%colormap cool;

%% statistics
CC = bwconncomp(s);
numPixels = cellfun(@numel,CC.PixelIdxList);
[y x] = hist(numPixels,bin);
y = y/sum(y);
if i == 1
    finres(:,1) = x;
    finres(:,2) = y;
elseif i > 1
    finres(:,i+1) = y;
end
end
%figure;
%hist(numPixels);

toc;