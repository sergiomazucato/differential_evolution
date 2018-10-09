function [cross croSSx] = cross00(croSS , croSSx , tcromossomo)
    % 
    % Define ponto de corte e cruza.
    
    cross = croSS;
    crossx = croSSx;
    
    %//y = round(rand * (tcromossomo - 3) + 2);
    
    y = round(rand * (tcromossomo / 6 - 3) + 2);
    
    for j = 1 : 3 * y
            
            x = croSS(1 , j);
            %xx = croSSx(1 , j);
            
            cross(1 , j) = croSS(2 , 3 * y + j);
            %crossx(1, j) = croSSx(2 , j);
            
            cross(2 , 3 * y + j) = x;
            %crossx(2 , j) = xx;

    end %j
    
    for j = 1 : y % round((tcromossomo - y) / 3)
            
            xx = croSSx(1 , j);
            
            crossx(1, j) = croSSx(2 , y + j);%round(y / 3) + j);
            
            crossx(2 , y + j) = xx ;%round(y / 3) + j) = xx;
            
    end % i
    
    return;
end