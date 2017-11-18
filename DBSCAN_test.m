load fisheriris


% cluster1 = normrnd(-5, 1, 100, 1);
% cluster2 = normrnd(5, 1, 100, 1);
% 
% X = [cluster1; cluster2];

X = transpose(data);

[assignments, li_noise] = DBSCAN(X, 1, 5);

figure;

for c_num = 0:max(assignments)
    scatter3(X(assignments==c_num,1), X(assignments==c_num,2), X(assignments==c_num,3), 'filled');
    hold on
end

legend('Noise', 'Cluster1', 'Cluster2', 'Cluster3', 'Cluster4', 'Cluster5', 'Cluster6', 'Cluster7', 'Cluster8', 'Cluster9');

title 'DBSCAN on generated synthetic data'
