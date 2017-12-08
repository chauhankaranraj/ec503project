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

% each column is values of ccrs for each k, when rng seed=col_num
rng_ccrs = zeros(10, 10);

for r = 1:10
    
    rng(r);
    fprintf('random=%i\n', r);
    
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
%         [y_pred, noisy] = DBSCAN(X, 500, 400);

        % evaluate and save metrics
        ccrs(k) = sum(y==y_pred) / num_pts;

        % update best k, ccr, and corresponding predictions
        if ccrs(k) > best_ccr
            best_k = k;
            best_ccr = ccrs(k);
            best_y_pred = y_pred;
        end

    end
    
    rng_ccrs(:, r) = rng_ccrs(:, r) + ccrs;
    
    plot(1:10, ccrs, 'LineWidth', 1.25);
    hold on;

end

hold off;
legend('1', '2', '3', '4', '5', '6', '7', '8', '9', '10');

%% plot
% 1,6,9
for r = 1:10
    figure;
    plot(1:10, rng_ccrs(:,r), 'LineWidth', 1.25);
end
% legend('1', '2', '3', '4', '5', '6', '7', '8', '9', '10');


