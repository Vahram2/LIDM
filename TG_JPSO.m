function [overall_best,overall_best_fitness,finalSolution,gx_fitness,mean_fitness]= TG_JPSO (Options)
%**************************************************************************
% READING INPUT PARAMETERS:

        % max_tree : identifies the input max layout: 1st row: links id,...
        %... 2nd row: start node id, 3rd row: end node id
        % nnodes:
        % tank_id:
        % Iterations : max number of iterations 
        % SwarmSize : number of particles
        % Nhood : Neighborhood size_nhood=1 ==>2 neighbors,one on each side
        % c : vector contains JPSO's update cofficents,[c1,c2,c3,c4]
        % DC1 : %total c(1)change during iterations, first randomness is...
        %...high due to high c1 valu but during iterations linearly c1...
        %...decreses and on the other hand c2,c3 & c4 increse linearly,...
        %...this assures good global search at first iterations and good...
        %...local search at last iterations.

max_tree = single(Options.JPSO_input.max_tree);
nnodes = single(Options.JPSO_input.nnodes);
tank_id = single(Options.JPSO_input.tank_id);
Iterations = single(Options.JPSO_input.Iterations);
SwarmSize = single(Options.JPSO_input.SwarmSize) ;
c = single(Options.JPSO_input.c);
Nhood= single(Options.JPSO_input.Nhood);
DC1= single(Options.JPSO_input.DC1);
%**************************************************************************
% PARTICLE INITIATION

[X,b_fitness,nhood]=TG_JPSO_initialization(SwarmSize,max_tree,nnodes,tank_id,Nhood);
%|    |        |
%|    |        |---> matrix difines social Neighbors of each particle 
%|    |---> matrix contains fitness of b 
%|----> matrix contains particle positions
X=single(X);b_fitness=single(b_fitness);nhood=single(nhood);
overall_best_fitness = single(10^9);
%**************************************************************************
%%                           THE  TG_JPSO  LOOP                          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for count = 1 : Iterations
    
    %**********************************************************************
    % FITNESS CALCULATION
    current_fitness = zeros(1,SwarmSize,'single');
    for count_x = 1:SwarmSize
        %1-identifying downstream tree of each tank 
        [tank_tree]= fc_tank_tree_creator (X(count_x,:),max_tree,tank_id);
        %2-pipe size optimization for each tank_tree
        cost = zeros(1,length(tank_id),'single');
        
        for i= 1: length(tank_id)
            if isempty(tank_tree{i})
                cost(i)=0;
            else
                input=Options.LIDM_input.input;
                input.Z0 = Options.JPSO_input.tank_head(i);
                input.tank_id=tank_id(i);
                %deviding tree network into sub tree networks:
                [subtrees,subnodes]=fc_subtreeCreator(Options,max_tree,tank_tree{i},tank_id(i));
                [cost(i),unused] = fc_main_LIDM2(subtrees,subnodes,input);
                clear unused
            end
        end
        %3-calculation of particle cost
        current_fitness(count_x) = single(sum(cost));
    end
    %**********************************************************************
    % DECIDE ON "b" , "g" , "gx" and "overall_best"
    %            |     |       |        |-> best particle have been met yet
    %            |     |       |-->the global best among all the particles
    %            |     |---> best emong each particles neighborhood   
    %            |---> best position for each particle 
    
    %A: Updating "b"
    changeRows = current_fitness < b_fitness;
    b_fitness(changeRows) = current_fitness (changeRows);
    b(changeRows, :) = X(changeRows, :);
                
    %B: decide on "g" |-->(circular neighborhood is used)
    for count_x = 1 : SwarmSize
        [g_fitness(count_x),nb] = ...
                                min( current_fitness( nhood(count_x,:) ) );
        g(count_x, :) = X(nhood(count_x,nb), :);
    end
        
    %C: decide on gx 
    [gx_fitness(count),gx_index] = min(current_fitness);
    gx = X(gx_index,:);      
   
    %D: decide on overall_best
    if gx_fitness(count) < overall_best_fitness 
        overall_best = gx;
        overall_best_fitness=gx_fitness(count);
    end
    %**********************************************************************
    %UPDATEING
    %update c1,c2,c3 and c4
    ic(1)=c(1)-DC1*count/Iterations; dc=(c(1)-ic(1))/3;
    ic(2)=c(2)+dc; ic(3)=c(3)+dc;ic(4)=c(4)+dc;
    for count_x = 1 : SwarmSize
        %------------------------------------------------------------------
        % SELECT AN ATTRACTOR    
        AR = rand; %random number between 0 and 1(AR --> Attractor Random)
        if AR < ic(1)
            Attractor = X(count_x,:) ; id = 1;
        elseif ic(1) < AR <= ic(1)+ic(2)
            Attractor = b(count_x,:) ; id = 2; 
        elseif ic(1)+ic(2) < AR <= ic(1)+ic(2)+ic(3)
            Attractor = g(count_x,:); id = 3;     
        else Attractor = gx ; id = 4;  
        end
        %------------------------------------------------------------------
        % COMBINE PARTICLE count_x AND Attractor:
        %              |--->X(count_x,:) = Combine(X(count_x,:),Attractor);        
        % CR(Change Random)identifies jumps randomly with probobility=c(id)
        
        if id==1
        %------------------------------------------------------------------
        %random jump
        ans1=setdiff(max_tree(1,:),X(count_x,:));
        ans1 = round(rand(1,length(ans1))).*ans1;
        combination = setdiff( union( X(count_x,:),ans1) , 0);
        else
        %------------------------------------------------------------------
        %jump toward Attractor
        combination = union(X(count_x,:),Attractor);
        %------------------------------------------------------------------
        end
        combination_tree = max_tree(:,(ismember(max_tree(1,:),combination)));
        [X(count_x,:)] = TreeGrowing (nnodes,combination_tree,tank_id);
               
   end
   %***********************************************************************
     mean_fitness(count)=sum(current_fitness)/SwarmSize;
end
%**************************************************************************
%%                              end                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% overall_best particle features
        %1-identifying downstream tree of each tank 
        [tank_tree]= fc_tank_tree_creator (overall_best,max_tree,tank_id);
        %2-pipe size optimization for each tank_tree
        finalSolution = [];
        for i= 1: length(tank_id)
                input=Options.LIDM_input.input;
                input.Z0 = Options.JPSO_input.tank_head(i);
                input.tank_id=tank_id(i);
                %deviding tree network into sub tree networks:
                [subtrees,subnodes]=fc_subtreeCreator(Options,max_tree...
                                                 ,tank_tree{i},tank_id(i));
                [cost(i),ans] = fc_main_LIDM2(subtrees,subnodes,input);
                finalSolution = [finalSolution,ans];
        end
        overall_best_fitness = sum(cost);
%##########################################################################
%PLOT
%subplot(2,1,1); plot(1:1:Iterations,mean_fitness)
%subplot(2,1,2); plot(1:1:Iterations,gx_fitness)

   