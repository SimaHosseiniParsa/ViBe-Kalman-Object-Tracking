clc
clear all
close all

%% Ground Truth
rf = fopen('gtfilename.txt');
of = textscan(rf,'%f%f%f%f',inf,'Delimiter','|');
of = cell2mat(of);

posx = of(:,1) + of(:,4)/2;
posy = of(:,2) + of(:,5)/2;
pos  = [posx posy];

%% Parameters
FrameNumber = 0;
widthwindow = 15;

N  = 10;
R  = 10;
Th = 5;
u  = 200;

%% Variables
ind = 0;
xc = [0;0;0;0;0];
cnv_f = 0;

imagee = zeros(1,u*u);
segMap = zeros(1,u*u);
samples = zeros(u*u,N);

VideoReader = vision.VideoFileReader('videofilename.avi');

%% Main Loop
while ~isDone(VideoReader)

    frame1 = step(VideoReader);
    FrameNumber = FrameNumber + 1;

    frame = rgb2gray(frame1);
    sz = size(frame);

    frame = imresize(frame,[u u]);

    dx = sz(1)/200;
    dy = sz(2)/200;

    imagee = round(reshape(frame,u*u,1)*255);

    %% ViBe Init + Segmentation + Update
    ind = ind + 1;

    [samples, ind] = vibeInitialization(imagee, samples, ind, N);

    dist = vibeSegmentation(imagee, samples, N, R);

    segMap = sum(dist <= R,2) >= Th;
    segMap = ~segMap;

    samples = vibeUpdate(imagee, samples, u);

    %% Morphology
    frame2 = reshape(segMap,u,u);
    frame2 = imopen(frame2,strel('square',3));
    frame2 = imfill(frame2,'holes');

    bw = bwlabel(frame2);
    Regions = regionprops(bw);

    %% Sort Regions
    if length(Regions) > 1
        for i = length(Regions)-1:-1:1
            for j = 1:i
                if Regions(j).Area < Regions(j+1).Area
                    tmp = Regions(j);
                    Regions(j) = Regions(j+1);
                    Regions(j+1) = tmp;
                end
            end
        end
    end

    %% Kalman Tracking
    [xc, cnv_f] = kalmanTracker(Regions, xc, FrameNumber, cnv_f);

    %% Visualization
    subplot(3,2,1)
    imshow(frame2)
    title(FrameNumber)

    subplot(3,2,2)
    imshow(imresize(frame1,[u u]))

    rectangle('Position', ...
        [xc(1)-floor(widthwindow/2), ...
         xc(3)-floor(widthwindow/2), ...
         widthwindow,widthwindow], ...
         'Linewidth',2);

    centx = xc(1)*dy;
    centy = xc(3)*dx;

    center(FrameNumber,:) = [centx centy];

    distance(FrameNumber,3) = sqrt( ...
        (centx - pos(FrameNumber,1))^2 + ...
        (centy - pos(FrameNumber,2))^2 );

    subplot(3,2,4)
    plot(1:FrameNumber,center(:,1),1:FrameNumber,pos(:,1),'Linewidth',2)
    legend('Kalman','GT')

    subplot(3,2,5)
    plot(1:FrameNumber,center(:,2),1:FrameNumber,pos(:,2),'Linewidth',2)
    legend('Kalman','GT')

    subplot(3,2,6)
    plot(1:FrameNumber,distance(1:FrameNumber,3),'Linewidth',2)

    pause(0.001)
end