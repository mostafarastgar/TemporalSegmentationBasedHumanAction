function [corner_points] = demo(isDisplay, video)

corner_points = [];
for i=1:size(video, 3)
    f1=video(:, :, i);
    [ysize,xsize]=size(f1);
    nptsmax=40;
    kparam=0.04;
    pointtype=1;
    sxl2=4;
    sxi2=2*sxl2;
    % detect points
    [posinit,valinit]=STIP(f1,kparam,sxl2,sxi2,pointtype,nptsmax);
    corner_points = [corner_points; posinit(:, 2) posinit(:, 1) repmat(i, size(posinit, 1), 1)];
end
if (isDisplay)
    show_corner_points(video, corner_points);
end
end