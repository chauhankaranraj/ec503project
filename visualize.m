X = csvread('../preprocess/mocap_scaled.csv', 1, 1);

x2 = sne(X);

plot(x2(:,1), x2(:,2));