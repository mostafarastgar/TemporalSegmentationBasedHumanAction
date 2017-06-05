dir_perfix='C:\Users\m_rastgar\Desktop\selective-stip\video\avi\';
mat_dir_perfix='C:\Users\m_rastgar\Desktop\selective-stip\video\mat\';
videos=dir(strcat(dir_perfix,'*.avi'));
file_names = {videos.name};
size_of_files=size(file_names,2);
for i=1 : size_of_files
    % this is basically for gray scale video
    file_name=strcat(dir_perfix,file_names{i});
    carobj=VideoReader(file_name);
    % the carwide.avi is video considered for making it % matrix

    nFrames=carobj.NumberOfFrames;

    M=carobj.Height; % no of rows

    N=carobj.Width; % no of columns

    video=zeros(M,N,nFrames,'uint8'); % creating a video 3d matrix

    for k= 1 : nFrames

        im= read(carobj,k);

        im=im(:,:,1);           % all three layers will have same image
        video(:,:,k)=im;
    end
    save(strcat(mat_dir_perfix,file_names{i},'.mat'), 'video');
    disp(i);
end