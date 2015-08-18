function [ LBPhist,lbp_im ] = LBP2( im, blocksize )
% Local Binary Pattern
%   Usage: LBP2( im, blocksize )
%
%

%% RGB to Gray Scale
[h, w ,dim] = size(im);
if(dim>2)
    im = rgb2gray(im);
end

%% Zero padding
new_im = zeros(h+2 , w+2);
new_im(2:h+1 , 2:w+1) = im;

weight=2.^[0, 1, 2, 3, 4, 5, 6, 7];   

%% Calculate for each pixel's LBP value

 for(m = 1:h)
    for(n = 1:w)
        value = [(new_im(m ,n) - new_im(m+1 ,n+1)) , 
                 (new_im(m ,n+1) - new_im(m+1 ,n+1)) , 
                 (new_im(m ,n+2) - new_im(m+1 ,n+1)) , 
                 (new_im(m+1 ,n) - new_im(m+1 ,n+1)) , 
                 (new_im(m+1 ,n+2) - new_im(m+1 ,n+1)) , 
                 (new_im(m+2 ,n) - new_im(m+1 ,n+1)) , 
                 (new_im(m+2 ,n+1) - new_im(m+1 ,n+1)) , 
                 (new_im(m+2 ,n+2) - new_im(m+1 ,n+1))];
        temp = weight*double(value>0);
        lbp_value(m, n) = sum(temp);
    end
 end

%% Extract n*n size block's histogram
hblock_count = floor(h/blocksize);  %% 排除無法湊齊blocksize的pixel
wblock_count = floor(w/blocksize);  %% 排除無法湊齊blocksize的pixel
lbp_im = lbp_value(1:hblock_count*blocksize, 1:wblock_count*blocksize);

lbpPatch = im2col(lbp_im, [hblock_count, wblock_count], 'distinct');

LBPhist = zeros(256, blocksize*blocksize);   % 0~255 histogram 值
for i = 1:size(lbpPatch,2)
	tmp = histc(lbpPatch(:,i), 0:255);
    MAX = max(tmp);
    LBPhist(:,i) = tmp./MAX;     %% normalization
end
LBPhist = LBPhist(:);


%% Show images
%% subplot(1,2,1);
%% imshow(im);
%% xlabel('Original Image');

%% subplot(1,2,2);
%% imshow(lbp_im,[]);
%% xlabel('LBP Image');

 %% figure;
%% 	for i=1:blocksize
%% 		for j=1:blocksize
%% 			k=(j-1)*blocksize+i;
%% 			subplot(blocksize, blocksize, k);
%% 			hist(lbpPatch(:,k), 0:255);
%% 		end
%%     end

end

