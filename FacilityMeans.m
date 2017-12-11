% ENG EC 503 - Fall 2017
% DP Means Implementation for Final Project

function [assignments, k, varargout] = FacilityMeans(X, lambda)
%% Init
t_max = 100;
num_samples = size(X, 1);
num_features = size(X, 2);

% start with the global mean as the only cluster center
F_prime = mean(X);
% and all the points in the same global mean cluster
assignments = ones(1, num_samples);
obj_func = zeros(1, t_max);

    for t = 1:t_max
        %% Assignment Step
        % start with empty facility list
        DM = pdist2(X, F_prime, 'squaredeuclidean');
        faraway_points = X(all(transpose(DM > lambda)));
        
        % candidate facility list
        F = cat(1, F_prime, faraway_points);
        
        % chosen facility list and facility count
        F_prime = [];
        DM = pdist2(X, F, 'squaredeuclidean');

        % number of data pointes already assigned to facility
        num_assigned = 0;
        k = 0;
        
        % running onj func value for this iteration
        running_cost = 0;
        % sort distnaces from current point being looked at to all
        % other F
        while num_assigned ~= num_samples
            % only pick one facility at a time
            % go through the entire facility list and pick the one
            % that minimizes the cost summation
            
            % running min cost of a facility and its index in the facility
            best_facility_cost = Inf;
            best_facility_idx = -1;
            best_facility_clients = [];

            
            % iterate over all facilies to find the best one every itr
            for f = 1:size(F, 1)
                % we need to cat the indeces so we know which poitns are
                % which when we sort by the first row (divergences)
                dist_slice = cat(2, DM(:, f), (1:length(DM(:, f)))');
                dist_slice = sortrows(dist_slice);
                this_facility_cost = Inf;

                for j = 1:length(dist_slice) % iterate over remaining points
                    % calc cost of this faciltiy with j closest points
                    cur_cost = (lambda + sum(dist_slice(1:j, 1))) / j;
                    
                    if cur_cost < this_facility_cost
                        this_facility_cost = cur_cost;                    
                    else
                        % the previous iteration was the least cost, save
                        % its stats, including cost for the obj_func
                        % then use the previous cost as the facility cost
                        this_facility_clients = dist_slice(1:j-1, 2);
                        break
                    end
                end
                
                if this_facility_cost < best_facility_cost
                    best_facility_cost = this_facility_cost;
                    best_facility_clients = this_facility_clients;
                    best_facility_idx = f;
                end
            end
            
            F_prime = cat(1, F_prime, F(best_facility_idx, :));
            F(best_facility_idx, :) = [];
            assignments(best_facility_clients) = k;
            k = k + 1;
            num_assigned = num_assigned + length(best_facility_clients);
            % increment obj func value
            running_cost = running_cost + best_facility_cost;
            % dont look at these points again
            DM(best_facility_clients, :) = Inf;
        end
        
        obj_func(t) = running_cost;
        
        %% Update Step
        for c = 1:k
            % new centroid is the mean of all the data points in the cluster
            F_prime(c, :) = mean(X(assignments == c, :), 1);
        end
    end
    
    if nargout == 3
        varargout{1} = F_prime;
    elseif nargout == 4
        varargout{1} = F_prime;
        varargout {2} = obj_func;
    end    
end


% now remove those points
            % for each facility in the list of facilities
                % add points based on ascending order of sqeuc dist
                % until the cost of the facility is not minimized
                % not add those points to the number of points assgined and
                % remove them from future lookahead
