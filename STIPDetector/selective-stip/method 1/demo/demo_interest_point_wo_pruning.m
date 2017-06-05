%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @description : This scripts implements the demo of the interest point
% with pruning. Please edit the names of the test video if needed.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function demo_interest_point_wo_pruning(isPrun, isDisplay, video)

  % Adding search paths
  addpath('../src/');
  % Adding test video name
  test_vid_name = 'test_video.mat';

  % Initialzing sigma array
  sigma_array = [0.4;0.9;1.4]; % Possible ranges :[0.2; 0.5;0.9;1.3;1.8;2.3]
  bP = 0.30; %Possible values: [0.27-0.45]

  % Loading the test video
%   image_stack = load(test_vid_name);
  image_stack = video;

  if (isPrun)
  
    alpha_val = 1.5; % Possible values: [1.1 - 1.9]
    %gP = 0.985; %Possible values: [0.94-0.98]
    
    block_dim = 3; % Any odd number, but 3 is good choice.
  
    tic
      corner_points = FindInterestPointsWithPruning(image_stack, sigma_array, alpha_val, block_dim, bP);
    toc
  
    if (isDisplay)
     show_corner_points(image_stack, corner_points); 
    end
  
  else
    threshold = 0;
    tic
      corner_points = FindInterestPointsWithoutPruning(image_stack, sigma_array, bP, threshold);
    toc
  
    if (isDisplay)
      show_corner_points(image_stack, corner_points);
    end
  end
  
return;