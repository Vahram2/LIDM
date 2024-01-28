%AntsOptions:        
%      |->n_ants : number of ants
%      |->p_eva : pheromone evaporation
%      |->alfa & beta:  are two parameters referred to as pheromone and
%      |...heuristic sensitivity parameter.
%--------------------------------------------------------------------------        
%AntOptions.Tmax_min
%      |->parameters for calculating Tmax &Tmin(max & min pheromone values
%      ....................................................................
%      |->Pdec: is the probability that an ant constructs each component of
%      |...the globalbest solution again
%      |->pbest: the probability that current global-best solution is
%      |...constructed again
%      |->n: is the number of decision points
%      |->k: constant number of options available
  
%==========================================================================
%Parameter definition
%      |->T: pheromone
%      |->1/Lij: heurestic value
%      |->cost_best: min solution cost in perivious generation
%==========================================================================
        max_tree = single(Options.max_tree);
        nnodes = single(Options.nnodes);
        tank_id = single(Options.tank_id);
        Iterations = single(Options.Ants.Iterations);
        n_ants = single(Options.Ants.n_ants);
        alfa = single(Options.Ants.alfa);
        beta = single(Options.Ants.beta);
        Pdec= single(Options.Ants.Tmax_min.pbest^(1/Options.Ants.Tmax_min.n));
        k = single(Options.Ants.Tmax_min.k);
        Q = single(Options.Ants.Tmax_min.Q);
        p_eva = single(Options.Ants.p_eva);
        initial_best_cost = single(1800000);
        overall_best_fitness = single(10000000);
%**************************************************************************
% ants INITIATION

[ants,T]=fc_ants_initialization(Options,Pdec,initial_best_cost);                                                            
% |   |---> initial pheromone set
% |----> matrix contains ants (solutions ) each ant is a set of pipe ids
ants=single(ants); T=single(T);
%**************************************************************************
%%                            THE  MMAS  LOOP                            %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Preallocations:
gbest_fitness=zeros(1,Iterations,'single');
mean_fitness= zeros(1,Iterations,'single');

for count = 1 : Iterations
    %**********************************************************************
    % FITNESS CALCULATION
    fitness=zeros(1,n_ants,'single');
    for count_x = 1: n_ants
        %1-identifying downstream tree of each tank 
        [tank_tree]= fc_tank_tree_creator (ants(count_x,:),max_tree,tank_id);
        %2-pipe size optimization for each tank_tree
        cost=zeros(1,length(tank_id),'single');
        for i= 1: length(tank_id)
            if isempty(tank_tree{i})
                cost(i)=0;
            else
                input=Options.LIDM_input.input;
                input.Z0 = Options.tank_head(i);
                input.tank_id=tank_id(i);
                %deviding tree network into sub tree networks:
                [subtrees,subnodes]=fc_ants_subtreeCreator(Options,...
                    max_tree,tank_tree{i},tank_id(i));
                [cost(i),unused] = fc_main_LIDM2(subtrees,subnodes,input);clear unused
            end
        end
        %3-calculation of particle cost
        fitness(count_x) = sum(cost);
        clear cost
    end
    %**********************************************************************
  
    % PHEROMONE UPDATE
    %   step1 : decide on gbest
              [gbest_fitness(count),gbest_index] = min(fitness);
              gbest= ants(gbest_index,:); 
              
    %   step2 : decide on Tmax and Tmin
              Tmax = Q / (gbest_fitness(count)*p_eva);
              %Tmin = ( Tmax * (1-Pdec) ) / (k*Pdec);
              Tmin = 0.08*Tmax;
    %   step3 : determining links assotiated with gbest(generation best ant)
    %         in max_tree, and update their pheromone.
              T = (1-p_eva) * T; 
              T(gbest) = T(gbest) + (Q/gbest_fitness(count));
    %         control max min T
              for i = 1 : size(max_tree,2)
                  if T(i) >Tmax
                      T(i) = Tmax;
                  elseif T(i) < Tmin
                      T(i) = Tmin;
                  end
              end

    %**********************************************************************
    %DECIDE ON OVERAL BEST SOLUTION FOUND TILL NOW AND MEAN FITNESS OF THIS
    %GENERATION
    if gbest_fitness(count) < overall_best_fitness 
        overall_best = gbest;
        overall_best_fitness = gbest_fitness(count);
    end
    mean_fitness(count)=sum(fitness)/n_ants;
    %**********************************************************************
    %
    % UPDATING ANTS
       for count_x = 1 : n_ants
           [ants(count_x,:)] = fc_ConstructSolutions(nnodes,...
               max_tree(1:3,:),tank_id,T,max_tree(4,:),alfa,beta);
       end
    %**********************************************************************
end
%**************************************************************************
%%                              end                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% overall_best ant features
        %1-identifying downstream tree of each tank 
        [tank_tree]= fc_tank_tree_creator (overall_best,max_tree,tank_id);
        %2-pipe size optimization for each tank_tree
        finalSolution = [];
        for i= 1: length(tank_id)
                input=Options.LIDM_input.input;
                input.Z0 = Options.tank_head(i);
                input.tank_id=tank_id(i);
                %deviding tree network into sub tree networks:
                [subtrees,subnodes]=fc_ants_subtreeCreator(Options,...
                    max_tree,tank_tree{i},tank_id(i));
                [cost(i),ans] = fc_main_LIDM2(subtrees,subnodes,input);
                finalSolution = [finalSolution,ans];
        end
        overall_best_fitness = sum(cost);
%##########################################################################
%PLOT
%subplot(2,1,1); plot(1:1:Iterations,mean_fitness)
%subplot(2,1,2); plot(1:1:Iterations,gbest_fitness)
              
                
                


