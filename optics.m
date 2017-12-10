function [ordered_idx_list, reach_dists] = optics(X, epsilon, min_pts)
% optics Uses the OPTICS algorithm to cluster dataset as input X, epsilon
% value as input epsilon, MinPts as input min_pts
%
% Assumes each column of X (nxd) is dimension and each row is data point
%
% Returns TODO (kxd)

    % number of points in training dataset
    num_pts = size(X, 1);
    
    % ordered list of data points
    ordered_idx_list = NaN(num_pts, 1);

    % reachability distance of each data point, initialized as undefined
    reach_dists = NaN(num_pts, 1);
    
    % logical array to keep track of what points have been processed
    is_idx_processed = false(num_pts, 1);
    
    for p_idx = 1:num_pts
        
        % if point has already been processed, move onto next point
        if is_idx_processed(p_idx)
            continue
        end
        
        % mark point as processed
        is_idx_processed(p_idx) = true;
        
        % output point to ordered list
        ordered_idx_list(find(isnan(ordered_idx_list),1), 1) = p_idx;
        
        % get logical array, 1 at indices which are neighbors of point
        is_idx_neighbor = get_neighbors(p_idx);
        
        if ~isnan(get_core_dist(X(p_idx, :)))
            
            % least-first priority queue. value at idx is priority of point at idx
            priorities = Inf(num_pts, 1);
            
            % get the updated reachability distances and priority queue seeds
            update(X(p_idx,:), is_idx_neighbor);
            
            % sorts descending, gives indices of points with descending priorities
            [priorities, pr_pt_idx] = sort(priorities);
            
            for pr_q_idx = 1:numel(priorities)
                
                % q_idx is index of point in dataset
                % it is least priority element in seeds
                q_idx = pr_pt_idx(pr_q_idx);
                
                % no more points with finite priority, so we're done
                % equivalent to seed list empty
                if priorities(pr_q_idx)==Inf
                    break
                end
                
                % TODO: can put this after checking for core dist
                % get neighbors of q
                q_is_idx_neighbor = get_neighbors(q_idx);
                
                % mark q as processed
                is_idx_processed(q_idx) = true;
                
                % add q to the ordered list by finding first nan and replacing it with q
                ordered_idx_list(find(isnan(ordered_idx_list),1), 1) = q_idx;
                
                % if core dist of q is not undefined then update
                if ~isnan(get_core_dist(X(q_idx, :)))
                   
                    % get the updated reachability distances and priority queue seeds
                    update(X(q_idx,:), q_is_idx_neighbor);
                    
                end
                
            end
            
        end

    end

    
    % HELPER FUNCTIONS
    
    function is_neighbors = get_neighbors(pt_idx)
    % get_neighbors Gets the indices of points present in dataset input X that
    % are in epsilon region of data point p, i.e., the neighbors of p
    %
    % Assumes each column of X (nxd) is dimension and each row is data point
    %
    % Returns indices of neighbors of p

        % distance of each point from p
        distances = pdist2(X, X(pt_idx,:), 'euclidean');

        % return indices of points which are in eps neighborhood of p
        is_neighbors = distances <= epsilon;
        
%         % point is not neighbor of itself
%         is_neighbors(pt_idx) = false;

    end

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
        neighbors_idx = distances <= epsilon;

        % core dist undefined if number of pts in eps neighborhood is < MinPts
        if sum(neighbors_idx) < min_pts
            core_dist = NaN;
        else
            % remove distances to points which are not in eps neighborhood
            distances = sort(distances(neighbors_idx, :));

            % get the min_pts-th closest distance
            core_dist = distances(min_pts, 1);
        end

    end

    function update(p, is_neighbor)
    % get_core_dist Calculates the distance of each point in epsilon neighborhood
    % of p and returns the min_pt-th closest point
    %
    % Assumes each column of X (nxd) is dimension and each row is data point
    %
    % Returns core distance

        % get core distance of p
        core_dist = get_core_dist(p);

        for o_idx = 1:num_pts

            % if point is a neighbor that has not been processed
            if is_neighbor(o_idx) && ~is_idx_processed(o_idx)

                % calculate new reachability dist as max of core dist and dist(p,o)
                curr_reach_dist = max(core_dist, pdist2(p, X(o_idx, :)));

                if (isnan(reach_dists(o_idx))) || (curr_reach_dist < reach_dists(o_idx))

                    % update value of reachability distance
                    reach_dists(o_idx) = curr_reach_dist;

                    % update priority queue
                    priorities(o_idx) = curr_reach_dist;

                end

            end

        end

    end
    
    
end
