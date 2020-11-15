%% Lens Undistortion

source = im2double(imread('window.jpg'));
target = zeros(size(source));

fx = 474.53;
px = 405.96;
fy = 474.53;
py = 217.81;

k1 = -0.27194;
k2 = 0.11517;
k3 = -0.029859;

for v = 1:size(source, 1)
    for u = 1:size(source, 2)
        x = (u - px)/fx;
        y = (v - py)/fy;
        
        r = sqrt(x^2 + y^2);
        xprime = x * (1 + (k1 * (r^2)) + (k2 * (r^4)) + (k3 * (r^6)));
        yprime = y * (1 + (k1 * (r^2)) + (k2 * (r^4)) + (k3 * (r^6)));
        
        uprime = round((xprime * fx) + px);
        vprime = round((yprime * fy) + py);
        
        target(v, u, :) = source(vprime, uprime, :);
    end
end

imshow([source target])