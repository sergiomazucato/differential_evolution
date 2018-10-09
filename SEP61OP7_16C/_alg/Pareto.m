function F = Pareto(mdamp , npop)
    % Sintaxe :
    % pareto(mdamp , npop)= F
    % onde 'mdamp' representa uma matriz com os amortecimentos e com o  nú-
    % mero de controladores de cada cromossomo e 'npop' representa uma  va-
    % riável com o tamanho da populacão.
    % Por Sérgio Mazucato


    %% inicia ordenacão por não dominância
    
    nd = zeros(1 , npop); % define variáveis de contagem do laco
    U = zeros(npop , npop);
    F = zeros(1 , npop + 1);
    fk = 1; % define contador de individuos da primeira fronteira
    
    for i = 1 : npop
        
        nd(i) = 0;
        U(i , :) = 0;
        
        uk = 1; % contador para fazer Ui U j

        for j = 1 : npop
            if j ~= i
                
                % aqui eu vejo quem a solucao i domina
                if mdamp(i , 1) >= mdamp(j , 1) && mdamp(i , 2) < mdamp(j , 2) || ...
                        mdamp(i , 1) > mdamp(j , 1) && mdamp(i , 2) <= mdamp(j , 2)
                                       
                    U(i , uk) = j;
                    uk = uk + 1;
                   
                end %if i domina j
                
                % aqui eu vejo quem domina a solucao i
                if mdamp(i , 1) <= mdamp(j , 1) && mdamp(i , 2) > mdamp(j , 2) || ...
                        mdamp(i , 1) < mdamp(j , 1) && mdamp(i , 2) >= mdamp(j , 2)
                    
                    nd(i) = nd(i) + 1;
                    
                end %if j domina i
            end %if j não igual i           
        end %j
        
        % aqui eu verifico se ninguem domina a solucao i
        % se ninguem domina i, entao ela vai para a primeira fronteira
        if nd(i) == 0
            
            F(1 , fk) = i;
            fk = fk + 1;
            
        end %if
    end %i
    
    %% separa indivíduos por fronteiras
    
    k = 1; % define contador de fronteiras
    
    while sum(F(k , :)) ~= 0

        temp = zeros(1 , npop + 1); % define fronteira temporária
%         fk = 1;                   % reinicia contador de indivíduo de cada fronteira
        ft = 0;                     % contador temorário
        stp = 1;                    % stop para while

        % define tamanho da fronteira k -> ft
        while stp ~= 0
            
            if F(k , ft + 1) ~= 0
                
                ft = ft + 1;
                
            elseif F(k , ft + 1) == 0
                
                stp= 0;
                
            end %if
        end %i

%         disp(F);
%         disp(nd);

        kt = 1; % contador para pop temp
        
        for i = 1 : ft

            % busca dominados por i
            for j = 1 : npop

                if U(F(k , i) , j) ~= 0
                    
                    if nd(U(F(k , i) , j)) ~= 0
                        
                        nd(U(F(k , i) , j)) = nd(U(F(k , i) , j)) - 1;

                        if nd(U(F(k , i) , j)) == 0
                            
                            temp(kt) = U(F(k , i) , j);
                            
                            kt = kt + 1;
                        
                        end %if
                    end %if
                end %if        
            end %j
        end %i

        k = k + 1;
        F(k , :) = temp(:);
        
    end %while

    return;
end

