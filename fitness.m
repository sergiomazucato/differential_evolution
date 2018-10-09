function [pop popx mdamp] = fitness(popP , popPx , tcromossomo , npop)
    %
    % Descriçao em breve
    % 20/05/2013 (Sergio Mazucato)

    for i = 1 : npop
        
            mdampt(i , 1 : 2) = v_damp(popP(i , :) , popPx(i , :) , tcromossomo);
            mdampt(i , 6) = i;
            
    end %i
    
    [x y] = sort(mdampt(: , 1) , 'descend');


    for i = 1 : npop
        
        pop(i , :)    = popP(y(i) , :);
        popx(i , :)   = popPx(y(i) , :);
        mdamp(i , :)  = mdampt(y(i) , :);
        
    end %i
    
    return;
    
end %i