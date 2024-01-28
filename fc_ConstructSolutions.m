
%**************************************************************************
function [A] = fc_ConstructSolutions (nnodes,tree,Nr,T,L,alfa,beta)
%fc_ConstructSolutions  generates a tree on basis of base graph
%==========================================================================
        %T : pheromone      
        %L : length of each link (link = solution component)
        %alfa and beta: are two parameters referred to as pheromone and
        %...heuristic sensitivity parameter.
        %------------------------------------------------------------------
        %nnodes : Total number of nodes
        %tree : base graph_1st row: link_id, 2 & 3 row: start & end points 
        %Nr : Roots id, Nr = tank_id
        %A : random tree,
%==========================================================================
%1- INITIATION
    %Identify the root nodes
    C = Nr;
    A = [];
    % Initialize AA = [arcs in base gragh connected to root node]
    AA = tree( 1 , sum(ismember(tree(2:3,:),Nr))==1 );
for j = 1 : nnodes-length(Nr);
%**************************************************************************
%2- Choose arc, a, at random from AA and set A = A + [a]
    a = fc_choose_arc (AA,T(AA),L(AA),alfa,beta);
    A = [ A , a];
%3- Identify newly connected node, N, and set C = C + [N]
    a_nodes = tree (2:3,(tree (1,:)==a));
    N = tree( [0;~ismember(a_nodes ,C)]==1,(tree (1,:)==a) );
    C = [C , N];
%4- Identify arcs, ac(i), connected to N in base graph,(excluding arc a)
    ac = tree( 1 , sum(ismember(tree(2:3,:),N))==1 );
    ac = setdiff(ac,a);
%5- Update AA, by removing arc a and any newly infeasible arcs, and adding
%...any of arcs ac(i) that are feasible candidates. AA now contains all
%...feasible choices for the next arc of the tree
    %5-1- AA = AA - a (remove newly connected arc from list)
    AA = setdiff (AA , a);
    %5-2- 
    for i = 1 : length(ac)
        %is ac(i) in AA already?
        if ismember(ac(i),AA)
            AA = setdiff (AA , ac(i));
        else
            %are both ends of ac(i) in C?
            aci_nodes = tree (2:3,(tree (1,:)==ac(i)));
            if sum(ismember(aci_nodes,C))==2
                %leave list unultered as adding ac(i) would cuse a loop...
                %...in tree
            else
                AA = [ AA , ac(i) ];
            end         
        end
    end
%**************************************************************************
end
    
    
