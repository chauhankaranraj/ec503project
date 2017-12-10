%% LOAD DATA

% read in combined data
fileID = fopen('../preprocess/Compound.txt', 'r');
data = fscanf(fileID, '%f %f %i\n', [3 399]);
fclose(fileID);

% split x and y, represent data as rows
y = transpose(data(3, :));
data = transpose(data(1:2, :));

%% PARAMETERS FOR DBSCAN, OPTICS

eps = 1.0125;
min_pts = 4;


%% DBSCAN

% get dbscan cluster assignments
[dbscan_labels, noise_idx] = DBSCAN(data, eps, min_pts);

% plot dbscan results
figure;
idx = false(numel(dbscan_labels), 1);
for cluster_num = 0:max(dbscan_labels)
    idx = dbscan_labels==cluster_num;
    scatter(data(idx, 1), data(idx, 2), 'filled');
    hold on;
end
legend(num2str(unique(dbscan_labels)));
hold off;


%% OPTICS

% get the order and reachability distances
[ordered_list, r_dists] = optics(data, eps, min_pts);

% reachability plot
figure;
plot(1:size(r_dists), r_dists);
yticks(0:0.5:max(r_dists));

% get optics labels
optics_labels = ExtractDBSCANFromOrdPts(data, ordered_list, r_dists, 4, min_pts);

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




