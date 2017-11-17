% 
% a = rand(3, 6);
% a
% 
% foo = min(a);
% [~, bar] = max(min(a));
% 
% 
% foo
% bar

priorities = [ -1 -1 -1 2 3 2 0 2 10 5 -1];
priorities

[priorities, pr_pt_idx] = sort(priorities, 'descend');

priorities
pr_pt_idx