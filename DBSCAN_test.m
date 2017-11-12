cluster1 = normrnd(-5, 1, 100, 1);
cluster2 = normrnd(5, 1, 100, 1);

X = [cluster1; cluster2];

[assignments, li_noise] = DBSCAN(X, 2, 5);

