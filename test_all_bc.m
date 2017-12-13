%% LOAD DATA

fileID = fopen('./bc/wdbc.data');
X = textscan(fileID,'%d, %c, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f');
fclose(fileID);

% split x, y, id num
ids = cell2mat(X(1, 1));
y = cell2mat(X(1, 2));
X = cell2mat(X(1, 3:end));

% convert char to double. 1 is malignant, 2 is benign
y = grp2idx(y);

num_pts = size(X,1);
num_features = size(X,2);

%% K, K++ PARAMETERS

% only two classes - m, b
k = 2;

% number of iterations to run in k, k++, dp
num_iters = 100;


%% K-MEANS

% get assignments and within cluster sum of squares
[k_assignments, k_centroids, k_wcss] = k_means(X, k, num_iters);

% nmi score
k_nmi = nmi(k_assignments, y);


%% K-MEANS++

% get assignments and within cluster sum of squares
[kpp_assignments, kpp_centroids, kpp_wcss] = k_means_pp(X, k, num_iters);

% nmi score
kpp_nmi = nmi(kpp_assignments, y);


%% DP-MEANS

% cost to start new cluster in dp
% cross vaidated in range 1 to 10,000,000 (steps of 10, 100, 1000, 10000, etc) for highest nmi
lambda = 10000000;

% get assignments and within cluster sum of squares
[dp_assignments, dp_k, dp_objfunc, dp_centroids] = DPMeans(X, lambda);

% nmi score
dp_nmi = nmi(dp_assignments, y);


%% DBSCAN

% init dbscan parameters
eps = 10;
min_pts = 4;

% % CROSS VALIDATE FOR DBSCAN PARAMETERS
% 
% % distance matrix
% DM = pdist2(X, X);
% 
% k_dists = zeros(num_pts, 1);
% for pt_num = 1:num_pts
%     dists = DM(pt_num, :);
%     dists = sort(dists, 'ascend');
%     k_dists(pt_num) = dists(min_pts);
% end
% k_dists = sort(k_dists, 'descend');
% 
% % knee plot
% figure;
% plot(1:num_pts, k_dists);
% xlabel 'Point'
% ylabel 'K-Dist'
% title 'Distance to k-th NN for MinPts = 4'
% 
% for i = 7:7
%     figure;
%     nmis = zeros(10,1);
%     for j = 10:10:100
%         % get assignments and noise labels
%         [dbscan_assignments, dbscan_noise] = DBSCAN(X, j, i);
% 
%         % nmi score
%         dbscan_nmi = nmi(dbscan_assignments, y);
% 
%         nmis(j/10) = dbscan_nmi;
%     end
%     plot(10:10:100, nmis);
%     fprintf('minpts = %d, best nmi= %d\n', i, find(nmis==max(nmis)));
% end

% cross validated best nmi dbscan parameters
eps = 40;
min_pts = 7;

% get assignments and noise labels
[dbscan_assignments, dbscan_noise] = DBSCAN(X, eps, min_pts);

% nmi score
dbscan_nmi = nmi(dbscan_assignments, y);


%% OPTICS

% get the order and reachability distances for new estimates of eps, minPts
[ordered_list, r_dists] = optics(X, eps, min_pts);

% % CROSS VALIDATION FOR BEST PARAMETER
% % reachability plot
% figure;
% plot(1:size(r_dists), r_dists);

% if we want more nuanced clusters (eg malign, benign, close to malign,
% close to benign, etc) then new_eps = 39
% if we want only two clusters, malign and benign, new_eps = 39.5
new_eps = 39.5;

% estimate new eps using reachability plot, then get optics labels
optics_assignments = ExtractDBSCANClustering(X, ordered_list, r_dists, new_eps, min_pts);

% nmi score
optics_nmi = nmi(optics_assignments, y);
