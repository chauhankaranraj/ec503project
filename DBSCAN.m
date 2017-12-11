function [assignments, li_noise] = DBSCAN(X, epsilon, min_points, varargin)
%{
Algorithm Pseudocode
From WikiPedia

DBSCAN(DB, dist, eps, minPts) {
   C = 0                                              /* Cluster counter */
   for each point P in database DB {
      if label(P) ? undefined then continue           /* Previously processed in inner loop */
      Neighbors N = RangeQuery(DB, dist, P, eps)      /* Find neighbors */
      if |N| < minPts then {                          /* Density check */
         label(P) = Noise                             /* Label as Noise */
         continue
      }
      C = C + 1                                       /* next cluster label */
      label(P) = C                                    /* Label initial point */
      Seed set S = N \ {P}                            /* Neighbors to expand */
      for each point Q in S {                         /* Process every seed point */
         if label(Q) = Noise then label(Q) = C        /* Change Noise to border point */
         if label(Q) ? undefined then continue        /* Previously processed */
         label(Q) = C                                 /* Label neighbor */
         Neighbors N = RangeQuery(DB, dist, Q, eps)   /* Find neighbors */
         if |N| ? minPts then {                       /* Density check */
            S = S + N                                 /* Add new neighbors to seed set */
         }
      }
   }
}
%}

    % get metadata
    num_samples = size(X, 1);

    % allows for difference distance types
    if nargin == 1
        dist_type = varargin{1};
    else
        dist_type = 'euclidean';
    end

    % init vars
    num_clusters = 0;
    DM = pdist2(X, X, dist_type); % DM stands for distance matrix
    assignments = zeros(num_samples, 1);
    li_visited = false(num_samples, 1);
    li_noise = false(num_samples, 1);


    for ii = 1:num_samples
        if ~li_visited(ii)
            li_neighbours = get_neighbours(ii);
            if sum(li_neighbours) < min_points
               li_noise(ii) = true;
            else
                num_clusters = num_clusters + 1;
                grow_cluster(ii);
            end
        end
    end

    % returns the points that are considered the neighboours of the input
    % point given by the index 'idx'
    function li_neighbours = get_neighbours(idx)
        li_neighbours = DM(:, idx) <= epsilon;
    end
    

    % given a point in a cluter, adds more points to it by scanning all the
    % surrounding neighbours of the point
    function grow_cluster(idx)
        assignments(idx) = num_clusters;
        neighbours = get_neighbours(idx) & ~li_visited;
            
        while sum(neighbours) > 0
            % remove from visit queue, add to cluster, and proess its
            % neighbours
            p_index = find(neighbours, 1);
            li_visited(p_index) = true;
            li_noise(p_index) = false;
            neighbours(p_index) = 0;
            
            % perfrom BFS on all the beighbours of the point idx
            p_neighbours = get_neighbours(p_index) & ~li_visited;
            if sum(p_neighbours) >= min_points
                neighbours = neighbours | p_neighbours;
            end
            assignments(p_index) = num_clusters;
        end
    end
end
