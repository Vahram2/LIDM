function [qlink,nodelinks,endnode]=fc(node,nnodes,tree,tank_id,q)
tree2=tree(1:2,:);
%identidication of endnodes
j=1;
for k=1:nnodes ;
    i=node(1,k);[r,c]=find(abs(tree(1:2,:)-i)<1);
        if (sum(heaviside(c))==1 && i~=tank_id);
            endnode(j)=i;
            j=j+1;
        end
end
%clculation of discharge in each pipe line
for j=1:nnodes
    index=[];
 for k=1:nnodes 
        i=node(1,k);
        [r,c]=find(abs(tree(1:2,:)-i)<1);
        if (sum(heaviside(c))==1 && i~=tank_id);
           qlink(c)=q(node(1,:)==i);
           index=[index,c];
            if r==1;
             q(node(1,:)==tree(2,c))=q(node(1,:)==tree(2,c))+q(node(1,:)==i);else
             q(node(1,:)==tree(1,c))=q(node(1,:)==tree(1,c))+q(node(1,:)==i);
            end
        end        
end
    tree(1:2,index)=0;
    if sum(tree(1,:))==0;break;end
end   
% creation of nodelinks matrix: in nodelinks one can find links than connect any
% specifed node to tank
[r,c]=find(tree2==tank_id);
    r=1./(r./2);
    for i=1:size(r);ans=tree2(r(i),c(i));nodelinks(1,(node(1,:)==ans))=c(i);end 
    tree2(:,c)=0;
for j=2:nnodes;
    ind=find(nodelinks(j-1,:));
    for i=1:size(ind,2)
        [r,c]=find(tree2==node(1,ind(i)));r=1./(r./2);
        if sum(c)==0;continue;end
        for n=1:size(r);ans=tree2(r(n),c(n));nodelinks(j,(node(1,:)==ans))=c(n);end ;
        for n=1:size(r);ans=tree2(r(n),c(n));nodelinks(1:j-1,(node(1,:)==ans))=nodelinks(1:j-1,ind(i));end
        tree2(:,c)=0;
    end
    if sum(sum(tree2))==0;break;end
end

