function [varargout] = OPTICSv2(X, epsilon, min_points, varargin)
    %% Init
    num_samples = size(X, 1);

    % allows for difference distance types
    if nargin == 1
        dist_type = varargin{1};
    else
        dist_type = 'euclidean';
    end

    % init vars
    is_visited = false(num_samples, 1);
    DistMatrix = pdist2(X, X, dist_type); % DM stands for distance matrix
    ReachDist = NaN(num_samples, 1); % RD stands for reachability distance
    CoreDist = compute_core_dist(); % CD stands for Core Distance
    order = zeros(num_samples, 1); % an ordered list, initially empty
    order_counter = 1;
    seeds = NaN(num_samples, 1);
    
    % here the NaN array is acting as the priority queue for OPTICS
    %% Main Loop
    for point = 1:num_samples
        if is_visited(point)
            continue
        end
        is_visited(point) = true;
        order(order_counter) = point;
        order_counter = order_counter + 1;
        if ~isnan(CoreDist(point))
            seeds = NaN(num_samples, 1);
            update(point);
            while sum(~isnan(seeds)) ~= 0
                [~, q_index] = max(seeds, [], 'omitnan');
                seeds(q_index) = NaN;
                is_visited(q_index) = true;
                order(order_counter) = q_index;
                order_counter = order_counter + 1;
                if ~isnan(CoreDist(q_index))
                    update(q_index)
                end
            end
        end
    end
    
    % output
    if (nargout == 1)
        varargout{1} = order;
    elseif (nargout == 2)
        varargout{1} = order;
        varargout{2} = ReachDist;
    elseif (nargout == 3)
        varargout{1} = order;
        varargout{2} = ReachDist;
        varargout{3} = CoreDist;
    end
          
    %% Auxiliary Functions
    function update(p)
        neighbours = find(get_neighbours(p));
        
        for idx = 1:length(neighbours)
            if ~is_visited(idx)
                % TODO : verify correctness of the input args
                reach_dist = compute_reachability_dist(p, neighbours(idx));
                if isnan(ReachDist(neighbours(idx)))
                    ReachDist(neighbours(idx)) = reach_dist;
                    seeds(neighbours(idx)) = reach_dist;
                else
                    if reach_dist < ReachDist(neighbours(idx))
                        ReachDist(neighbours(idx)) = reach_dist;
                        seeds(neighbours(idx)) = reach_dist;
                    end
                end
            end
        end
    end
    
    % computes the core distance of each point
    function CD = compute_core_dist()
        CD = NaN(num_samples, 1);
        for j = 1:num_samples
            [neighbours, distances] = get_neighbours(j);
            if nnz(neighbours) >= min_points
                distances = sort(distances);
                CD(j) = distances(min_points);
            end
        end
    end

    % computes the reachability distance of o from p
    function RD = compute_reachability_dist(p, o)
        RD = max([CoreDist(p), DistMatrix(p, o)], [], 'includenan');
    end

    % retuns logical index of points which are in the neighbourhood
    % of the input point i, optionally also returns the distances
    function [is_neighbour, varargout] = get_neighbours(i)
        is_neighbour = DistMatrix(:, i) <= epsilon;
        is_neighbour(i) = false;
        if (nargout == 2)
            varargout{1} = DistMatrix(is_neighbour, i);
        end
    end
end