function [I_L_X]=LIDMnetwork(input)
%**************************************************************************
%Initiation:
%initial inputs are:
         %Z0: available upstream head(1 cell)
         %nlinks & nnodes: number of nodes and links(1 cell)
         %vmin_max: min and max water velocity (2 cell vector)
         %c_heyzen: headloss cofficent(1 cell) 
         %standard_d: 1th row is standard diameters(mm)and 2th unit price.
         %node: 1th row contains node_id's, 2th row nodes elevatons, 3th...
         %...min allowable head(m), 4th demand(cms)
         %tree: 1th is pipe's start node, 2th is pipe's end node, 3th is...
         %...pipe lenght(m), 4th is a number eq to 2th+1th*10
         %tank_id:(1 cell)
%initial calculations:
         %qlink :discharge in each link(cms)
         %nodelinks : matrix difines upstream links of each node
         %endnode: contains endnodes of tree network 
         %v_pipe :pipe velocity m/s--rows indicate available diameters,...
         %...columns indicate links ids.
         %J :J=10.7/(c^1.852*D^4.87)*Q^1.852 haizen willams,--rows indicate
         %...available diameters,columns indicate links ids. 
%**************************************************************************
%input=LIDMinput;
Z0=single(input.Z0);
nlinks=single(input.nlinks);
vmin_max=single(input.vmin_max);
c_heyzen=single(input.c_heyzen);
standard_d=single(input.standard_d);standard_d(1,:)=standard_d(1,:)./1000;
node=single(input.node);nnodes=single(input.nnodes);
tree=single(input.tree);tank_id=single(input.tank_id);

%fc calculates flow in each link(cms)
[qlink,nodelinks,endnode]=fc(node,nnodes,tree,tank_id,node(4,:));
nodelinks=single(nodelinks);
v_pipe=(1./(pi.*standard_d(1,:)'.^2./4))*(qlink);%
J=10.7./(c_heyzen^1.852.*standard_d(1,:)'.^4.87)*qlink.^1.852;%
%% 
%**************************************************************************
%Stage1:
         %links_Beta: 1th row is 1th diameters, 2th row is 1th J,3th row...
         %...is is 2th J,4th row is 1th P(unit cost),5th row is 2th P,6th
         %...row is Beta,
         %I: is curent(1th)diameter id in standard_d
         %hf: of each node identifes upstream head loss
%**************************************************************************
%choosing the smalest posible pipe sizes for each link(initial state,i=0)   
 %A-note:here the smallest acceptable diameter is set as initiall diameter. 
    I=single(sum(heaviside(v_pipe-vmin_max(2)))+1);
    [links_Beta]=fc_links_beta(I,J,standard_d,nlinks);
    clear v_pipe vmin_max qlink c_heyzen
 %B- calculation of hf for each node.  
    hf=zeros(1,nnodes-1,'single');
    for j=1:nnodes-1
        for i=1:size(nodelinks)
            if nodelinks(i,j)==0;break;end
           hf(j)=hf(j)+tree(3,nodelinks(i,j))*links_Beta(2,nodelinks(i,j));
        end
    end
    hf=[hf,0];

%%
%**************************************************************************
%Stage2:
%in each iteration inputs are:
         %EH(excess head):1th row is upstream head of j'th node Z0j, 2th...
         %...row is excess head
         %Z0itr(min upstream head requirment for each node)
         %DZ0=Z0itr-Z0
         %I_L_X: 1th row is I(diameter id in standard_d), 2th is L(pipe... 
         %...length labeled with first D, 3th is pipe length labeled with
         %...next diameter.                 
%**************************************************************************

EH(1,:)=node(3,:)+node(2,:)+hf;%EH(1,:),Z0(j)=hmin(j)+ZT(j)+hf(j)
Z0itr=max(EH(1,:));%initial upstream head
DZ0=Z0itr-Z0;%initial head differences between itreation upstream head and
%...available upstream head.   
EH(2,:)=Z0itr-EH(1,:);%initial excess head
I_L_X=[I;tree(3,:);zeros(1,size(tree,2),'single')];%initial I_L_X 
clear hf input
%**************************************************************************
for i=1:500
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %identifying changelinks in each itr
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %identifying critical_nodes:
    %Note: critical_nodes are nodes their EH=0,this nodes's downstream...
    %...links can not be a changelink.
    critical_nodes = node(1,EH(2,:)==0);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [endnode1,stop,tree3]=fc_endnode1(endnode,tree,links_Beta,tank_id,...
        critical_nodes);
    while size(stop,2)~=1   
    endnode1=fc_endnode2(endnode1,stop);
    [endnode1,stop,tree3]=fc_endnode3(endnode1,tree,tree3,tank_id,...
    links_Beta,critical_nodes);
       n=0;
       for ii=1:size(endnode1,1)
            if sum(endnode1(ii,:))~=0
            n=n+1;
            a(n,:)=endnode1(ii,:);
            end
       end
       endnode1=a;
       clear a
    end
    [ans,ans,changelinks]=find(endnode1(3:end,1));
    changelinks=changelinks';
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [I_L_X,EH,links_Beta,DZ1]=fc_ILX(tree,links_Beta,I_L_X,DZ0,nodelinks,...
        changelinks,EH,J,standard_d);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %update DZ0(differences between upstream itr head(Z0itr) and upstream..
    %...available head(Z0))
    Z0itr=Z0itr-DZ1;
    DZ0=Z0itr-Z0;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if DZ0==0;break;end
end
%**************************************************************************
% the final answer is I_L_X matrix, 