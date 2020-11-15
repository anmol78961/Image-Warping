# Image-Warping-Lab

## Backward Mapping
Run the program “BackwardMap.m”. The code will warp a 2D image of Mona Lisa via a rotation about a point. The image used is "Mona.jpg".

## Linear Interpolation
Run the Code "BilinearInterpolation.m". The code extends the backward-warping program to sample pixel colours from the source image using bilinear interpolation.

## Lens Undistortion
Run the code "LensUndistortion.m". This code applies a different warping function that is commonly used for removing lens distortion from images, i.e. to make straight lines straight again. The image used is "window.jpg".

## Homographies
- Run the code "Homographies.m". 
- This code loads the Images you want to use Homography on, using imread, and stores them. Running the given code asks to plot 4 points each on the left and the right images, respectively. Then we use the "calchomography" function to calculate the Homography. After the homography has been estimated, the user is prompted to click on points on the left image. These points are then converted to a 3x4 matrix and then are multiplied to the homographic matrix to get the right points to be plotted on the right image. the points obtained are plotted on the right image at the same point as in the left image.


## Image Alignment
Run the code "ImageAlignment.m". Load the Images you want to use Image Alignment on, using imread, and store them.
Using the code from the previous task to again estimate the homography matrix ‘M’ mapping
points from the left-hand image of the parade to the right-hand image of the parade. Using the
MATLAB command “save mymatrix M” to save this matrix to the file “mymatrix.mat”, which is 
plugged to the estimated homography ‘M’ into the backward warping code used for Task 1, and then warpping the
left-hand image. Using imfuse, fuses the final left image after wrapping and the right image which gives a panaromic image.
