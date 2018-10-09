clear all
clc

% algoritmo gerador de populacão aleatória

npop = 300; % define tamanho da populacão

maxcontrol = 16; % máximo de controladores 
mincontrol = 6;  % mínimo de controladores

psskmin = 0;   psskmax = 20; % limitantes pss - K
pssbmin = 1;   pssbmax = 8;  % limitantes pss - Beta
pssgmin = 4;   pssgmax = 20; % limitantes pss - Gama
tcromossomo = 3 * maxcontrol; % tamanho do cromossomo

% cria populacão de parâmetros

kpss = (psskmax - psskmin) * rand(npop , maxcontrol);                                     % define pop de K's para Pss's
bpss = (pssbmax - pssbmin) * rand(npop , maxcontrol) + pssbmin * ones(npop , maxcontrol); % define pop de Betas para Pss's
gpss = (pssgmax - pssgmin) * rand(npop , maxcontrol) + pssgmin * ones(npop , maxcontrol); % define pop de Gamas para Pss's


pop = zeros(npop , tcromossomo); % define tamanho da pop
popx = zeros(npop , maxcontrol); % define tamanho da pop

j = 1; % define controlador

for i = 1 : maxcontrol
    
    pop(: , j) = kpss(: , i);
    pop(: , j + 1) = bpss(: , i);
    pop(: , j + 2) = gpss(: , i);
    
    j = j + 3;
    
end % i

% cria populacão de chaveamento de controladores

%%
for i = 1 : npop
    
    x = round(rand(1 , maxcontrol));

    while sum(x) < (round(rand * (maxcontrol - mincontrol)) + mincontrol)

        y = round(rand * (maxcontrol - 1)) + 1;
        x(y) = 1;
        
    end %while
    
    popx(i , :) = x;
    
    %sum(popx(i , :))

end % i
%%
popini = pop;
popinix = popx;

save('/run/media/mzk/mzkFILES/research/Journal/_pops/pop300.mat' , 'popini' , 'popinix' , 'npop');
