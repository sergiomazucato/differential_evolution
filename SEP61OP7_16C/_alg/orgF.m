function [pop popx mdamp] = orgF(popt , poptx , mdampt , F)
    %
    % Funcao que organiza a populacao e a matriz de fitness de acordo com
    % as fronteiras, ou seja, as 'n' solucoes presentes na primeira fron-
    % teira sao transferidas para as primeiras 'n' posicoes na  populacao 
    % e na matriz de fitness. As 'n1'solucoes presentes na segunda  fron-
    % teira sao transferidas para as posicoes entre 'n' e 'n' + 'n1'   na
    % populacao e na matriz de fitness, e assim por diante.
    %
    % Sintaxe: org(popt , mdampt , F) = [pop mdamp] , onde
    % popt representa a populacao nao organizada
    % mdampt representa a matriz de fitness referente a popt
    % F representa as fronteiras
    % pop representa a populacao organizada
    % mdamp representa a matriz de fitness referente a pop
    
    stp = 1; % logica de parada
    k = 1;   % contador de fronteira
    i = 1;   % contador de indivíduo
    j = 1;   % contador de endereco cromossomo
    
    while stp ~= 0
        if F(k,i) ~= 0

            pop(j , :)  = popt(F(k , i) , :);   % envia cromossomo de parâmetros
            popx(j , :) = poptx(F(k , i) , :);

            mdamp(j , :) = mdampt(F(k,i) , :); % envia fitness
            mdamp(j , 3) = k;                  % salva fronteira do cromossomo
            mdamp(j , 5) = j;                  % salva endereco do cromossomo
 
            i = i + 1;                         % incrementa contador de indivíduos
            j = j + 1;                         % incrementa contador de endereco cromossomo

        elseif F(k , i) == 0 && sum(F(k , :)) ~= 0            

            k = k + 1; % incrementa contador de fronteiras
            i = 1;     % reinicia contador de indivíduos

        elseif sum( F(k,:) ) == 0

            stp = 0; % fim das fronteiras e fim do laco

        end %if
    end %i
end