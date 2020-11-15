%% Bi-Linear Interpolation

clear all;
close all;

source = im2double(imread('mona.jpg'));
target = zeros(size(source));

T = [1 0 -size(source, 2) / 2; 0 1 -size(source, 1) / 2; 0 0 1];
t = pi / 4;
R = [cos(t) -sin(t) 0; sin(t) cos(t) 0; 0 0 1];
S = [4 0 0; 0 4 0; 0 0 1];

% The warping transformation (rotation + scale about an arbitrary point).
M = inv(T) * R * S * T;

% The forward mapping loop: iterate over every source pixel.
for y = 1:size(target, 1)
    for x = 1:size(target, 2)

        % Transform source pixel location (round to pixel grid).
        q = [x; y; 1];
        p = inv(M) * q;
        u = round(p(1) / p(3));
        v = round(p(2) / p(3));

        % Check if target pixel falls inside the image domain.
        if (u > 0 && v > 0 && u <= size(source, 2) && v <= size(source, 1))
            
            x2 = ceil(v);
            x1 = floor(v);
            y2 = ceil(u);
            y1 = floor(u);
            
            alpha_ = x1;
            beta_ = y1;
            
            f1 = [x1, y2];
            f2 = [x2, y2];
            f3 = [x1, y1];
            f4 = [x2, y1];
            
            f12 = ((1 - alpha_) * f1) + (alpha_ * f2);
            f34 = ((1 - alpha_) * f3) + (alpha_ * f4);
            f1234 = ((1 - beta_) * f12) + (beta_ * f34);
        
            % Sample the target pixel colour from the source pixel.
            target(y, x, :) = source(f1234(1), f1234(2), :);
        end
        
    end
end

imshow([source target]);