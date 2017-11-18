Mu=[50;60;70];
Var=[1;1;1];
numberofdatapoints=[100;80;90];
d=3;
data = generator(Mu,Var,numberofdatapoints,3);

save('gen_data.mat', 'data');

% scatter3(C(1,1:270),C(2,1:270),C(3,1:270)); 