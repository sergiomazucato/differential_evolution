function [limits limitsx]= lim(popQ , popQx , npop , maxcontrol , mincontrol , psskmin , psskmax , pssbmin , pssbmax , pssgmin , pssgmax)
    %
    % Descriçao em breve
    % 21/05/2013 Sergio Mazucato
    
%     psskmin = 0;   psskmax = 20; % limitantes pss - K
%     pssbmin = 1;   pssbmax = 8;  % limitantes pss - Beta
%     pssgmin = 4;   pssgmax = 20; % limitantes pss - Gama
%     maxcontrol = 16;
%     mincontrol = 6;
    
    %%
    for i = 1 : npop      
        for j = 1 : maxcontrol
            
            while (popQ(i , 3 * (j - 1) + 1) > psskmax) || (popQ(i , 3 * (j - 1) + 1) < psskmin)
                
                popQ(i , 3 * (j - 1) + 1) = (psskmax - psskmin) * rand;

            end %if
            
            while (popQ(i , 3 * (j - 1) + 2) > pssbmax) || (popQ(i , 3 * (j - 1) + 2) < pssbmin)
                
                popQ(i , 3 * (j - 1) + 2) = (pssbmax - pssbmin) * rand + pssbmin;

            end %if
            
            while (popQ(i , 3 * (j - 1) + 3) > pssgmax) || (popQ(i , 3 * (j - 1) + 3) < pssgmin)
                
                popQ(i , 3 * (j - 1) + 3) = (pssgmax - pssgmin) * rand + pssgmin;

            end %if
        
        end %j
        %%
        while sum(popQx(i , :)) < 6
            
            for j = 1 : maxcontrol
                if rand > 0.45
                    popQx(i , j) = 1;
                else
                    popQx(i , j) = 0;
                end
            end
        end
    end %i
    %%
    
    limits  = popQ;
    limitsx = popQx;
    
    return;    
end