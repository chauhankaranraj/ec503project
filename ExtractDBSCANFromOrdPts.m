function assignments = ExtractDBSCANFromOrdPts(X, ordered_idx, reachability_dists, eps, min_pts)
% ExtractDBSCANFromOrdPts Takes output of the OPTICS algorithm as input and
%                         exploits it to cluster dataset using DBSCAN
%
% Assumes each column of X (nxd) is dimension and each row is data point
%
% Returns assignments

    % initial cluster id = 0, ie noise
    cluster_id = 0;
    assignments = zeros(numel(ordered_idx), 1);
    
    for i = 1:numel(ordered_idx)    
        % index in X of point in i-th row of ordered points
        pt_idx = ordered_idx(i);
        
        if (reachability_dists(pt_idx)) > eps || isnan(reachability_dists(pt_idx))
            if get_core_dist(X(pt_idx, :)) <= eps
                % new cluster core point
                cluster_id = cluster_id +1;
                assignments(pt_idx) = cluster_id;
            else
                % noise
                assignments(pt_idx) = 0;
            end
        else
            % belongs to same cluster
            assignments(pt_idx) = cluster_id;
        end
    end

    
    % HELPER FUNCITON
    
    function core_dist = get_core_dist(p)
    % get_core_dist Calculates the distance of each point in epsilon neighborhood
    % of p and returns the min_pt-th closest point
    %
    % Assumes each column of X (nxd) is dimension and each row is data point
    %
    % Returns core distance

        % distance of each point from p
        distances = pdist2(X, p, 'euclidean');

        % indices of points which are in eps neighborhood of p
        neighbors_idx = distances <= eps;

        % core dist undefined if number of pts in eps neighborhood is < MinPts
        if sum(neighbors_idx) < min_pts
            core_dist = NaN;
        else
            % remove distances to points which are not in eps neighborhood,
            % and sort the remaining points
            distances = sort(distances(neighbors_idx, :));

            % get the min_pts-th closest distance
            core_dist = distances(min_pts, 1);
        end
    end

end
