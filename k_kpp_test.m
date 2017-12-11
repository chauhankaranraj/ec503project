%% ORIGINAL DATA

% for reprocabbility
rng(10);

% load fisheriris
% % fisher iris data
% X = meas(:,3:4);
% y = grp2idx(categorical(species));
% X = all_data;

% % synthetic generated data
% load('gen_data.mat');
% X = transpose(data);

% read in COMPOUND data
fileID = fopen('flame.txt', 'r');
data = fscanf(fileID, '%f %f %i\n', [3 399]);
fclose(fileID);

% split x and y, represent data as rows
y = transpose(data(3, :));
X = transpose(data(1:2, :));

% number of clusters
k = 2;

% plot raw data
figure;
plot(X(:,1),X(:,2), 'k.','MarkerSize', 15);
xlabel 'Petal Lengths (cm)';
ylabel 'Petal Widths (cm)';
title 'Dataset';


%% K-MEANS

% get assignments and within cluster sum of squares
[k_centroids, k_wcss] = k_means(X, k, 100);

% pick closest cluster as assigment 
dist_from_centroids = NaN(size(X,1), k);
for c = 1:k
    dist_from_centroids(:, c) = sum((X - k_centroids(c, :)).^2, 2);
end
[~, k_preds] = min(dist_from_centroids, [], 2);

% plot kmeans assignments
figure;
for c_num = 1:max(k_preds)
    scatter(X(k_preds==c_num,1), X(k_preds==c_num,2), 'filled');
    hold on
end
legend('cluster 1', 'cluster 2');
title 'k-means';


%% K-MEANS++

% get assignments and within cluster sum of squares
[kpp_centroids, kpp_wcss] = k_means_pp(X, k, 100);

% pick closest cluster as assigment 
dist_from_centroids = NaN(size(X,1), k);
for c = 1:k
    dist_from_centroids(:, c) = sum((X - kpp_centroids(c, :)).^2, 2);
end
[~, kpp_preds] = min(dist_from_centroids, [], 2);

% plot kmeans++ assignments
figure;
for c_num = 1:max(kpp_preds)
    scatter(X(kpp_preds==c_num,1), X(kpp_preds==c_num,2), 'filled');
    hold on
end
legend('cluster 1', 'cluster 2');
title 'k-means++';


%% COMPARE K AND K++

% plot the objective function vs num_iter for k and k++
figure;
plot(1:numel(k_wcss), k_wcss);
hold on;
plot(1:numel(kpp_wcss), kpp_wcss);
legend('kmeans', 'kmeans++');
title 'Objective Function vs Number of  Iterations';

% plot kmeans++ centroids
figure;
scatter(k_centroids(:,1), k_centroids(:,2), 50, 's');
hold on;
scatter(kpp_centroids(:,1), kpp_centroids(:,2), 100, 'd');
legend('kmeans', 'kmeans++');
title 'Cluster Centroids'
