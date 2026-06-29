function [samples, ind] = vibeInitialization(imagee, samples, ind, N)

if ind <= N
    samples(:,ind) = imagee;
end

end