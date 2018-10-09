function winner = tnt(npop , mdamp)
    % 
    % torneio de multidao
    
    x = round((npop - 1) * rand(1 , 3)) + 1; % escolhe tres pais        
    x = sort(x);
    
    winner = x(1);
    
    if mdamp(x(1) , 3) < mdamp(x(2) , 3) && mdamp(x(1) , 3) < mdamp(x(3) , 3)
        
        winner = x(1);
        
    elseif mdamp(x(2) , 3) < mdamp(x(1) , 3) && mdamp(x(2) , 3) < mdamp(x(3) , 3)
        
        winner = x(2);
        
    elseif mdamp(x(3) , 3) < mdamp(x(1) , 3) && mdamp(x(3) , 3) < mdamp(x(2) , 3)
        
        winner = x(3);
        
    end % if
    
    if winner == x(1)
        
        if mdamp(x(1) , 3) <= mdamp(x(2) , 3) && mdamp(x(1) , 3) <= mdamp(x(3) , 3)
            if mdamp(x(1) , 4) >= mdamp(x(2) , 4) && mdamp(x(1) , 4) >= mdamp(x(3) , 4)
                
                winner = x(1);
   
            end %if 3
        end %if
            
        if mdamp(x(2) , 3) <= mdamp(x(1) , 3) && mdamp(x(2) , 3) <= mdamp(x(3) , 3)
            if mdamp(x(2) , 4) > mdamp(x(1) , 4) && mdamp(x(2) , 4) >= mdamp(x(3) , 4)
                
                winner = x(2);
                
            end %if
        end %if
        
        if mdamp(x(3) , 3) <= mdamp(x(1) , 3) && mdamp(x(3) , 3) <= mdamp(x(2) , 3)
            if mdamp(x(3) , 4) > mdamp(x(1) , 4) && mdamp(x(3) , 4) > mdamp(x(2) , 4)
                
                winner = x(3);
                
            end %if
        end %if
        
    else  winner = x(1);
        
    end %if 1
    
    
end