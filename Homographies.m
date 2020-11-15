%% Homographies

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



%% TODO: compute the homography between the left and right points.
homography = calchomography(leftpts, rightpts);

%% TODO: have user click on left image, and plot their click. Then estimate
% point in right image using the homography and draw that point.

% Draw the left image2.
figure(3);
image(left);
axis equal;
axis off;
title('Left image');
hold on;
% Get 4 points on the left image2.
figure(3);
[x, y] = ginput(4);
leftpts2 = [x'; y'];
leftpts2(3,:) = 1;
% Plot left points on the left image2.
figure(3)
plot(leftpts2(1,:), leftpts2(2,:), 'rx');

rightpts2 = homography * leftpts2;
rightpts2(3, :) = 1;

% Draw the right image2.
figure(4);
image(right);
axis equal;
axis off;
title('Right image');
hold on;

figure(4)
plot(rightpts2(1,:),rightpts2(2, :), 'gx');

%% 
% 
%% Calchomography

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