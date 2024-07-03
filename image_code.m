%% reading image and extracting its 3 components

rgbimg=imread('peppers.png');    
R=rgbimg(:,:,1);
G=rgbimg(:,:,2);
B=rgbimg(:,:,3);

%% plotting the three components

% Z=zeros(size(rgbimg,1),size(rgbimg,2));
% red=cat(3,R,Z,Z);
% green=cat(3,Z,G,Z);
% blue=cat(3,Z,Z,B);
% subplot(1,3,1)
% imshow(red);
% title('Red component');
% subplot(1,3,2)
% imshow(green);
% title('Green component');
% subplot(1,3,3)
% imshow(blue);
% title('Blue component');

%% kernel for edge detection

kernel=[0  0 -1  0  0;
        0  0 -1  0  0;
       -1 -1  8 -1 -1;
        0  0 -1  0  0;
        0  0 -1  0  0];

%% kernel for sharpening

kernel=[0  0 -1  0  0;
        0  0 -1  0  0;
       -1 -1  9 -1 -1;
        0  0 -1  0  0;
        0  0 -1  0  0];

%% kernel for blurring

kernel=1/25*ones(5,5);

%% kernel for horizontal motion blurring

kernel=zeros(5,5);
kernel(3,:)=1/5;

%% convolution with kernel
R1=conv2(im2double(R),kernel);
G1=conv2(im2double(G),kernel);
B1=conv2(im2double(B),kernel);

%% showing image after convolution

newimg=cat(3,R1,G1,B1);
figure
imshow(newimg);
title('horizontal motion blurred');

%% restoring original image

[y,z,j]=size(R1);
H=zeros(y,z);
H(1:5,1:5)=kernel;
fftH=fft2(H);
newimg=cat(3,R1,G1,B1);
FFTR=fft2(R1);                  
FFTG=fft2(G1);
FFTB=fft2(B1);
FFTresultR=FFTR./fftH;
FFTresultG=FFTG./fftH;
FFTresultB=FFTB./fftH;
red=ifft2(FFTresultR);
green=ifft2(FFTresultG);
blue=ifft2(FFTresultB);
reconstruction=cat(3,red,green,blue);
[i,o,m]=size(reconstruction);

%% removing black parts

reconstruction(i-3:i,:,:)=[];
reconstruction(:,o-3:o,:)=[];

%% showing image after restoring

figure
imshow(reconstruction);
title('reconstructed image');