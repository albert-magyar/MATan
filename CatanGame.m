classdef CatanGame < handle
    
    properties
        CurrentPlayer
        NumPlayers
        Players = {};
        Board
        Deck = 25;
        RollPics;
    end
    
  properties(Dependent)
    CurrentPlayerString
  end  

  methods
    function A = get.CurrentPlayerString(game)
      A = strcat('Player: #',num2str(game.CurrentPlayer.Index));
    end
  end

    
    methods
        function obj = CatanGame
            % calls showSplashScreen
            obj.RollPics = cell(2,6);
            obj.RollPics{1,1} = imread('1_y_die.jpg');
            obj.RollPics{1,2} = imread('2_y_die.jpg');
            obj.RollPics{1,3} = imread('3_y_die.jpg');
            obj.RollPics{1,4} = imread('4_y_die.jpg');
            obj.RollPics{1,5} = imread('5_y_die.jpg');
            obj.RollPics{1,6} = imread('6_y_die.jpg');
            obj.RollPics{2,1} = imread('1_r_die.jpg');
            obj.RollPics{2,2} = imread('2_r_die.jpg');
            obj.RollPics{2,3} = imread('3_r_die.jpg');
            obj.RollPics{2,4} = imread('4_r_die.jpg');
            obj.RollPics{2,5} = imread('5_r_die.jpg');
            obj.RollPics{2,6} = imread('6_r_die.jpg');
            showSplashScreen(obj)
        end
               
        function showSplashScreen(obj) % called by constructor brings up screen with options new game, load game, number of players
            screen = figure('MenuBar','none');
            ha = axes('Parent',screen,'units','normalized', ...
                'position',[0 0 1 1]);
            uistack(ha,'bottom');
            I=imread('BoxCover.jpg');
            hi = imagesc(I);
            colormap gray
            set(ha,'handlevisibility','off','visible','off')   
            i = uipanel('Parent',screen);
            uistack(i,'bottom');
            b = uicontrol('Parent',i,'Callback',@(h,d) play(obj,h,d,screen),...
                'String','Play','Units','normalized','Position',[.1 .1 .3 .1]);
            c = uicontrol('Parent',i,'Callback',{@loadButtonCallback},...
                'String','Load','Units','normalized','Position',[.6 .1 .3 .1]);
            
        end
        
        function beginGame(obj,h,d,f,q)
            close(f) % closes figure from play
            obj.NumPlayers = q + 1; % q is value from popup menu
            rolls = zeros(1,obj.NumPlayers); % initializes matrix for player rolls
            obj.Board = CatanBoard(obj);
            obj.Board.disableButtons;
            for num = 1:obj.NumPlayers
                obj.Players{num} = Player(obj,num,obj.Board);
            end
            
            while (max(rolls) == 0) || length(find(rolls == max(rolls))) > 1 % while the maximum of rolls is 0 or there are two equal maximums
                for n = 1:obj.NumPlayers
                    q = strcat('Player  #',num2str(n),' roll');
                    h = figure('units','normalized','Position',...
                        [.4 .45 .2 .1],'MenuBar','none','Name',q);
                    rolbut = uicontrol('Position',[20 20 200 40],...
                        'String',q,'Callback','uiresume(gcbf)');
                    uiwait(gcf) % waits for Roll Dice button to be clicked
                    roll_mat = [ceil(5*rand) ceil(5*rand)];
                    rolls(n) = sum(roll_mat,2); % put in code for rollDice function since I could not get it to work here for some reason?
                    imagesc(obj.RollPics{1,roll_mat(1)},'Parent',obj.Board.YDiceAxes);
                    set(obj.Board.YDiceAxes,'Visible','off');
                    imagesc(obj.RollPics{2,roll_mat(2)},'Parent',obj.Board.RDiceAxes);
                    set(obj.Board.RDiceAxes,'Visible','off');
                    close(h)
                end
            end
            [z,curPlyrInd] = max(rolls); % sets the current player to the one who rolled highest
            obj.CurrentPlayer = obj.Players{curPlyrInd};
            helpdlg(['Player ' num2str(obj.CurrentPlayer.Index) ' will go first!'],'Catan')
            
            pause(1)
            
            obj.CurrentPlayer.buildFirstSettlement
            
        end   
            
        function beginTurn(obj,player)
            for x = 1:5
              st = {'Brick: ' 'Wheat: ' 'Wood: ' 'Ore: ' 'Sheep: '};
              set(obj.Board.Indicators{x},'String',strcat(st{x},num2str(obj.CurrentPlayer.Hand{1}(x))));
            end
            
            for x = 6:obj.NumPlayers
              set(obj.Board.Indicators{x},'String',['# of Cards P ',num2str(sum(obj.Players{x}.Hand{1},2))]);
            end
            set(obj.Board.Controls{2},'String',obj.CurrentPlayerString);
            h = figure('units','normalized','Position',...
                [.4 .4 .2 .1],'MenuBar','none');
            rolbut = uicontrol('Position',[20 20 200 40],...
                'String','Roll Dice','Callback','uiresume(gcbf)');
            uiwait(gcf) % waits for Roll Dice button to be clicked
                    roll_mat = [ceil(5*rand) ceil(5*rand)];
                    value = sum(roll_mat,2); % put in code for rollDice function since I could not get it to work here for some reason?
                    imagesc(obj.RollPics{1,roll_mat(1)},'Parent',obj.Board.YDiceAxes);
                    set(obj.Board.YDiceAxes,'Visible','off');
                    imagesc(obj.RollPics{2,roll_mat(2)},'Parent',obj.Board.RDiceAxes);
                    set(obj.Board.RDiceAxes,'Visible','off');
            close(h)
            if value == 7
                moveRobber(obj.Board.CatanRobber)
            end
            % distribute resources to players
            for i = 1:obj.NumPlayers
              for j = 1:5-obj.Players{i}.RemainingStructures(1)
                for k = 1:3
                  if obj.Players{i}.Structures{1}{j}.Collect{k,1} == value
                    num = obj.Players{i}.Structures{1}{j}.Value;
                    switch obj.Players{i}.Structures{1}{j}.Collect{k,2}
                      case 'brick'
                        add = [1 num];
                      case 'wheat'
                        add = [2 num];
                      case 'wood'
                        add = [3 num];
                      case 'ore'
                        add = [4 num];
                      case 'sheep'
                        add = [5 num];
                      otherwise
                        add = [1 0];
                    end
                  else
                    add = [1 0];
                  end
                  obj.Players{i}.Hand{1}(add(1)) = obj.Players{i}.Hand{1}(add(1)) + add(2);
                end
              end
            end
            
            % draw figure with interactions for player
            % callback of button in intermediate screen
            % 
        end
        
        function endTurn(obj)
            f = figure;
            obj.CurrentPlayer = obj.Players{mod(obj.CurrentPlayer.Index,obj.NumPlayers)+1};
            for q = 1:obj.NumPlayers
            	pointsarray(q) = obj.Players{q}.Points;
            end
            [a,b] = max(pointsarray)
            if a<10
              txt = uicontrol('Units','normalized','Style','text',...
                'Position',[.3 .5 .4 .1],'String',['Begin turn of Player' obj.CurrentPlayer.Index]);
            else
              txt = uicontrol('Units','normalized','Style','text',...
                'Position',[.3 .5 .4 .1],'String',['The winner is player #' b]);
            end
            h = uicontrol('Units','normalized','String','Continue',...
                'Position',[.4 .1 .2 .1],'Callback','uiresume(gcbf)');
            uiwait(gcf);
            close(f);
            
            
            beginTurn(obj,obj.CurrentPlayer)
            
            % click button, intermediate screen appears
        end
        
        function play(obj,h,d,screen)
            f = figure('MenuBar','none'); % create current figure
            close(screen) % closes splash screen
            a = uipanel('Parent',f);
            popup = uicontrol('Parent',a,'Style','popupmenu',...
                'String',{'two' 'three' 'four'},...
                'units','normalized','Position',[.4 .5 .2 .1]); 
            % menu to select players
            but = uicontrol('Parent',a,'String','Begin Game',...
                'Units','normalized','Position',[.4 .2 .2 .1],...
                'Callback',@(h,d) beginGame(obj,h,d,f,get(popup,'Value')));
            % begin game button
            txt = uicontrol('Parent',a,'Style','text',...
                'units','normalized','Position',[.4 .62 .2 .1],...
                'String','How many players?');
        end
        
        
    end
    
end