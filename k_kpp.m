%% ORIGINAL DATA
% load fisheriris

% X = meas(:,3:4);
% y = grp2idx(categorical(species));
% X = all_data;

% read in combined data
fileID = fopen('../preprocess/Compound.txt', 'r');
data = fscanf(fileID, '%f %f %i\n', [3 399]);
fclose(fileID);

% split x and y, represent data as rows
y = transpose(data(3, :));
X = transpose(data(1:2, :));

k = 2;

% figure;
% plot(X(:,1),X(:,2), 'k.','MarkerSize', 15);
% title 'Fisher''s Iris Data';
% xlabel 'Petal Lengths (cm)';
% ylabel 'Petal Widths (cm)';

% %% GENERATED DATA
% 
% load('gen_data.mat');
% 
% X = transpose(data);

%% K-MEANS

% randomly select k points as centroids
centroids = get_initial_centroids(X, k);

max_iterations = 100;

% wcss at each iter
wcss = zeros(max_iterations, 1);

for i=1:max_iterations

    % find which is the closest centroid for each point
    assignments = get_assignments(X, centroids);
    
    k_wcss = 0;
    
    for j = 1:k
        
        % get all points correspoding to centroid j
        centroid_pts_idx = assignments == j;
        
        k_wcss = k_wcss + sum(sum(pdist2(centroids(j, :), X(centroid_pts_idx, :), 'squaredeuclidean')));

        % set new centroid j as mean of all points closest to previous j
        centroids(j, :) = mean(X(centroid_pts_idx, :));

    end
    
    % wcss for this iter
    wcss(i) = k_wcss;
    
end

figure;
scatter(1:max_iterations, wcss);

% figure;
% plot(centroids(:,1), centroids(:,2), 'k.','MarkerSize', 15);
% title 'K-means centroids for Fisher''s Iris Data';
% xlabel 'Petal Lengths (cm)';
% ylabel 'Petal Widths (cm)';

% calculate distance of each point from each centroid
dist_from_centroids = NaN(size(X,1), k);
for c = 1:k
    dist_from_centroids(:, c) = sum((X - centroids(c, :)).^2, 2);
end

% select closest centroid as representative class
[~, k_preds] = min(dist_from_centroids, [], 2);

figure;

for c_num = 1:max(k_preds)
    scatter(X(k_preds==c_num,1), X(k_preds==c_num,2), 'MarkerFaceColor', rand(1,3));
    hold on
end

title 'k-means on Fisher Iris Data';

figure;
scatter(centroids(:,1), centroids(:,2), 'MarkerFaceColor', rand(1,3));
disp(centroids);
title 'k-means centroids for Fisher Iris Data'

%% K-MEANS++

% select k points as centroids as per k-means++
centroids = get_kpp_centroids(X, 3);

max_iterations = 100;
for i=1:max_iterations
    
    % find which is the closest centroid for each point
    assignments = get_assignments(X, centroids);
    
    for j = 1:k
        
        % get all points correspoding to centroid j
        centroid_pts_idx = assignments == j;
        
        % set new centroid j as mean of all points closest to previous j
        centroids(j, :) = mean(X(centroid_pts_idx, :));
    
    end
    
end

% figure;
% plot(centroids(:,1), centroids(:,2), 'k.','MarkerSize', 15);
% title 'K-means++ centroids for Fisher''s Iris Data';
% xlabel 'Petal Lengths (cm)';
% ylabel 'Petal Widths (cm)';

% calculate distance of each point from each centroid
dist_from_centroids = NaN(size(X,1), k);
for c = 1:k
    dist_from_centroids(:, c) = sum((X - centroids(c, :)).^2, 2);
end

% select closest centroid as representative class
[~, kpp_preds] = min(dist_from_centroids, [], 2);

figure;

for c_num = 1:max(kpp_preds)
    scatter(X(kpp_preds==c_num,1), X(kpp_preds==c_num,2), 'MarkerFaceColor', rand(1,3));
    hold on
end

title 'k-means++ on Fisher Iris Data';

figure;
scatter(centroids(:,1), centroids(:,2), 'MarkerFaceColor', rand(1,3));
disp(centroids);
title 'k-means++ centroids for Fisher Iris Data'


%% HELPER FUNCTIONS

function closest_centroids = get_assignments(X, centroids)
% get_assignments  Finds closest centroid to each point
%
% Assumes each column of X (nxd) is dimension and each row is data point
% Each column of centroids (kxd) is dimension and each row is data point
%
% Returns closest_centroids  (nx1) of centroid number closest to each point

    % number of centroids
    k = size(centroids,1);

    % nxk matrix where row i,col j is distance of ith pt from jth centroid 
    distances_from_centroids = zeros(size(X,1), k);
    
    % calculate distance from each centroid
    for c_num = 1:k
        
        distances_from_centroids(:, c_num) = sum(((X - centroids(c_num, :)) .^ 2), 2);
    
    end

    % get the closest centroid number
    [~, closest_centroids] = min(distances_from_centroids, [], 2);

end


function initial_centroids = get_kpp_centroids(X, k)
% get_kpp_centroids  Finds initial centroids as per k-means++ algorithm
%
% Assumes each column of X (nxd) is dimension and each row is data point
%
% Returns initial_centroids (kxd)

    % initialize matrix as NaN's so that max funcion chooses defined value 
    % over other centroids
    initial_centroids = NaN(k, size(X,2));
    
    % select first centroid randomly
    initial_centroids(1, :) = X(randi([1 k]), :);
    
    % initialize distances of each point from each centroid
    distances = zeros(size(X,1), k);
    
    for c_num = 1:k
        
        % find distance of each point from each centroid
        for c_dist = 1:k
            distances(:, c_dist) = sum((X-initial_centroids(c_dist, :)).^2, 2);
        end
        
        % get the closest centroid, select the point with max distance to 
        % its closest centroid
        [~, c_idx] = max(min(distances, [], 2));
        
        % save the point at c_idx as a new centroid
        initial_centroids(c_num, :) = X(c_idx, :);
        
    end

end


function initial_centroids = get_initial_centroids(X, k)
% get_initial_centroids  Randomly chooses k points as initial centroids
%
% Assumes each column of X (nxd) is dimension and each row is data point
%
% Returns initial_centroids (kxd)

    % indices of data points to be selected as initial centroids
    x_indices = randperm(size(X,1), k);
    
    % extract data points at chosen indices
    initial_centroids = X(x_indices, :);

end
