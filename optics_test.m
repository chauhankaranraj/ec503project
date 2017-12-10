%% LOAD DATA

% read in combined data
fileID = fopen('../preprocess/flame.txt', 'r');
data = fscanf(fileID, '%f %f %i\n', [3 399]);
fclose(fileID);

% split x and y, represent data as rows
y = transpose(data(3, :));
data = transpose(data(1:2, :));

%% PARAMETERS FOR DBSCAN, OPTICS

% 4, 1.25, 2, 0.9
eps = 1.25;
min_pts = 4;
rng(1);

%% DBSCAN

% % get dbscan cluster assignments
% [dbscan_labels, noise_idx] = DBSCAN(data, eps, min_pts);
% 
% % plot dbscan results
% figure;
% for cluster_num = 0:max(dbscan_labels)
%     idx = dbscan_labels==cluster_num;
%     scatter(data(idx, 1), data(idx, 2), 'filled');
%     hold on;
% end
% legend(num2str(unique(dbscan_labels)));
% hold off;


%% OPTICS

% % Cross validate for minpts
% for i = 1:20
%     % get the order and reachability distances
%     [ordered_list, r_dists] = optics(data, eps, i);
% 
%     % % TODO: would doing this everywhere simplify life?
%     % % replace nan's with infinites
%     % r_dists(isnan(r_dists)) = 50;
% 
%     % reachability plot
%     figure;
%     plot(1:size(r_dists), r_dists);
% end

new_eps = 1.2;
new_min_pts = 2;

% get the order and reachability distances for new estimates of eps, minPts
[ordered_list, r_dists] = optics(data, eps, min_pts);

% % reachability plot
% figure;
% plot(1:size(r_dists), r_dists);

% estimate new eps using reachability plot, then get optics labels
optics_labels = ExtractDBSCANClustering(data, ordered_list, r_dists, new_eps, min_pts);

% plot optics results
figure;
idx = false(numel(optics_labels), 1);
for cluster_num = 0:max(optics_labels)
    idx = optics_labels==cluster_num;
    scatter(data(idx, 1), data(idx, 2), 'filled');
    hold on;
end
legend(num2str(unique(optics_labels)));
hold off;
