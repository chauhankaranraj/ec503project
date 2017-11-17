load fisheriris

X = meas(:,3:4);

[order, reach_dists, core_dists] = OPTICSv2(X, 0.5, 5);

figure;
% 
% for c_num = 1:max(k_preds)
%     scatter3(X(k_preds==c_num,1), X(k_preds==c_num,2), X(k_preds==c_num,3));
%     hold on
% end
% 
% title 'DBSCAN on FisherIris Data';