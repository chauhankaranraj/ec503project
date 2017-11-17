load fisheriris

X = meas(:,3:4);
y = grp2idx(categorical(species));


function TODO = optics(X, epsilon, min_pts)
% optics Uses the OPTICS algorithm to cluster dataset as input X, epsilon
% value as input epsilon, MinPts as input min_pts
%
% Assumes each column of X (nxd) is dimension and each row is data point
%
% Returns TODO (kxd)

    % number of points in training dataset
    num_pts = size(X, 1);

    % reachability distance of each data point, initialized as undefined
    reach_dists = NaN(num_pts, 1);
    
    % logical array to keep track of what points have been processed
    is_processed = false(num_pts, 1);
    
    neighbors = get_neighbors();
    
    

end


function neighbors = get_neighbors(p, X, epsilon)
% get_neighbors Gets the points present in dataset input X that are in
% epsilon region of data point p, i.e., the neighbors of p
%
% Assumes each column of X (nxd) is dimension and each row is data point
%
% Returns neighbors of p

    

end

