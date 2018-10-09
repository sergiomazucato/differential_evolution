function [cross croSSx] = cross01(croSS , croSSx , tcromossomo)
    % 
    % Define dois ponto de corte e cruza.
    
    cross = croSS;
    crossx = croSSx;
    
    y = round(rand * (tcromossomo / 6 - 3) + 2);
    
    %//disp('nada');
       
    for j = 1 : 3 * y%(tcromossomo - y * 3)
            
            x = croSS(1 , j);
            %xx = croSSx(1 , j);
            
            cross(1 , j) = croSS(2 , tcromossomo - 3 * y + j);
            %crossx(1, j) = croSSx(2 , j);
            
            cross(2 , tcromossomo - 3 * y + j) = x;
            %crossx(2 , j) = xx;
            %disp(j);

    end %j
    
    for j = 1 : y%round((tcromossomo - y) / 3)
            
            xx = croSSx(1 , j);
            
            crossx(1, j) = croSSx(2 , y + j);%round(y / 3) + j);
            
            crossx(2 , y + j) = xx; %round(y / 3) + j) = xx;
            
    end % i
    
    return;
end