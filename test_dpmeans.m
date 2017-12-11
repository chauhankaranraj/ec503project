load fisheriris

[assignments, k, wcss] = DPMeans(meas, 2.5);

gscatter(meas(:, 3), meas(:, 4), assignments)

plot(1:numel(wcss), wcss);
title 'Objective Function vs Number of  Iterations';
