function [endnode1,stop,tree3]=fc_endnode3(endnode1,tree,tree3,tank_id,...
    links_Beta,critical_nodes)
%**************************************************************************
%input:
      %endnode1:
      %tree
      %tree3
      %tank_id
      %links_Beta
%output:
      %endnode1
      %stop
      %tree3
%**************************************************************************
tree2=tree(1:2,:);
tree3_old=tree3;
for i=1:size(endnode1,2) 
[r,c]=find(endnode1(1,i)==tree3_old);
     if length(c)<2 && endnode1(1,i)~=tank_id
         node_id=endnode1(1,i);
         [r,link_id]=find(tree3==node_id);
         row_id=1./(r./2);
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         c=link_id;
         [rr,cc]=find(tree3_old==node_id);
         tree3(:,link_id)=[0;0];
         while length(c)<2 && length(cc)<3&& node_id~=tank_id &&...
               (~ismember(node_id,endnode1(1,:)) || node_id==endnode1(1,i))
             link_id=c;
             tree3(:,link_id)=[0;0];
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             if links_Beta(6,link_id)<endnode1(2,i)
                 ans=size(endnode1,1);
                 endnode1(3:ans,i)=0;
                 endnode1(ans+1,i)=link_id;
             end
             endnode1(2,i)=min(endnode1(2,i),links_Beta(6,link_id));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %the other node of link is critical or not?            
             nextnode=tree2(row_id,link_id);
             if ismember(nextnode,critical_nodes)
                endnode(2,i)=10^7;%why?..
                endnode(3:end,i)=0;
             end
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             node_id=nextnode;
             [r,c]=find(tree3==node_id);
             row_id=1./(r./2);
             [rr,cc]=find(tree3_old==node_id);
         end         
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         stop(i)=node_id; 
     else
         stop(i)=0;
     end
end

 
     
 
     
     
     
 
 
 
 
 
 
 
 
 
 
 