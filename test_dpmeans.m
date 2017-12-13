load fisheriris

[dp_assignments, dp_k, dp_obj_func, dp_centroids] = DPMeans(meas, 6);

[f_assignments, f_k, f_obj_func, f_centroids] = FacilityMeans(meas, 12);

figure(1)
gscatter(meas(:, 3), meas(:, 4), f_assignments)
