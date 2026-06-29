function dist = vibeSegmentation(imagee, samples, N, R)

dist = zeros(length(imagee),N);

for j = 1:N
    dist(:,j) = abs(imagee - samples(:,j));
end

end