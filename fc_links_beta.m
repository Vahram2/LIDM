%here we define matrix links_Beta, which contains parameters of i'th iteratin for links
    %1)Diameter 2)Js 3)Js+1 4)Ps 5)Ps+1 6)beta
function [links_Beta]=fc_links_beta(I,J,standard_d,nlinks)    
    links_Beta(1,:)=standard_d(1,I);
    for i=1:nlinks;links_Beta(2,i)=J(I(i),i);end;%Js         
    for i=1:nlinks;links_Beta(3,i)=J(I(i)+1,i);end;%Js+1     
    links_Beta(4,:)=standard_d(2,I);%Ps                      
    links_Beta(5,:)=standard_d(2,I+1);%Ps+1                  
    links_Beta(6,:)=(links_Beta(5,:)-links_Beta(4,:))./(links_Beta(2,:)-links_Beta(3,:)+.00001);%beta
    