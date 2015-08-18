function [GaborFilter] = gabor_filter(orientation, scale, mask)
%% Gabor Filter

GaborFilter = cell(orientation, scale);
Kmax = 4*pi/5;
f = sqrt(2);
sigma = 3*pi/2;


for u = 1:orientation
    for v = 1:scale
        GaborFilter{u, v} = gabor_value(mask, u-1, v-1, Kmax, f, sigma);
    end
end


end


function Psi = gabor_value(w, u, v, Kmax, f, sigma)

% w : mask
% u : Scale
% v : Orientation

m = w(1);
n = w(2);
K = Kmax/f^u * exp(1i*v*pi/8);
K_real = real(K);
K_imag = imag(K);
norm_k = K_real^2+K_imag^2;
Psi = zeros(m,n);
%% Gabor equation
for x = 1:m
    for y = 1:n
      Z = [x-m/2;y-n/2];
      Psi(x,y) = norm_k*(sigma^(-2))*...
          exp((-.5)*norm_k*(Z(1)^2+Z(2)^2)/(sigma^2))*...
          (exp(1i*[K_real K_imag]*Z)-exp(-(sigma^2)/2));
    end
end

% version : 5.0
% Date : MAY / 18 / 2007
% Author  : Omid Bonakdar Sakhi
end

