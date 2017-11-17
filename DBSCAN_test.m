load fisheriris

X = meas(:,3:4);

% keep only unique data points
[foo, bar] = unique(X(:,1));
[fee, bur] = unique(X(:,2));

all_idx = union(bar, bur);
X = X(all_idx, :);

% cluster1 = normrnd(-5, 1, 100, 1);
% cluster2 = normrnd(5, 1, 100, 1);

% X = [cluster1; cluster2];

% for i = 1:10

[assignments, li_noise] = DBSCAN(X, 0, 3);

figure;

for cluster_num = 0:max(assignments)
    
    scatter(X(assignments==cluster_num,1), X(assignments==cluster_num,2), 'markerfacecolor', rand(1,3));
    hold on
    
end

% plot(X(assignments==1,1), X(assignments==1,2), 'r.', 'MarkerSize', 15);
% hold on
% 
% plot(X(assignments==2,1), X(assignments==2,2), 'g.', 'MarkerSize', 15);
% hold on
% 
% plot(X(assignments==0,1), X(assignments==0,2), 'b.', 'MarkerSize', 15);

title 'DBSCAN on Fishers Iris Data';

% end
