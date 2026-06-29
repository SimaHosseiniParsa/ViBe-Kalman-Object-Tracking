% Read video frame
frame = rgb2gray(step(VideoReader));
frame = imresize(frame,[200 200]);

% Convert image to vector
imgVec = double(frame(:));

% ViBe Foreground Detection
for k = 1:N
    dist(:,k) = abs(imgVec - samples(:,k));
end

matchCount = sum(dist <= R,2);
foregroundMask = matchCount < Th;

% Background Update
idx = find(randi(4,length(imgVec),1) == 1);

for k = 1:length(idx)
    samples(idx(k),randi(N)) = imgVec(idx(k));
end

% Morphological Processing
mask = reshape(foregroundMask,200,200);
mask = imopen(mask,strel('square',3));
mask = imfill(mask,'holes');

% Object Detection
stats = regionprops(mask,'Area','Centroid');

if ~isempty(stats)

    [~,ind] = max([stats.Area]);
    centroid = stats(ind).Centroid;

    % Kalman Prediction / Update
    measurement = [centroid(1); centroid(2)];

    xPred = F*x;
    PPred = F*P*F' + Q;

    K = PPred*H'/(H*PPred*H' + Rk);

    x = xPred + K*(measurement - H*xPred);
    P = (eye(size(K,1)) - K*H)*PPred;

end