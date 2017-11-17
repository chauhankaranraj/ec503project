load fisheriris

X = meas(:,3:4);

[foo, bar] = unique(X(:,1));
[fee, bur] = unique(X(:,2));

all_idx = union(bar, bur);
X = X(all_idx, :);