function samples = vibeUpdate(imagee, samples, u)

arand = randi(4,1,u*u);

b = sum(arand == 1);
f = find(arand == 1)';
d = randi(size(samples,2),b,1);

for j = 1:b
    samples(f(j),d(j)) = imagee(f(j));
end

end