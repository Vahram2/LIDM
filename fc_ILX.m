function [I_L_X,EH,links_Beta,DZ1]=fc_ILX(tree,links_Beta,I_L_X,DZ0,...
    nodelinks,changelinks,EH,J,standard_d)
%**************************************************************************
       %DY contains h loss decrese in changelinks due to diameter decrese.
       %change_EH_id:nodes id in which excess h will change due to headloss
       %...decrese in changelinks
       %change_EH: emount of EH in nodes in which excess h will change  
       %DZ1: min of DZ0, DY and Change_EH,
%**************************************************************************

DY=I_L_X(2,changelinks).*(links_Beta(2,changelinks)-links_Beta(3,...
    changelinks));
%
change_EH_id=~sum(ismember(nodelinks,changelinks));
change_EH_id=0./change_EH_id+1;
change_EH=change_EH_id.*EH(2,(1:end-1));
DZ1=min([DZ0,DY,change_EH]);
%**************************************************************************
%update 

%1)- update is based on X(i)=L(i)*DZ1/DY(i)+X(i), if PipeLength(i)-X(i)=0..
%...then pipe id in I(i) will be changed,else pipe id remains unchanged and
%...L(i)=PipeLength(i)-X(i), L is length of 1th diameter with id eq toI(i),
%Note: Calculation of Beta in all change_links is based on first diameter.
for i=1:length(changelinks)
    I_L_X(3,changelinks(i))=I_L_X(2,changelinks(i)).*DZ1./DY(i)+I_L_X...
        (3,changelinks(i));
    I_L_X(2,changelinks(i))=tree(3,changelinks(i))-I_L_X(3,changelinks(i));
    if I_L_X(2,changelinks(i))==0
        I_L_X(1,changelinks(i))=I_L_X(1,changelinks(i))+1;
        I_L_X(2,changelinks(i))=tree(3,changelinks(i));
        I_L_X(3,changelinks(i))=0;
    end
end
%2)-update EH 
change_EH=change_EH-DZ1;
ans=isnan(change_EH).*EH(2,1:end-1);
change_EH(isnan(change_EH))=0;
EH(2,1:end-1)=ans+change_EH;

%3)-links_Beta
[links_Beta]=fc_links_beta(I_L_X(1,:),J,standard_d,size(tree,2));










    
 