% Number of rows and columns in the image region to process.
numRows = floor(imgSize(1)*0.54);
numCols = imgSize(2);

% To handle different video sizes other than [240 360], scaling the Hough
% transform rho values by the below factor is required.
factor = sqrt(sum(imgSize.^2)) / sqrt(sum([600 800].^2));

%% parameters for the second lane
%approximately 35:45 (0-based index: 414:424)
startIdxRho_R = floor(factor * 414);
NumRhos_R = floor(factor * 11);

%approximately -90:-70 degrees (0-based index: 0:20)
startIdxTheta_R = 0;
NumThetas_R = 21;
neighborhood_R =  [min(7,NumRhos_R), min(7,NumThetas_R)];

%approximately 379:415 (0-based index: 0:35)
startIdxRho_L = floor(factor *379);
NumRhos_L = floor(factor * 11);

%approximately 55:85 degrees (0-based index: 145: 175)
startIdxTheta_L = 145;
NumThetas_L = 21;
neighborhood_L =  [min(7,NumRhos_L), min(7,NumThetas_L)];

% Maximum number of lanes to find in the current frame.
expLaneNum = 4; 

% Maximum number of lanes to store in the tracking repository.
maxLaneNum = 10;

% Angular resolution of Hough transform, i.e., the width of a theta bin is
% pi/angleNum.
angleNum = 180;

% Maximum allowable change of lane distance metric between two frames.
trackThreshold = 45;

% Minimum number of frames a lane must be detected to become a valid lane.
frameFound = 5;

% Maximum number of frames a lane can be missed without marking it invalid. 
frameLost = 50;

% Size of the neighborhood around the maxima over which the Hough
% transforms values are suppressed. (Used in Find Local Maxima block)
neighborhood=[161, 31];

% Weight (tweaking factor) of the angular difference for calculating the
% distance metric between two lanes. It is typically chosen to be close
% to the input image rows.
distanceMetricWeight = 100;

% Audio track used for lane cross warning.
% load viprumbling.mat;
