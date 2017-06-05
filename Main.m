tic;
stips = demo_selective_stip(0, video);
HOG3DFeatures = HOG3DAPI(video, stips, 8*162, 9);
HOOFFeatures = HOOFAPI(video, stips, 32, 9);
features = [HOG3DFeatures HOOFFeatures];
toc;