function Sliders(cmd)
if ~nargin
    Sliders('init')
    return;
end

if ~(ischar(cmd)||isscalar(cmd))
    return;
end

switch cmd
    %------------------------------------------------------------------
    case 'init'

        % MAIN
        scrsz = get(0,'ScreenSize');
        hFigure = figure( ...
            'Name','Sliders', ...
            'Menubar','none',...
            'NumberTitle','off', ...
            'KeyPressFcn','Sliders(double(get(gcbf,''Currentcharacter'')))', ...
            'Units','pixels', ...
            'Tag','Sliders', ...
            'Position',[(scrsz(3)-510)/2 (scrsz(4)-500)/2 510 500], ...
            'Color',[.95 .95 .95], ...
            'Colormap',[1 1 1;.93 .97 .93;1 1 .6;.6 .8 1;.6 1 .6;1 .6 .6], ...
            'Visible','on');

        % MENU
        FileMenu = uimenu(hFigure,'Label','Arquivo');
        uimenu(FileMenu,'Label','Novo','Accelerator','N','Callback','Sliders(''NewGame'')');
        Newtabuleiro = uimenu(FileMenu,'Label','Novo tabuleiro');
        uimenu(Newtabuleiro,'Label','3 (2x2)','Callback','Sliders(''tres'')');
        uimenu(Newtabuleiro,'Label','8 (3x3)','Callback','Sliders(''oito'')');
        uimenu(Newtabuleiro,'Label','15 (4x4)','Callback','Sliders(''quinze'')');
        uimenu(Newtabuleiro,'Label','24 (5x5)','Callback','Sliders(''baitola'')');
        uimenu(Newtabuleiro,'Label','35 (6x6)','Callback','Sliders(''trinta_e_cinco'')');
        uimenu(Newtabuleiro,'Label','48 (7x7)','Callback','Sliders(''quarenta_e_oito'')');
        uimenu(Newtabuleiro,'Label','Personalizar ...','Separator','on','Callback','Sliders(''o_chato_quis_um_nao_listado'')');
        uimenu(FileMenu,'Label','Importar [matriz]','Callback','Sliders(''importar_matriz'')');
        uimenu(FileMenu,'Label','Resolver','Separator','on','Callback','Sliders(''Solve'')');
        uimenu(FileMenu,'Label','Sair','Accelerator','Q','Separator','on','Callback','delete(gcf)');

        % MATRIZ
        axes( ...
            'Parent',hFigure, ...
            'Units','normalized', ...
            'Clipping','on', ...
            'Position',[0.02 0.02 0.96 0.96]);
        axis('square')

        % Começa com um tabuleiro de N=16
        startgame(16)
        %------------------------------------------------------------------
    case 'Surface'
        ud = get(gca,'UserData');
        set(gcf,'Name',[num2str(ud.N-1) '-Puzzle'])
        EdgeColor = [.6 .6 .6];
        FaceColor = [1 1 1];
        FontSize = .5/ud.n;
        buracoColor = [.3 .3 .3];
        delete(findobj(gca,'Tag','Surface'))
        delete(findobj(gca,'Tag','buraco'))
        arrayfun(@(x)delete(findobj(gca,'Tag',num2str(x))),1:1000)

        % MATRIZ INTERFACE
        CData = zeros(ud.n+1,ud.n+1);
        surface( ...
            zeros(size(CData)),CData, ...
            'Parent',gca, ...
            'ButtonDownFcn','Sliders(''ButtonDown'');', ...
            'EdgeColor',EdgeColor, ...
            'FaceColor',FaceColor, ...
            'LineWidth',1,...
            'Tag','Surface')
        axis off
        hold on
        arrayfun(@(x)text( ...
            'Position',[mod(x-1,ud.n)+1 ud.n+1-ceil(x/ud.n)]+.5, ...
            'String','', ...
            'FontUnits','normalized', ...
            'FontSize',FontSize, ...
            'Tag',num2str(x), ...
            'ButtonDownFcn','Sliders(''ButtonDown'');', ...
            'HorizontalAlignment','center'), ...
            1:ud.N)

        % BURACO
        fill(1,1,buracoColor, ...
            'ButtonDownFcn','Sliders(''ButtonDown'');', ...
            'Tag','buraco')
        %------------------------------------------------------------------
    case 'tres'
        startgame(4)
        %------------------------------------------------------------------
    case 'oito'
        startgame(9)
        %------------------------------------------------------------------
    case 'quinze'
        startgame(16)
        %------------------------------------------------------------------
    case 'baitola'
        startgame(25)
        %------------------------------------------------------------------
    case 'trinta_e_cinco'
        startgame(36)
        %------------------------------------------------------------------
    case 'quarenta_e_oito'
        startgame(49)
        %------------------------------------------------------------------
    case 'o_chato_quis_um_nao_listado'
        prompt = {'Tamanho da largura do tabuleiro (N):'};
        name = 'Tamanho personalizado';
        options.Resize = 'on';
        answer = inputdlg(prompt,name,1,{'15'},options);
        if ~isempty(answer)
            N = str2double(answer{1})+1;
            n = round(sqrt(N));
            if n^2==N
                startgame(N)
            else
                errordlg('Valor de N inválido','Tamanho personalizado')
            end
        end
        %------------------------------------------------------------------
    case 'NewGame'
        ud = get(gca,'UserData');
        tabuleiro = Embaralha(1:ud.N,10000);
        ud.tabuleiro = tabuleiro;
        ud.tabuleirohistory = ud.tabuleiro;
        ud.histpos = 1;
        ud.starttime = clock;
        ud.endtime = [];
        set(gca,'UserData',ud);
        set(findobj(gcf,'Tag','Undo'),'Enable','off')
        set(findobj(gcf,'Tag','Redo'),'Enable','off')
        drawtabuleiro()
        drawpos()
        %------------------------------------------------------------------
    case 'importar_matriz'
        prompt = {'Defina o jogo como uma matriz do MATLAB:'};
        name = 'Importar';
        options.Resize = 'on';
        answer = inputdlg(prompt,name,1,{''},options);
        if ~isempty(answer)&&~isempty(answer{1})
            tabuleiro = str2num(answer{1})';
            tabuleiro = tabuleiro(:)';
            N = length(tabuleiro);
            n = round(sqrt(N));
            if ~isempty(tabuleiro)&&n^2==N&&~ismember(0,ismember(1:N,tabuleiro))
                ud = get(gca,'UserData');
                ud.tabuleiro = tabuleiro;
                ud.N = N;
                ud.n = n;
                ud.currpos = 1;
                ud.tabuleirohistory = ud.tabuleiro;
                ud.histpos = 1;
                ud.starttime = clock;
                ud.endtime = [];
                set(gca,'UserData',ud);
                set(findobj(gcf,'Tag','Undo'),'Enable','off')
                set(findobj(gcf,'Tag','Redo'),'Enable','off')
                Sliders('Surface')
                drawtabuleiro()
                drawpos()
            else
                errordlg('Input Game Not Accepted','Import Game')
            end
        end
        %------------------------------------------------------------------
    case 'SimulateHistory'          
        set(gcf,'Color',[.7 0 0],'Pointer','watch','CloseRequestFcn','','KeyPressFcn','')
        ud = get(gca,'UserData');
        for i=1:ud.histpos
            buraco = find(ud.tabuleirohistory(i,:)==ud.N);
            x = mod(buraco-1,ud.n)+1;
            y = ud.n+1-ceil(buraco/ud.n);
            delete(findobj(gca,'tag','currpos'))
            plot(x+[0 .995 .995 0 0]+0.005,y+[0 0 .995 .995 0],'r', ...
                'LineWidth',2, ...
                'Tag','currpos')
            pause(.2)
            arrayfun(@(x)set(findobj(gca,'tag',num2str(x)), ...
                'String',num2str(ud.tabuleirohistory(i,x))), ...
                1:ud.N)
            set(findobj(gca,'tag','buraco'), ...
                'XData',x+[0 .99 .99 0 0]+0.005,...
                'YData',y+[0 0 .99 .99 0]+0.005)
            pause(.3)
        end
        set(gcf,'Color',[.95 .95 .95],'Pointer','arrow','CloseRequestFcn','closereq','KeyPressFcn','Sliders(double(get(gcbf,''Currentcharacter'')))')
        drawpos()
        %------------------------------------------------------------------
    case 'Solve'
        ud = get(gca,'UserData');
        if sum(ud.tabuleiro(:)'==1:ud.N)~=ud.N % if not solved
            set(gcf,'Color',[.7 0 0],'Pointer','watch','CloseRequestFcn','','KeyPressFcn','')
            pause(.2)
            tabuleirohistory = solve(ud.tabuleiro);
            ud.tabuleirohistory = [ud.tabuleirohistory(1:ud.histpos,:);tabuleirohistory];
            ud.tabuleiro = 1:ud.N;
            set(gca,'UserData',ud);
            set(findobj(gcf,'Tag','Redo'),'Enable','off')
            set(findobj(gcf,'Tag','Undo'),'Enable','on')
            ud = get(gca,'UserData');
            for i=ud.histpos:size(ud.tabuleirohistory,1)
                buraco = find(ud.tabuleirohistory(i,:)==ud.N);
                x = mod(buraco-1,ud.n)+1;
                y = ud.n+1-ceil(buraco/ud.n);
                delete(findobj(gca,'tag','currpos'))
                plot(x+[0 .995 .995 0 0]+0.005,y+[0 0 .995 .995 0],'r', ...
                    'LineWidth',2, ...
                    'Tag','currpos')
                pause(.01)
                arrayfun(@(x)set(findobj(gca,'tag',num2str(x)), ...
                    'String',num2str(ud.tabuleirohistory(i,x))), ...
                    1:ud.N)
                set(findobj(gca,'tag','buraco'), ...
                    'XData',x+[0 .99 .99 0 0]+0.005,...
                    'YData',y+[0 0 .99 .99 0]+0.005)
                pause(.03)
            end
            ud.histpos = size(ud.tabuleirohistory,1);
            set(gca,'UserData',ud);
            pause(.2)
            set(gcf,'Color',[.95 .95 .95],'Pointer','arrow','CloseRequestFcn','closereq','KeyPressFcn','Sliders(double(get(gcbf,''Currentcharacter'')))')
            drawpos()
        end
        %------------------------------------------------------------------
    case 'ButtonDown' % MouseClick
        ud = get(gca,'UserData');
        n = sqrt(ud.N);
        pos = get(gca,'CurrentPoint');
        ud.currpos = sub2ind([n n],floor(pos(1,1)),ud.n+1-floor(pos(1,2)));
        set(gca,'UserData',ud);
        drawpos()
        if ~strcmpi('normal',get(gcf,'SelectionType'))
            Sliders(32)
        end
        %------------------------------------------------------------------
    case 28 % esquerda
        ud = get(gca,'UserData');
        if ud.currpos~=1
            ud.currpos = ud.currpos-1;
            set(gca,'UserData',ud);
            drawpos()
        end
        %------------------------------------------------------------------
    case 29 % direita
        ud = get(gca,'UserData');
        if ud.currpos~=ud.N
            ud.currpos = ud.currpos+1;
            set(gca,'UserData',ud);
            drawpos()
        end
        %------------------------------------------------------------------
    case 30 % cima
        ud = get(gca,'UserData');
        if ud.currpos>ud.n
            ud.currpos = ud.currpos-ud.n;
            set(gca,'UserData',ud);
            drawpos()
        end
        %------------------------------------------------------------------
    case 31 % baixo
        ud = get(gca,'UserData');
        if ud.currpos<=ud.N-ud.n
            ud.currpos = ud.currpos+ud.n;
            set(gca,'UserData',ud);
            drawpos()
        end
        %------------------------------------------------------------------
    case 32 % space
        ud = get(gca,'UserData');
        n = sqrt(ud.N);
        buraco = find(ud.tabuleiro==ud.N);
        bx = mod(buraco-1,n)+1;
        by = ud.n+1-ceil(buraco/n);
        cx = mod(ud.currpos-1,n)+1;
        cy = ud.n+1-ceil(ud.currpos/n);
        if (bx==cx&&abs(by-cy)==1)||(by==cy&&abs(bx-cx)==1)
            ud.tabuleiro(buraco) = ud.tabuleiro(ud.currpos);
            ud.tabuleiro(ud.currpos) = ud.N;
            ud.histpos = ud.histpos+1;
            ud.tabuleirohistory(ud.histpos,:) = ud.tabuleiro;
            if size(ud.tabuleirohistory,1)>ud.histpos
                ud.tabuleirohistory(ud.histpos+1:end,:) = [];
            end
            set(findobj(gcf,'Tag','Redo'),'Enable','off')
            set(findobj(gcf,'Tag','Undo'),'Enable','on')
            ud.currpos = buraco;
            set(gca,'UserData',ud);
            drawtabuleiro()
            drawpos()
            if isempty(ud.endtime)
                verifica()
            end
        end
end
end
function drawtabuleiro()
ud = get(gca,'UserData');
arrayfun(@(x)set(findobj(gca,'tag',num2str(x)), ...
    'String',num2str(ud.tabuleiro(x))), ...
    1:ud.N)
buraco = find(ud.tabuleiro==ud.N);
x = mod(buraco-1,ud.n)+1;
y = ud.n+1-ceil(buraco/ud.n);
set(findobj(gca,'Tag','buraco'), ...
    'XData',x+[0 .99 .99 0 0]+0.005,...
    'YData',y+[0 0 .99 .99 0]+0.005)
end
function drawpos()
ud = get(gca,'UserData');
delete(findobj(gca,'tag','currpos'))
x = mod(ud.currpos-1,ud.n)+1;
y = ud.n+1-ceil(ud.currpos/ud.n);
plot(x+[0 .995 .995 0 0]+0.005,y+[0 0 .995 .995 0],'r', ...
    'LineWidth',2, ...
    'Tag','currpos')
end

%%  Embaralha.tabuleiro (só que não e java) 
function tabuleiro = Embaralha(tabuleiro,times)
N = length(tabuleiro);
n = sqrt(N);
buraco = find(tabuleiro==N);
for i=1:times
    move = [1 -1 n -n];
    x = mod(buraco-1,n)+1;
    y = ceil(buraco/n);
    switch x
        case 1
            move(2) = 1;
        case n
            move(1) = -1;
    end
    switch y
        case 1
            move(4) = n;
        case n
            move(3) = -n;
    end
    newburaco = buraco + move(ceil(rand*4));
    tabuleiro(buraco) = tabuleiro(newburaco);
    buraco = newburaco;
end
tabuleiro(newburaco) = N;
end

%% Verifica solução // o nome nem é intuitivo nem nada ...
function verifica()
ud = get(gca,'UserData');
if ~ismember(0,ud.tabuleiro==1:ud.N)
    ud.endtime = clock;
    set(gca,'UserData',ud);
    ico = ones(13)*3; 
    ico(:,1:4:13) = 1;
    ico(1:4:13,:) = 1;
    ico(10:12,10:12) = 2;
    map = [0 0 0;.5 .5 .6;1 1 1];
    msgbox(sprintf([...
        'PARABÉNS!\n\n'...
        'Tempo de início: %s\n'...
        'Tempo final:  %s\n\n'...
        'Tempo gasto: %d s\n'...
        'Número de jogadas: %d'],...
        datestr(ud.starttime,13),...
        datestr(ud.endtime,13),...
        round(etime(ud.endtime,ud.starttime)),...
        ud.histpos),...
        'Terminou o Sliders','custom',ico,map)
end
end

%% FUNCTION: STARTGAME
function startgame(N)
ud = get(gca,'UserData');
ud.N = N;
ud.n = sqrt(N);
ud.currpos = 1;
set(gca,'UserData',ud);
Sliders('Surface')
Sliders('NewGame')
end

%% FUNCTION: SOLVE
function solution = solve(tabuleiro)
tabuleiro = tabuleiro(:)';
solution = [];
N = length(tabuleiro);
n = sqrt(N);
QuadradoPos = @(Quadrado,tabuleiro)find(tabuleiro==Quadrado);
buracoPos = @(tabuleiro)QuadradoPos(N,tabuleiro);
column = @(pos)mod(pos-1,n)+1;
row = @(pos)ceil(pos/n);


for cr=1:n-2        % para todas as linhas (menos as ultimas)
    for cc=1:n-1    % para todas as colunas
        currentQuadrado = cc+(cr-1)*n;
        % corrige a marcação
        if QuadradoPos(currentQuadrado,tabuleiro)~=currentQuadrado %
            if row(QuadradoPos(currentQuadrado,tabuleiro)) == n
                moveburacoPara(n-1,column(QuadradoPos(currentQuadrado,tabuleiro)))
                moveburaco('em_baixo')
            end
            while row(buracoPos(tabuleiro))<n && row(buracoPos(tabuleiro))<row(QuadradoPos(currentQuadrado,tabuleiro))
                moveburaco('em_baixo');
            end
            if QuadradoPos(currentQuadrado,tabuleiro)==currentQuadrado
                continue
            end
            while column(QuadradoPos(currentQuadrado,tabuleiro)) ~= cc
                while row(buracoPos(tabuleiro))<n && row(buracoPos(tabuleiro))<=row(QuadradoPos(currentQuadrado,tabuleiro))
                    moveburaco('em_baixo');
                end
                if QuadradoPos(currentQuadrado,tabuleiro)==currentQuadrado
                    continue
                end
                if column(QuadradoPos(currentQuadrado,tabuleiro)) <= cc
                    while column(buracoPos(tabuleiro))<column(QuadradoPos(currentQuadrado,tabuleiro))+1
                        moveburaco('direita');
                    end
                    while column(buracoPos(tabuleiro))>column(QuadradoPos(currentQuadrado,tabuleiro))+1
                        moveburaco('esquerda');
                    end
                elseif column(QuadradoPos(currentQuadrado,tabuleiro)) > cc
                    while column(buracoPos(tabuleiro))>column(QuadradoPos(currentQuadrado,tabuleiro))-1
                        moveburaco('esquerda');
                    end
                    while column(buracoPos(tabuleiro))<column(QuadradoPos(currentQuadrado,tabuleiro))-1
                        moveburaco('direita');
                    end
                end
                if row(buracoPos(tabuleiro)) > row(QuadradoPos(currentQuadrado,tabuleiro))
                    while row(buracoPos(tabuleiro)) > row(QuadradoPos(currentQuadrado,tabuleiro))
                        moveburaco('em_cima');
                    end
                end
                if column(buracoPos(tabuleiro)) > column(QuadradoPos(currentQuadrado,tabuleiro))
                    moveburaco('esquerda');
                else
                    moveburaco('direita');
                end
            end
            while row(QuadradoPos(currentQuadrado,tabuleiro)) ~= cr
                moveburacoPara(row(QuadradoPos(currentQuadrado,tabuleiro))+1,column(QuadradoPos(currentQuadrado,tabuleiro))+1)
                moveburaco('em_cima','em_cima','esquerda','em_baixo')
            end
        end
    end

    currentQuadrado = cr*n;
    if QuadradoPos(currentQuadrado,tabuleiro)~=currentQuadrado
        if row(QuadradoPos(currentQuadrado,tabuleiro)) == n
            moveburacoPara(n-1,column(QuadradoPos(currentQuadrado,tabuleiro)))
            moveburaco('em_baixo')
        end
        if row(buracoPos(tabuleiro))~=n && row(buracoPos(tabuleiro))<=row(QuadradoPos(currentQuadrado,tabuleiro))
            while row(buracoPos(tabuleiro))<n && row(buracoPos(tabuleiro))<row(QuadradoPos(currentQuadrado,tabuleiro))
                moveburaco('em_baixo');
            end
        end
        if QuadradoPos(currentQuadrado,tabuleiro)==currentQuadrado
            continue
        end
        while column(QuadradoPos(currentQuadrado,tabuleiro)) ~= n
            while row(buracoPos(tabuleiro))<n && row(buracoPos(tabuleiro))<=row(QuadradoPos(currentQuadrado,tabuleiro))
                moveburaco('em_baixo');
            end
            if QuadradoPos(currentQuadrado,tabuleiro)==currentQuadrado
                continue
            end
            if column(QuadradoPos(currentQuadrado,tabuleiro)) <= cc
                while column(buracoPos(tabuleiro))<column(QuadradoPos(currentQuadrado,tabuleiro))+1
                    moveburaco('direita');
                end
                while column(buracoPos(tabuleiro))>column(QuadradoPos(currentQuadrado,tabuleiro))+1
                    moveburaco('esquerda');
                end
            elseif column(QuadradoPos(currentQuadrado,tabuleiro)) > cc
                while column(buracoPos(tabuleiro))>column(QuadradoPos(currentQuadrado,tabuleiro))-1
                    moveburaco('esquerda');
                end
                while column(buracoPos(tabuleiro))<column(QuadradoPos(currentQuadrado,tabuleiro))-1
                    moveburaco('direita');
                end
            end
            while row(buracoPos(tabuleiro)) > row(QuadradoPos(currentQuadrado,tabuleiro))
                    moveburaco('em_cima');
            end         
            if column(buracoPos(tabuleiro)) > column(QuadradoPos(currentQuadrado,tabuleiro))
                moveburaco('esquerda');
            else
                moveburaco('direita');
            end
        end
        while row(QuadradoPos(currentQuadrado,tabuleiro)) > cr+1
            moveburacoPara(row(QuadradoPos(currentQuadrado,tabuleiro))+1,n-1)
            moveburaco('em_cima','em_cima','direita','em_baixo')
        end
        moveburacoPara(cr+2,n)
        moveburaco('em_cima','em_cima','esquerda','em_baixo','direita','em_baixo','esquerda','em_cima','em_cima','direita','em_baixo')
    end
end


for cc=1:n-2        
    cr = n;         
    currentQuadrado = cc+(cr-1)*n;
    if QuadradoPos(currentQuadrado,tabuleiro)~=currentQuadrado %
        if row(QuadradoPos(currentQuadrado,tabuleiro)) ~= n
            moveburacoPara(n,column(QuadradoPos(currentQuadrado,tabuleiro)))
            moveburaco('em_cima')
        end
        while column(QuadradoPos(currentQuadrado,tabuleiro)) ~= cc
            moveburacoPara(n-1,column(QuadradoPos(currentQuadrado,tabuleiro)))
            moveburaco('esquerda','em_baixo','direita')
        end
    end
    currentQuadrado = cc+(cr-2)*n;
    if QuadradoPos(currentQuadrado,tabuleiro)~=currentQuadrado
        if column(buracoPos(tabuleiro))==cc
            moveburaco('direita');
        end
        if QuadradoPos(currentQuadrado,tabuleiro)==currentQuadrado
            continue
        end
        if row(QuadradoPos(currentQuadrado,tabuleiro)) ~= n-1
            moveburacoPara(n-1,column(QuadradoPos(currentQuadrado,tabuleiro)))
            moveburaco('em_baixo')
        end
        while column(QuadradoPos(currentQuadrado,tabuleiro)) ~= cc+1
            moveburacoPara(n,column(QuadradoPos(currentQuadrado,tabuleiro)))
            moveburaco('esquerda','em_cima','direita')
        end
        moveburacoPara(n,cc+2);moveburaco('em_cima')
        moveburaco('esquerda','esquerda','em_baixo','direita','em_cima','direita','em_baixo','esquerda','esquerda','em_cima','direita')
    end
end
count = 0;
while buracoPos(tabuleiro)~=n*n || QuadradoPos((n-1)*n,tabuleiro)~=(n-1)*n
    if  row(buracoPos(tabuleiro))==n
        if column(buracoPos(tabuleiro))==n
            moveburaco('em_cima')
        else
            moveburaco('direita')
        end
    else
        if column(buracoPos(tabuleiro))==n
            moveburaco('esquerda')
        else
            moveburaco('em_baixo')
        end
    end
    count = count+1;
    if count>10
       break 
    end
end
    function swap(x,y)
        xp = (tabuleiro==x);
        yp = (tabuleiro==y);
        tabuleiro(xp) = y;
        tabuleiro(yp) = x;
    end
    function moveburaco(varargin)
        hp = find(tabuleiro==N);
        for ii=1:nargin
            switch varargin{ii}
                case 'esquerda'
                    hp = hp-1;
                case 'direita'
                    hp = hp+1;
                case 'em_cima'
                    hp = hp-n;
                case 'em_baixo'
                    hp = hp+n;
            end
            swap(N,tabuleiro(hp))
            solution = [solution;tabuleiro];
        end
    end
    function moveburacoPara(x,y)
        while row(buracoPos(tabuleiro)) < x
            moveburaco('em_baixo')
        end
        while row(buracoPos(tabuleiro)) > x
            moveburaco('em_cima')
        end
        while column(buracoPos(tabuleiro)) < y
            moveburaco('direita')
        end
        while column(buracoPos(tabuleiro)) > y
            moveburaco('esquerda')
        end
    end
end



