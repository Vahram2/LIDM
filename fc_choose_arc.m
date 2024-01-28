function a = fc_choose_arc(AA,T_AA,L_AA,alfa,beta)
%==========================================================================
        %T_AA: pheromone correspondend to AA  
        %L_AA: Length correspondend to AA
        %P: selection probebility in each step of solution constrauction
        %...correspondend to AA
        %(1/L): heurestic value
%==========================================================================
%step1 : calculation of P 
    P1 = (T_AA.^alfa.*(1./L_AA).^beta);
    P =  P1./sum(P1);
    clear P1
%step2 : Selection of a (roulette)
    wheel = cumsum(P);
    r = rand;
    for j = 1:length(wheel)
        if(r < wheel(j))
            id = j;
            break;
        end
    end
    a = AA(id); 
   




