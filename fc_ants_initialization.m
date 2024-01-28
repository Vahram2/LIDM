function [ants,T]=fc_ants_initialization(Options,Pdec,cost_best)
%**************************************************************************
%INITIATION :
%==========================================================================
%read parameters
p_eva = Options.Ants.p_eva;
k = Options.Ants.Tmax_min.k;
Q = Options.Ants.Tmax_min.Q;
max_tree = Options.max_tree;
nnodes = Options.nnodes;
tank_id = Options.tank_id;
n_ants = Options.Ants.n_ants;
beta = Options.Ants.beta;
alfa = Options.Ants.alfa;
%==========================================================================
%pheromone initiation:
    Tmax=Q/(p_eva*cost_best);
    Tmin=(Tmax*(1-Pdec))/(k*Pdec);
    T= ones(1,size(max_tree,2))*Tmin+ rand(1,size(max_tree,2))*(Tmax-Tmin);
    %T = ones(1,size(max_tree,2))* (Tmax+Tmin)/2;
%--------------------------------------------------------------------------
%ants initiation
    for count_x = 1 : n_ants
        [ants(count_x,:)] = fc_ConstructSolutions(nnodes,max_tree(1:3,:),...
        tank_id,T,max_tree(4,:),alfa,beta);
    end
%**************************************************************************