function md = v_damp(x , control , tcromossomo)
    %
    % Sintaxe :
    % v_damp(x , control , tcromossomo)= md ;
    % onde 'x' representa um vetor com parametros dos controladores na
    % ordem K, Beta, Gama. 
    % 'control' representa um vetor bin�rio de controladores com tamanho 
    % igual a quantidade m�xima de  controladores, os bits altos ativam 
    % o controlador e os baixos desativam. 
    % 'md' � o retorno da funcao, representa o valor do ponto menos a-
    % mortecido entre todos os pontos de operacao.
    
    opoints = 61;    % pontos de operacão
    alfa = 0.1;      % constante Alfa
    maxcontrol = 16; % máximo de controladores 
    %mincontrol = 6;  % mínimo de controladores

    %tcromossomo = 3 * maxcontrol;

    
    %% carrega pontos de operacão
    run('../_inf/sysLOAD.m');  % pontos de opera��o
    
    %% inicia verificacão
    
    %  Ordem do cromossomo
    %         PSS1                 PSS2                  PSS3          ...
    %  |K1| |beta1| |gama1| |K2| |beta2| |gama2|  |K3| |beta3| |gama3| ... 

    % define as matrizes A, B e C, de acordo com os Alfas, Betas e Gamas
    % Ac(i)= [ -alfa(i)                          0                       0 
    %          gama(i)-alfaBeta(i)               -gama(i)                0
    %          beta(i)Gama(i)-alfa(Beta(i)^2)    gama(i)-Beta(i)Gama(i)  -gama(i)]
    %
    % Bc(i)= [ 1; beta(i); beta(i)^2]
    % Cc(i)= [0 0 K]

    
    k = 1; % controlador 
    j = 1; % controlador no cromossomo

    while j <= tcromossomo

        a(1 , k).c= [ -alfa                                                        0                                     0;
                      x(1 , j + 2) - alfa * x(1 , j + 1)                           -x(1 , j + 2)                         0;
                      x(1 , j + 1) * x(1 , j + 2) - alfa * (x(1 , j + 1)) ^ 2      x(1 , j + 2) * (1 - x(1 , j + 1))     -x(1 , j + 2)];

        b(1 , k).c = [ 1 ; x(1 , j + 1) ; (x(1 , j + 1))^2 ];
        
        if control(k) ~= 0
            
            cc(1 , k).c= [ 0  0  x(1 , j)];
            
        elseif control(k) == 0
            
            cc(1 , k).c= [ 0  0  0];
            
        end %if
        
        k = k + 1; % incrementa controlador 
        j = j + 3; % incrementa controlador no cromossomo
        
    end
    
    % define as matrizes Ac, Bc e Cc
    % Ac(1,1).c =[ a(1,1).c zeros    zeros zeros ...
    %              zeros    a(1,2).c zeros zeros ...
    %              ...        ...     ...   ...  ... ]
    
    %Ac = zeros(3 * maxcontrol , 3 * maxcontrol);
    %Bc = zeros(3 * maxcontrol , 3 * maxcontrol);
    %Cc = zeros(3 * maxcontrol , 3 * maxcontrol);
    
    for i = 1 : maxcontrol
          
      Ac(3 * i - 2 : 3 * i , 3 * i - 2 : 3 * i) = a(1 , i).c;  
      Bc(3 * i - 2 : 3 * i , i) = b(1 , i).c;
      Cc(i , 3 * i - 2 : 3 * i) = cc(1 , i).c;
      
    end %i
    
    % define matriz x~' e salva na estrutura xtl.c (x-tiu-linha).c
    for j = 1 : opoints 
        
        xtl(1 , j).c = [A(1 , j).c                                   B(1 , j).c * Cc;
                        Bc * C(1 , j).c * A(1 , j).c                 Ac + Bc * C(1 , j).c * B(1 , j).c * Cc];
    
    end % j
    
    %%
    y = 0; 
    
    for j = 1 : opoints
        
        [~ , y , ~] = damp(xtl(1 , j).c);
        mdamp(1 , j).c = y;
        
    end % j
    
    clear xtl.c
    
    %y = 0; w=0; z=0; %zera armazenadores tempor�rios
    w = 0;
    
    [size_mdamp ~]= size(mdamp(1,1).c);
    
    %numera os amortecimentos
    for k = 1 : opoints
        
        for j = 1 : size_mdamp
            
            mdamp(1 , k).c(j , 2)= j;
            
        end % j
    end % k
    
    % verifica o menor amortecimento entre os pontos de operacão
    % os menores amortecimentos são guardados na estrutura amt.t
    
    for k = 1 : opoints
        
        w = min(mdamp(1 , k).c(: , 1));        
        md1(1 , k) = w;
    end
    
    md(1) = min(md1(1,:));
    md(2) = sum(control);
    
    return;
end