%% LOAD DATA

% for reprocabbility
rng(10);

% load and parse data
fileID = fopen('Compound.txt', 'r');
X = fscanf(fileID, '%f %f %i\n', [3 399]);
fclose(fileID);

% split x and y, represent data as rows
y = transpose(X(3, :));
X = transpose(X(1:2, :));

num_iters = 100;


%% K-MEANS

% CROSS VALIDATION FOR k
vals = zeros(20,1);
for k = 1:20
    % get assignments and within cluster sum of squares
    [k_assignments, ~, ~] = k_means(X, k, num_iters);

    % nmi score
    k_nmi = nmi(k_assignments, y);

    vals(k) = k_nmi;
end

% number of clusters for k selected by cross validation
k = 3;

% get assignments and within cluster sum of squares
[k_assignments, k_centroids, k_wcss] = k_means(X, k, num_iters);

% nmi score
k_nmi = nmi(k_assignments, y);

% plot kmeans assignments
figure;
for c_num = 1:k
    scatter(X(k_assignments==c_num,1), X(k_assignments==c_num,2), 'filled');
    hold on
end
legend(num2str(transpose(1:k)));
title 'kmeans, k = 3';

% number of clusters for k selected by domain knowledge of ground truth
k = 6;

% get assignments and within cluster sum of squares
[k_assignments, k_centroids, k_wcss] = k_means(X, k, num_iters);

% nmi score
k_nmi = nmi(k_assignments, y);

% plot kmeans assignments
figure;
for c_num = 1:k
    scatter(X(k_assignments==c_num,1), X(k_assignments==c_num,2), 'filled');
    hold on
end
legend(num2str(transpose(1:k)));
title 'kmeans, k = 6';


%% K-MEANS

% CROSS VALIDATION FOR k
vals = zeros(20,1);
for k = 1:20
    % get assignments and within cluster sum of squares
    [kpp_assignments, ~, ~] = k_means_pp(X, k, num_iters);

    % nmi score
    kpp_nmi = nmi(kpp_assignments, y);

    vals(k) = kpp_nmi;
end

% number of clusters for k selected by cross validation
k = 5;

% get assignments and within cluster sum of squares
[kpp_assignments, kpp_centroids, kpp_wcss] = k_means_pp(X, k, num_iters);

% nmi score
kpp_nmi = nmi(kpp_assignments, y);

% plot kmeans assignments
figure;
for c_num = 1:k
    scatter(X(kpp_assignments==c_num,1), X(kpp_assignments==c_num,2), 'filled');
    hold on
end
legend(num2str(transpose(1:k)));
title 'kmeans++, k = 5';

% number of clusters for k selected by domain knowledge of ground truth
k = 6;

% get assignments and within cluster sum of squares
[kpp_assignments, kpp_centroids, kpp_wcss] = k_means_pp(X, k, num_iters);

% nmi score
kpp_nmi = nmi(kpp_assignments, y);

% plot kmeans assignments
figure;
for c_num = 1:k
    scatter(X(kpp_assignments==c_num,1), X(kpp_assignments==c_num,2), 'filled');
    hold on
end
legend(num2str(transpose(1:k)));
title 'kmeans++, k = 6';


%% DBSCAN

% % CROSS VALIDATE FOR DBSCAN PARAMETERS

% % init dbscan parameters
% eps = 1.25;
% min_pts = 4;

% for i = 2:10
%     figure;
%     nmis = zeros(10,1);
%     for j = 0.25:0.25:2.5
%         % get assignments and noise labels
%         [dbscan_assignments, dbscan_noise] = DBSCAN(X, j, i);
% 
%         % nmi score
%         dbscan_nmi = nmi(dbscan_assignments, y);
% 
%         nmis(j*4) = dbscan_nmi;
%     end
%     plot(0.25:0.25:2.5, nmis);
%     fprintf('minpts = %d, best nmi= %d\n', i, max(nmis));
% end

% best dbscan parameters from cross validation over nmi
eps = 1.5;
min_pts = 2;

% get dbscan cluster assignments
[dbscan_assignments, noise_idx] = DBSCAN(X, eps, min_pts);

% nmi score
dbscan_nmi = nmi(dbscan_assignments, y);

% plot dbscan results
figure;
for cluster_num = min(dbscan_assignments):max(dbscan_assignments)
    idx = dbscan_assignments==cluster_num;
    scatter(X(idx, 1), X(idx, 2), 'filled');
    hold on;
end
legend(num2str(unique(dbscan_assignments)));
title 'DBSCAN, Eps=1.5, MinPts=2'
hold off;


%% OPTICS

% get the order and reachability distances for new estimates of eps, minPts
[ordered_list, r_dists] = optics(X, eps, min_pts);

% % CROSS VALIDATION FOR BEST PARAMETER
% % reachability plot
% figure;
% plot(1:size(r_dists), r_dists);

% cross validated value of eps, for more nuanced clustering
new_eps = 1.2;

% estimate new eps using reachability plot, then get optics labels
optics_assignments = ExtractDBSCANClustering(X, ordered_list, r_dists, new_eps, min_pts);

% nmi score
optics_nmi = nmi(optics_assignments, y);

% plot dbscan results
figure;
for cluster_num = min(optics_assignments):max(optics_assignments)
    idx = optics_assignments==cluster_num;
    scatter(X(idx, 1), X(idx, 2), 'filled');
    hold on;
end
legend(num2str(unique(optics_assignments)));
title 'OPTICS, Eps=1.2, MinPts=2'
hold off;
