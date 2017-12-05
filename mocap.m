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


%% CLUSTER

% evaluation metrics for various k
ccrs = zeros(10, 1);

best_k = 0;
best_ccr = 0;
best_y_pred = zeros(num_pts,1);

% cross validate for k
for k = 1:10
    
    fprintf('k=%i\n', k);
    
    % run in-built kmeans
    y_pred = kmeans(X, k);
    
    % evaluate and save metrics
    ccrs(k) = sum(y==y_pred) / num_pts;
    
    % update best k, ccr, and corresponding predictions
    if ccrs(k) > best_ccr
        best_k = k;
        best_ccr = ccrs(k);
        best_y_pred = y_pred;
    end

end

plot(1:10, ccrs);

