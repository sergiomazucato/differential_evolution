function [cross croSSx] = cross01(croSS , croSSx , tcromossomo)
    % 
    % Define ponto de corte e cruza.
    
    cross = croSS;
    crossx = croSSx;
    
    y = round(rand * tcromossomo);
    
    while y == 0 
        
        y = round(rand * tcromossomo);
        
    end %while
    
    for j = 1 : y
            
            x = croSS(1 , j);
            %xx = croSSx(1 , j);
            
            cross(1 , j) = croSS(2 , tcromossomo + 1 - j);
            %crossx(1, j) = croSSx(2 , j);
            
            cross(2 , tcromossomo + 1 - j) = x;
            %crossx(2 , j) = xx;

    end %j
    
    for j = 1 : tcromossomo / 3
        
        if y(j) ~= 0
            
            xx = croSSx(1 , j);
            
            crossx(1, j) = croSSx(2 , tcromossomo + 1 - j);
            
            crossx(2 , tcromossomo + 1 - j) = xx;
            
        end %if
    end % i
    
    return;
end