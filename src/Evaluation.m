function distanceVal = evaluation(centx, centy, gt)

distanceVal = sqrt((centx - gt(1))^2 + (centy - gt(2))^2);

end
