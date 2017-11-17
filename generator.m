
function[]=generator(Mu,Var,numberofdatapoints,d)
start=1;
finish=0;
C=zeros(d,sum(numberofdatapoints,1));%array initialized for data dimensions and total number of points


for a=1:size(Mu,1)%size of the Mu array will give number of clusters so for each cluster...
    finish=finish+numberofdatapoints(a);
    
    
    for k=start:finish %this algorithm works like horzcat, it adds every cluster points horizontally
        for i=1:d
            
            C(i,k)=normrnd(Mu(a),Var(a)); %gaussan random generation with mu, var
        end
        
    end
    start=start+numberofdatapoints(a);
    
end
    


end

