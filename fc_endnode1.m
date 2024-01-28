function [endnode,stop,tree3]=fc_endnode1(endnode,tree,links_Beta,...
    tank_id,critical_nodes)
%**************************************************************************
%1th step of changelinks identification:
%input:
     %endnode: (1*nnodes)contains network's endnodes
     %tree: (as main program)
     %links_Beta: (as main program) 
     %tank_id: (as main program)
     %critical_nodes: critical_nodes are nodes their EH=0,this nodes's...
     %...downstreaml inks can not be a changelink.
%output:
     %endnode: is a matrix
     %stop: (1*size(endnode))diffines nodes in which the prossedure stops,.
     %...they are nodes with more than 1branch.
     %tree3: (2*nlinks)non zero columns shows not met links
%**************************************************************************
%initiation:
     tree2=tree(1:2,:);
     %creation of tree3
     tree3=tree2;
     ans=(~sum(ismember(tree3,endnode(1,:))));
     tree3=[ans;ans].*tree3;
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%for each endnode(i) this function goes upstream(node by node) and in each
%...step identifies Beta(will be saved in endnode(2,i))and detemine...
%...changelinks(will be saved in endnode(3,i))
for i=1:length(endnode)
      node_id=endnode(1,i);
      [r,link_id]=find(abs(tree2-node_id)<1);
      row_id=1./(r./2);
      if  ismember(node_id,critical_nodes) 
          endnode(2,i)=links_Beta(6,link_id);
          endnode(3,i)=link_id;
      else
        endnode(2,i)=0;
      end
      %********************************************************************
      %note:beta and changelink(2th and 3th row of endnode)is defined for.. 
      %first step,now it's necessery to check if the other node of link is
      %critical or not. if it's critical non of the links down stream of it
      %can be changelink an also beta of down stream is set eq to 10^5...
      %(too big)for giving upsream links chance to be choosen as changelink
      %********************************************************************
      %the other node of link is critical or not?
      nextnode=tree2(row_id,link_id);
      if ismember(nextnode,critical_nodes)
          endnode(2,i)=10^7;%why?becuse endnode(2,i)=0,indicates that EH
          %...of start node of this route(column of endnode)is neq to 0,and
          %...the procedure have to count it as change_EH node in each itr
          %WHY 10^7?
          endnode(3:end,i)=0;
      end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
      for m=1:100
        [r,c]=find(ismember(tree2,nextnode));
        if (length(c)>2 || nextnode==tank_id);break;end
            node_id=nextnode;
            [r,c]=find(ismember(tree3,nextnode));
            row_id=1./(r./2);
            link_id=c;
            tree3(:,link_id)=[0;0];
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if endnode(2,i)~=0 && links_Beta(6,link_id)<endnode(2,i)   
                endnode(3,i)=link_id;
                endnode(2,i)=min(endnode(2,i),links_Beta(6,link_id));
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %the other node of link is critical or not?
            nextnode=tree2(row_id,link_id);
            if ismember(nextnode,critical_nodes)
                endnode(2,i)=10^7;%why?..
                endnode(3:end,i)=0;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    stop(i)=nextnode;
end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~