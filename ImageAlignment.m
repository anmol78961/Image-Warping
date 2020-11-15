%% Image Alignment


close all;
clear all;

% Read in two photos of the library.
left  = im2double(imread('parade1.bmp'));
right = im2double(imread('parade2.bmp'));

% Draw the left image.
figure(1);
image(left);
axis equal;
axis off;
title('Left image');
hold on;

% Draw the right image.
figure(2);
image(right);
axis equal;
axis off;
title('Right image');
hold on;

% Get 4 points on the left image.
figure(1);
[x, y] = ginput(4);
leftpts = [x'; y'];
% Plot left points on the left image.
figure(1)
plot(leftpts(1,:), leftpts(2,:), 'rx');

% Get 4 points on the right image.
figure(2);
[x, y] = ginput(4);
rightpts = [x'; y'];
% Plot the right points on the right image
figure(2)
plot(rightpts(1,:), rightpts(2,:), 'gx');

% Make leftpts and rightpts (clicked points) homogeneous.
leftpts(3,:) = 1;
rightpts(3,:) = 1;

homography = calchomography(leftpts,rightpts);

save myMatrix.mat homography;

%% Backwards Mapping

close all;
clear all;

source = im2double(imread('parade1.bmp'));
source2 = im2double(imread('parade2.bmp'));
target = zeros(size(source));

load myMatrix.mat

T = [1 0 -size(source, 2) / 2; 0 1 -size(source, 1) / 2; 0 0 1];
t = pi / 4;
R = [cos(t) -sin(t) 0; sin(t) cos(t) 0; 0 0 1];
S = [4 0 0; 0 4 0; 0 0 1];

% The warping transformation.
M = homography;

% The forward mapping loop: iterate over every target pixel.
for y = 1:size(target, 1)
    for x = 1:size(target, 2)

        % Transform target pixel location.
        q = [x; y; 1];
        p = inv(M) * q;
        u = round(p(1) / p(3));
        v = round(p(2) / p(3));

        % Check if source pixel falls inside the image domain.
        if (u > 0 && v > 0 && u <= size(source, 2) && v <= size(source, 1))
            % Sample the target pixel colour from the source pixel.
            target(y, x, :) = source(v, u, :);
        end

    end
end

imshow([target]);
imshow(imfuse(target, source2));
%% Calchomograohy

    function H = calchomography(points1, points2)

    if size(points1, 2) < 4 || size(points2, 2) < 4
        error('Need at least 4 points for a homography.');
    end

    A = [];

    for point = 1:size(points1, 2)
      x = points1(1, point);
      y = points1(2, point);
      u = points2(1, point);
      v = points2(2, point);

      A = [A; ...
           -x   -y   -1    0    0    0   x * u   y * u   u; ...
            0    0    0   -x   -y   -1   x * v   y * v   v]

    end

    % Solve A * h = 0 for h.
    [U, S, V] = svd(A)
    h = V(:,end)

    % Reshape vectorised result back into matrix shape.
    H = reshape(h, 3, 3)'

    % Homogeneous normalisation.
    H = H ./ H(3,3)
    
end