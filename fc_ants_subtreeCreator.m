%**************************************************************************
% fc_ants_subtreeCreator divides 
%**************************************************************************
function [subtrees,subnodes]=fc_ants_subtreeCreator(Options,max_tree,tank_tree,root_id)

%--------------------------------------------------------------------------
tree_X =  max_tree(:,(ismember(max_tree(1,:),tank_tree)));
tree2 = tree_X(2:3,:);
[r,c] = find (tree2 == root_id);
r=1./(r./2);
for i=1:length(r)
    node1(i) = tree2 (r(i),c(i));
    link1(i) = tree_X (1,c(i)) ;
end

tree_X =  tree_X (:,(~ismember(tree_X(1,:),link1)));
tree2=tree_X(2:3,:);
for n = 1 : length(node1)
    [r,c]=find(tree2 == node1(n) );
    r=1./(r./2);
   subtrees{n}=[];
   nextnode=[];
    for i=1:size(r)
        nextnode(i)=tree2(r(i),c(i));
        ans = tree_X (1,c(i));
       subtrees{n}=[subtrees{n},ans];
        tree2 (:,c(i))=0;
    end
    while ~isempty(nextnode)
        nextnode2 = [];
        for j = 1 : size(nextnode,2)
            [r,c] = find ( tree2 == nextnode(j) );
            r = 1./(r./2);
            for i = 1 : size(r)
                nextnode2 = [ nextnode2 , tree2(r(i),c(i)) ];
                ans = tree_X (1,c(i));
                subtrees{n} = [subtrees{n},ans];
                tree2(:,c(i)) = 0;
            end
        end
        nextnode = nextnode2;
    end
end
%--------------------------------------------------------------------------
for n = 1 : length(node1)
    subtrees{n}=[subtrees{n},link1(n)];
    subtrees{n} =  max_tree( 2:end, (ismember(max_tree(1,:),subtrees{n})));
    subnodes{n} = unique(subtrees{n}(1:2,:))';
    subnodes{n} = Options.node(:,(ismember(Options.node(1,:),subnodes{n})) );
end
