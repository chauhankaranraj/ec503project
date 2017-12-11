%% ORIGINAL DATA

% for reprocabbility
rng(10);

% load fisheriris
% % fisher iris data
% X = meas(:,3:4);
% y = grp2idx(categorical(species));
% % X = all_data;

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

% % plot raw data
% figure;
% plot(X(:,1),X(:,2), 'k.','MarkerSize', 15);
% title 'Dataset';


%% K-MEANS

% get assignments and within cluster sum of squares
[k_assignments, k_centroids, k_wcss] = k_means(X, k, 100);

% plot kmeans assignments
figure;
for c_num = 1:max(k_assignments)
    scatter(X(k_assignments==c_num,1), X(k_assignments==c_num,2), 'filled');
    hold on
end
legend(num2str(transpose(1:k)));
title 'kmeans, k = 2';


%% K-MEANS++

% get assignments and within cluster sum of squares
[kpp_assignments, kpp_centroids, kpp_wcss] = k_means_pp(X, k, 100);

% plot kmeans++ assignments
figure;
for c_num = 1:max(kpp_assignments)
    scatter(X(kpp_assignments==c_num,1), X(kpp_assignments==c_num,2), 'filled');
    hold on
end
legend(num2str(transpose(1:k)));
title 'k-means++';


%% DP-MEANS

[dp_k, dp_centroids, dp_assignments, dp_wcss] = DPMeans(X, 7.5);

% plot dp means assignments
figure;
for c_num = 1:max(dp_assignments)
    scatter(X(dp_assignments==c_num, 1), X(dp_assignments==c_num, 2), 'filled');
    hold on
end
legend(num2str(transpose(1:dp_k)));
title 'DP means';


%% COMPARE K, K++, DP

% plot the objective function vs num_iter for k and k++
figure;
plot(1:numel(k_wcss), k_wcss, 'LineWidth', 1.25);
hold on;
plot(1:numel(kpp_wcss), kpp_wcss, 'LineWidth', 1.25);
hold on;
plot(1:numel(dp_wcss), dp_wcss, 'LineWidth', 1.25);
legend('kmeans', 'kmeans++', 'DP means');
title 'Objective Function vs Number of  Iterations';

% plot kmeans, kmeans++, dp means centroids
figure;
scatter(k_centroids(:,1), k_centroids(:,2), 50, 's', 'LineWidth', 1.25);
hold on;
scatter(kpp_centroids(:,1), kpp_centroids(:,2), 100, 'd', 'LineWidth', 1.25);
hold on;
scatter(dp_centroids(:,1), dp_centroids(:,2), 100, 'x', 'LineWidth', 1.25);
legend('kmeans', 'kmeans++', 'DP means');
title 'Cluster Centroids'
