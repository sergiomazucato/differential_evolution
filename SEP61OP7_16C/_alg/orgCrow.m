function [pop popx mdamp] = orgCrow(popt , popxt , mdampt , npop)
    % nada
    
    mdampt(npop + 1 , :) = 500; 

    k = 0;

    for i = 1 : npop
        if mdampt(i , 3) ~= mdampt(i + 1 , 3)
    %%
            [~, y] = sort(mdampt(k + 1 : i , 2) , 'descend');

    %%
            for j = 1 : (i - k)

                pop(j + k , :)  = popt(mdampt(y(j) + k , 5) , :);
                popx(j + k , :) = popxt(mdampt(y(j) + k , 5) , :);
                
                mdamp(j + k , :) = mdampt(y(j) + k , :);
                mdamp(j + k , 5) = j + k;

            end %j

            k = i;

        end %if
    end %i

    return;
end