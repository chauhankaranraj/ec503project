%% LOAD DATA

% load fisheriris
% % fisher iris data
% data = meas(:,3:4);
% y = grp2idx(categorical(species));

% read in combined data
fileID = fopen('Compound.txt', 'r');
data = fscanf(fileID, '%f %f %i\n', [3 399]);
fclose(fileID);

% split x and y, represent data as rows
y = transpose(data(3, :));
data = transpose(data(1:2, :));

%% DEFINE PARAMETERS

% for reproducability
rng(1);

% 4, 1.25 - compound
% 4, 1.6, 2, 0.9
eps = 1.25;
min_pts = 4;

%% DBSCAN

% get dbscan cluster assignments
[dbscan_labels, noise_idx] = DBSCAN(data, eps, min_pts);

% plot dbscan results
figure;
for cluster_num = min(dbscan_labels):max(dbscan_labels)
    idx = dbscan_labels==cluster_num;
    scatter(data(idx, 1), data(idx, 2), 'filled');
    hold on;
end
legend(num2str(unique(dbscan_labels)));
xlabel 'x1'
ylabel 'x2'
title 'DBSCAN, Eps=1, MinPts=2'
hold off;

% nmi score
dbscan_nmi = nmi(dbscan_labels, y);


%% OPTICS

% Cross validate for minpts
for i = 4:4
    % get the order and reachability distances
    [ordered_list, r_dists] = optics(data, eps, i);

    % % TODO: would doing this everywhere simplify life?
    % % replace nan's with infinites
    % r_dists(isnan(r_dists)) = 50;

    % reachability plot
    figure;
    plot(1:size(r_dists), r_dists);
    xlabel 'Point'
    ylabel 'Reachability Distance'
    title 'Reachability Plot, MinPts=4, Eps=1.5'
end

% get the order and reachability distances for new estimates of eps, minPts
[ordered_list, r_dists] = optics(data, eps, min_pts);

% % reachability plot
% figure;
% plot(1:size(r_dists), r_dists);

new_eps = 1.15;

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
xlabel 'x1'
ylabel 'x2'
title 'OPTICS, Eps=1.25, Eps"=1.15, MinPts=4'
hold off;

% nmi score
optics_nmi = nmi(optics_labels, y);

