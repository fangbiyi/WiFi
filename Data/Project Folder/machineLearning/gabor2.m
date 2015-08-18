function [gabor_im] = gabor2(im, orientation, scale, mask)

[h, w ,dim] = size(im);
if(dim>2)
    im = rgb2gray(im);
end
%% Determine if the input image is class of 'double'.
if (~isa(im, 'double'))
    im = double(im); 
end

GaborFilter = gabor_filter(orientation, scale, mask);

orientation = double(orientation);
scale = double(scale);

%%temp_real = cell(orientation,scale);
%%temp_imag = cell(orientation,scale);

for u = 1:orientation
    for v = 1:scale
       gabor_im{u,v} = imfilter(im,GaborFilter{u,v});
       %%temp_real{u,v} = real(gabor_im{u,v}).*real(gabor_im{u,v});
       %%temp_imag{u,v} = imag(gabor_im{u,v}).*imag(gabor_im{u,v});
       %%gabor_im{u,v} =  sqrt(temp_real{u,v} + temp_imag{u,v});
       gabor_im{u,v} = sqrt(real(gabor_im{u,v}).*real(gabor_im{u,v})...
                      + imag(gabor_im{u,v}).*imag(gabor_im{u,v}));
    end
end

%% figure;
%% 	for i = 1:orientation
%% 		for j = 1:scale       
%%                subplot(orientation,scale, (i-1)*scale+j);     
%%                imshow(real(gabor_im{i,j}), []);
%%            end
%%		end
end

