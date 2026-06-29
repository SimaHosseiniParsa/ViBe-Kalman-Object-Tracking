function plotResults(center, pos, distance, FrameNumber)

subplot(3,2,4)
plot(1:FrameNumber,center(:,1), ...
     1:FrameNumber,pos(:,1),'Linewidth',2)
legend('Kalman','GT')
title('X')

subplot(3,2,5)
plot(1:FrameNumber,center(:,2), ...
     1:FrameNumber,pos(:,2),'Linewidth',2)
legend('Kalman','GT')
title('Y')

subplot(3,2,6)
plot(1:FrameNumber,distance(1:FrameNumber,3),'Linewidth',2)
title('Euclidean Error')

end