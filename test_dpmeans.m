load fisheriris

[assignments, k] = DPMeans(meas, 2.5);

gscatter(meas(:, 3), meas(:, 4), assignments)