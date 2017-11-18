load fisheriris

load 'gen_data.mat'
X = transpose(data);

% X = meas(:,3:4);
% y = grp2idx(categorical(species));

% % shuffle dataset
% idx = randperm(size(X,1));
% X = X(idx, :);
% y = y(idx,:);

% [order, reach_dists, core_dists] = OPTICSv2(X, 0.5, 5);

[order, reach_dists] = optics(X, 2, 7);

% stem(order, reach_dists(order));
stem(order, reach_dists);
ylabel 'Reachability distance'
xlabel 'Order of points'
title 'OPTICS on Fisher Iris'


% figure;
% 
% for c_num = 1:max(k_preds)
%     scatter3(X(k_preds==c_num,1), X(k_preds==c_num,2), X(k_preds==c_num,3));
%     hold on
% end
% 
% title 'DBSCAN on FisherIris Data';