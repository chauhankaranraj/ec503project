load fisheriris

X = meas(:,3:4);

% cluster1 = normrnd(-5, 1, 100, 1);
% cluster2 = normrnd(5, 1, 100, 1);

% X = [cluster1; cluster2];

[assignments, li_noise] = DBSCAN(X, 0.1, 5);

