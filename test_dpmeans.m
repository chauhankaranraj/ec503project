load fisheriris

[assignments, k, obj_func] = FacilityMeans(meas, 5);

figure(1)
gscatter(meas(:, 3), meas(:, 4), assignments)


figure(2)
plot(obj_func, 'linewidth', 2)