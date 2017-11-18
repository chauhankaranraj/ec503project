load fisheriris


% cluster1 = normrnd(-5, 1, 100, 1);
% cluster2 = normrnd(5, 1, 100, 1);
% 
% X = [cluster1; cluster2];

X = meas(:,3:4);

[assignments, li_noise] = DBSCAN(X, 0.5, 5);

figure;

for c_num = 1:max(assignments)
    scatter(X(assignments==c_num,1), X(assignments==c_num,2), );
    hold on
end
