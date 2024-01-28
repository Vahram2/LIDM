%**************************************************************************
function [X,b_fitness,nhood]=TG_JPSO_initialization(SwarmSize,max_tree,...
          nnodes,tank_id,Nhood)
%**************************************************************************

%PARTICLE INITIATION
%  |
%  |--> initiation should be random, it base on tree growing algorithm ...
%  generating random tree layout from max_tree 

%**************************************************************************
%A- INITIATION OF X
for i = 1 : SwarmSize
    [X(i,:)] = TreeGrowing (nnodes,max_tree,tank_id);
end
%**************************************************************************

%B- b_fitness INITIATION
b_fitness = ones(1,SwarmSize)*10^9;


% INITIATION OF SOCIAL NEIGHBORHOODS

for i = 1:SwarmSize
    lo = mod(i-Nhood:i+Nhood, SwarmSize);
    nhood(i,:) = lo;
end
nhood(nhood==0) = SwarmSize; %Replace zeros with the index of last particle.