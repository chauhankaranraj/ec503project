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

a = [1 2 3 4; 5 8 7 1]
[foo, bar] = max(a, [], 2);
foo
bar
% fee