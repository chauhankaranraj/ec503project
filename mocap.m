% load dataset, skip first row of feature titles
X = csvread('../preprocess/processed_mocap.csv', 1, 1);
y = csvread('../preprocess/mocap_labels.csv', 0, 1);

% run in built kmeans
y_pred = kmeans(X, 5);