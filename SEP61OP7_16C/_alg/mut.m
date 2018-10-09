function mutation = mut(x , tcromossomo , maxcontrol , mincontrol , psskmin , psskmax , pssbmin , pssbmax , pssgmin , pssgmax)
    %
    %
    
    %%
    y = round((tcromossomo - 1) * rand) + 1;
    
    if mod(y , 3) == 1
        
        x(y) = (psskmax - psskmin) * rand;
         
    elseif mod(y , 3) == 2
        
        x(y) = (pssbmax - pssbmin) * rand + pssbmin;
        
    elseif mod(y , 3) == 0
        
        x(y) = (pssgmax - pssgmin) * rand + pssgmin;
         
    end %if

    mutation = x;
    
    return;    
end