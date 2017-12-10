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
% for i = 1:10
% 
% % get the order and reachability distances
% [ordered_list, r_dists] = optics(data, eps, i);
% 
% % % TODO: would doing this everywhere simplify life?
% % % replace nan's with infinites
% % r_dists(isnan(r_dists)) = 50;
% 
% % reachability plot
% figure;
% plot(1:size(r_dists), r_dists);
% end

% get the order and reachability distances
[ordered_list, r_dists] = optics(data, 5, 1);

% reachability plot
figure;
plot(1:size(r_dists), r_dists);

% estimate new eps using reachability plot, then get optics labels
new_eps = 100;
optics_labels = ExtractDBSCANClustering(data, ordered_list, r_dists, 1.575, 2);

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
