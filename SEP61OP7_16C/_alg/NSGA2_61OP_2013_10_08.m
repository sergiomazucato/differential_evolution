%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                  %%%
%%%                    NSGA-II                       %%%
%%% Data: 01/07/2013 - Sérgio Carlos Mazucato Junior %%%
%%%                                                  %%%
%%%        --->>>                      <<<---        %%%
%%%                                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
clc

%% informacões do sistema

opoints = 24;    % pontos de operacão
alfa = 0.1;      % constante Alfa
maxcontrol = 16; % máximo de controladores 
mincontrol = 6;  % mínimo de controladores

psskmin = 0;   psskmax = 20; % limitantes pss - K
pssbmin = 1;   pssbmax = 8;  % limitantes pss - Beta
pssgmin = 4;   pssgmax = 20; % limitantes pss - Gama

%% informacões do método de otimizacão

tcromossomo = 3 * maxcontrol; % tamanho do cromossomo

cchange = 0; % switch de cruzamento

txm = 0.30;        % taxa de mutacão
txmRAND = 0.1; % outra taxa de mutaçao para ligar mais controladores

maxit = 100;

%% informacões lógicas

counter = 1; % contador de iteracoes
c = 1;       % contador para parada
stop = 0;    % lógica da parada

%% informacões do problema
run('../_inf/sysLOAD.m');  % pontos de operacão

load('../_pops/pop100.mat'); % populacão inicial

% npop vem definido da pop importada do arquivo ------

popP = popini;
popPx = popinix;

t1 = tic;

%% verifica fitness inicial (popP ini)

mdampP = zeros(npop , 6);

[popP, popPx, mdampP] = fitness(popP , popPx , tcromossomo , npop);


%% verifica fronteiras por não dominância para populacao inicial

F = Pareto(mdampP , npop); % verifica fronteiras

%% organiza populacao inicial de acordo com as fronteiras

[popP, popPx, mdampP] = orgF(popP , popPx , mdampP , F);

%% calcula distância de multidão

crow = crowd(mdampP , npop);
mdampP(: , 4) = crow;

%% disposicao da matriz de fitness

% | fit1 | fit2 | fronteira | crowdist | end_atual | end_antigo |

%% organiza fronteiras por controladores em ordem decrescente

[popP, popPx, mdampP] = orgCrow(popP , popPx , mdampP , npop);


k = 0;
i = 1;

while mdampP(i , 3) <= 2

    k = k + 1;
    i = i + 1;

end

admp = mdampP(1 : k , :);
%% Prepara popQ para inicio do Algoritmo (start in cross)

popQ = zeros(size(popP));
popQx = zeros(size(popPx));

%% inicia NSGA-II

while counter < maxit
    tic
    %%
    k= 1;
    
    for i = 1 : round(npop / 2) - mod(npop , 2)
        
        %% faz torneio
        
        x = [1 1];
        
        x(1,1) = tnt(npop , mdampP);
        x(1,2) = tnt(npop , mdampP);
        
        xx = 1;
        while x(1) == x(2)
            
           x(2) = tnt(npop , mdampP);
           xx = xx + 1;
           
           if xx >= 10
               
               break
               
           end %if
        end %while
        
        %% faz cruzamento
        
        cross =  [popP(x(1) , :)  ; popP(x(2) , :)];
        crossx = [popPx(x(1) , :) ; popPx(x(2) , :)];
        
        switch cchange
            case 0,
                [cross, crossx] = cross00(cross , crossx , tcromossomo);
            
            case 1,
                [cross, crossx] = cross01(cross , crossx , tcromossomo);
        end
        
        popQ(k , :)  = cross(1 , :);
        popQx(k , :) = crossx(1 , :);
        
        popQ(k + 1 , :)  = cross(2 , :);
        popQx(k + 1 , :) = crossx(2 , :);

        k = k + 2;

    end %i
    
    %% verifica igualdades em popQ
    
    eqt = zeros(1 , npop);
    eqtk = 0;
    
    for i = 1 : npop - 1
        if (sum(popQ(i , :) == popQ(i + 1 , :)) == tcromossomo) && ...
                (sum(popQx(i , :) == popQx(i + 1 , :)) == tcromossomo / 3)
            
            eqt(k + 1) = i + 1;
            eqtk = k + 1;
            
        end %if
    end %i
    
    %% mutacao em popQ
    
    if eqtk > 0
        
        for i = 1 : eqtk

            y = eqt(i); % escolhe individuo para mutacao
            x = popQ(y , :);

            popQ(y , :) = mut(x , tcromossomo , maxcontrol , mincontrol , psskmin , psskmax , pssbmin , pssbmax , pssgmin , pssgmax);
            
            for j = 1 : maxcontrol
                if rand > txmRAND
                    popQx(y , round((maxcontrol - 1) * rand) + 1) = 1;
                else
                    popQx(y , round((maxcontrol - 1) * rand) + 1) = 0;
                end %if
            end %j
            
        end %i
        
    elseif eqtk <= 0
        
        for i = 1 : round(npop * txm)

            y = round((npop-1) * rand) + 1; % escolhe individuo para mutacao
            x = popQ(y , :);
            xx = popQx(y , :);

            popQ(y , :) = mut(x , tcromossomo , maxcontrol , mincontrol , psskmin , psskmax , pssbmin , pssbmax , pssgmin , pssgmax);
            popQx(y , round((maxcontrol - 1) * rand) + 1) = 1;
            
            for j = 1 : maxcontrol
                if rand > txmRAND
                    popQx(y , round((maxcontrol - 1) * rand) + 1) = 1;
                else
                    popQx(y , round((maxcontrol - 1) * rand) + 1) = 0;
                end %if
            end %j
            
        end %i
    end
    
    %% verifica limites de popQ e popQx
    
    [popQ, popQx] = lim(popQ , popQx , npop , maxcontrol , mincontrol , psskmin , psskmax , pssbmin , pssbmax , pssgmin , pssgmax);
    
    
    %% verifica fitness inicial (popP ini)

    mdampQ = zeros(size(mdampP));

    [popQ, popQx, mdampQ] = fitness(popQ , popQx , tcromossomo , npop);


    %% verifica fronteiras de popQ por não dominância para populacao inicial
    clear F;
    
    F = Pareto(mdampQ , npop); % verifica fronteiras

    %% organiza popQ de acordo com as fronteiras

    [popQ, popQx, mdampQ] = orgF(popQ , popQx , mdampQ , F);

    %% calcula distância de multidão
    clear crow;
    
    crow = crowd(mdampQ , npop);
    mdampQ(: , 4) = crow;

    %% organiza fronteiras por controladores em ordem decrescente

    [popQ, popQx, mdampQ] = orgCrow(popQ , popQx , mdampQ , npop);

    %% define popR

    popR  = [popP ; popQ];
    popRx = [popPx ; popQx];
    mdampR = [mdampP ; mdampQ];
    
    %% verifica fronteiras por nao dominancia em popR
    clear F;
    
    F = Pareto(mdampR , 2 *npop);
    
    %% organiza popR de acordo com as fronteiras
    
    [popR, popRx, mdampR] = orgF(popR , popRx , mdampR , F);
    
    %% calcula distancia de multidao em popR
    clear crow;

    crow = crowd(mdampR , 2 * npop);
    mdampR(: , 4) = crow;
    
    %% organiza fronteiras de popR por crowdist em ordem decrescente
    [popR, popRx, mdampR] = orgCrow(popR , popRx , mdampR , 2 * npop);
    
    %% salva nova geracao de pais (popP)
    
    popP = popR(1 : npop , :);
    mdampP = mdampR(1 : npop, :);
    
    counter = counter + 1;
    
    lastdmp = admp;
    
    k = 0;
    i = 1;
    while mdampP(i , 3) <= 2
        
        k = k + 1;
        i = i + 1;
        
    end
    
    %disp(mdampP(1 : k , :));
    
    admp = mdampP(1 : k , :);
    
    i = 1;
    
    while admp(i , 3) == 1 && lastdmp(i , 3) == 1
        if(admp(i , 1) == lastdmp(i , 1) && ...
                admp(i , 2) == lastdmp(i , 2) && ...
                    admp(i , 3) == lastdmp(i , 3))
            admp(i , 7) = 0;
        else
            admp(i , 7) = 1;
        end
        i = i + 1;
    end %i
    
    disp(admp);
    disp(counter);
    
    toc
end

time = toc(t1);