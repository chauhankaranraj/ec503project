%% LOAD

% load dataset, skip first row of feature titles
X = csvread('../preprocess/processed_mocap.csv', 1, 1);
y = csvread('../preprocess/mocap_labels.csv', 0, 1);

% sort in increasing order of labels
[y, sort_idx] = sort(y);
X = X(sort_idx, :);

% dataset shape
num_pts = numel(y);
num_feats = size(X, 2);

[y_pred, noisy] = DBSCAN(X, 250, 500);