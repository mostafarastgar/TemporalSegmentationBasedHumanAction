latent =100* (latent(1) - latent);
for(i=size(latent, 1):-1:2)
    if(floor(latent(i)) ~= floor(latent(i-1)))
        break;
    end
end
