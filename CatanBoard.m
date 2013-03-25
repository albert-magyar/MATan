classdef CatanBoard < handle
    
    properties
      Fig;
      LeftPanel;
      MiddlePanel;
      RightPanel;
      PanelAxes;
      BoardAxes;
      Controls;
      Indicators;
      HexButtons;
      PlayerAxes;
      YDiceAxes;
      RDiceAxes;
    end
      
    properties
      TrialHex;
      Hexes;
      CatanRobber;
      Game;
    end
    
    properties
      ResourceArray = {'sheep' 'wheat' 'wood' 'ore' 'brick'};
    end
    
    methods
        function obj = CatanBoard(game)
            % initialize random resource distribution
            qq = obj.ResourceArray;
            qq = {qq{1:5} qq{1:5} qq{1:5} qq{1:3} 'desert'};
            order = randperm(19);
            obj.ResourceArray = qq(order);
            
            obj.Fig = figure('MenuBar','none','Position',[110 75 1000 600]);
            obj.PanelAxes = axes('Parent',obj.Fig,'units','normalized', ...
                'position',[0 0 1 1]);
            I=imread('goldtexture.jpg');
            hi = imagesc(I);
            
            obj.BoardAxes = axes('Parent',obj.Fig,'units','normalized',...
                'position',[.2 .08 .6 .84],'XLim',[0 1],'YLim',[0 1]);
            uistack(obj.PanelAxes,'bottom');
            uistack(obj.BoardAxes,'top');
            
            colormap gray
            set(obj.PanelAxes,'handlevisibility','off','visible','off');
            set(obj.BoardAxes,'handlevisibility','off','visible','off');
            
            obj.Game = game;
            
            obj.YDiceAxes = axes('Parent',obj.Fig,'Position',[.03 .75 .06 .10]);
            obj.RDiceAxes = axes('Parent',obj.Fig,'Position',[.11 .75 .06 .10]);
            blankr=imread('blank_r_die.jpg');
            blanky=imread('blank_y_die.jpg');
            YDice = imagesc(blanky,'Parent',obj.YDiceAxes);
            set(obj.YDiceAxes,'Visible','off');
            RDice = imagesc(blankr,'Parent',obj.RDiceAxes);
            set(obj.RDiceAxes,'Visible','off');

            obj.LeftPanel = uipanel('Parent',obj.Fig,'Units','normalized',...
                'Position',[0 0 .2 1]); % left panel
            uistack(obj.LeftPanel,'bottom')
            obj.RightPanel = uipanel('Parent',obj.Fig,'Units','normalized',...
                'Position',[.8 0 .2 1]); % right panel
            uistack(obj.RightPanel,'bottom')
            obj.Indicators{1} = uicontrol('Parent',obj.RightPanel,'Style','text',... % player x string
                'String',['Brick: '],'units','normalized','BackgroundColor',[.588 .086 .043],...
                'Position',[.2 .9 .6 .05]);
            obj.Indicators{2} = uicontrol('Parent',obj.RightPanel,'Style','text',... % player x string
                'String',['Wheat: '],'units','normalized','BackgroundColor','y',...
                'Position',[.2 .8 .6 .05]);
            obj.Indicators{3} = uicontrol('Parent',obj.RightPanel,'Style','text',... % player x string
                'String',['Wood: '],'units','normalized','BackgroundColor',[.133 .545 .133],...
                'Position',[.2 .7 .6 .05]);
            obj.Indicators{4} = uicontrol('Parent',obj.RightPanel,'Style','text',... % player x string
                'String',['Ore: '],'units','normalized','BackgroundColor',[.5 .5 .5],...
                'Position',[.2 .6 .6 .05]);
            obj.Indicators{5} = uicontrol('Parent',obj.RightPanel,'Style','text',... % player x string
                'String',['Sheep: '],'units','normalized','BackgroundColor','g',...
                'Position',[.2 .5 .6 .05]);
            indic_cell = {'r' 'b' [1 .5 0] 'w'};
            for z = 1:obj.Game.NumPlayers
              obj.Indicators{z+5} = uicontrol('Parent',obj.RightPanel,'Style','text',... % player x string
                'String',['# of Cards Player ',num2str(z)],'units','normalized','BackgroundColor',indic_cell{z},...
                'Position',[.2 .5-.1*z .6 .05]);
            end
              
            
            % draw middle player for showing hand information
            obj.MiddlePanel = uipanel('Parent',obj.Fig,'Units','normalized',...
                'Position',[.2 .08 .6 .84],'Visible','on');
            obj.PlayerAxes{1} = axes('Parent',obj.RightPanel,'Units','normalized',...
                'Position',[.1 .7 .8 .16],'Visible','on','XLim',[0 1],'YLim',[0 1]);
            obj.PlayerAxes{2} = axes('Parent',obj.RightPanel,'Units','normalized',...
                'Position',[.1 .5 .8 .16],'Visible','off','XLim',[0 1],'YLim',[0 1]);
            obj.PlayerAxes{3} = axes('Parent',obj.RightPanel,'Units','normalized',...
                'Position',[.1 .3 .8 .16],'Visible','off','XLim',[0 1],'YLim',[0 1]);
              
            if obj.Game.NumPlayers == 4
              obj.PlayerAxes{4} = axes('Parent',obj.MiddlePanel,'Units','normalized',...
                  'Position',[.05 .1 .9 .18],'Visible','off','XLim',[0 1],'YLim',[0 1]);
            end
            
            uistack(obj.MiddlePanel,'bottom')
            obj.Controls{1} = uicontrol('Parent',obj.LeftPanel,'Units','normalized',... % end turn button
                'Position',[.2 .05 .6 .075],'Style','pushbutton',...
                'String','End Turn','Callback',{@endTurnButtonCallback,obj});
            obj.Controls{2} = uicontrol('Parent',obj.LeftPanel,'Style','text',... % player x string
                'String','Player x','units','normalized',...
                'Position',[.2 .9 .6 .05]);
            obj.Controls{3} = uicontrol('Parent',obj.LeftPanel,'Style','pushbutton',... % trade button
                'String','Trade','units','normalized',...
                'Position',[.2 .25 .6 .075],'Callback',...
                {@tradeButtonCallback,obj.Game});
            obj.Controls{4} = uicontrol('Parent',obj.LeftPanel,'Style','pushbutton',... % settlement button
                'String','Sett','units','normalized','Position',...
                [.2 .4 .27 .075],'Callback',{@settButtonCallback,obj.Game});
            obj.Controls{5} = uicontrol('Parent',obj.LeftPanel,'Style','pushbutton',... % city button
                'String','City','units','normalized','Position',...
                [.53 .4 .27 .075],'Callback',{@cityButtonCallback,obj.Game});
            obj.Controls{6} = uicontrol('Parent',obj.LeftPanel,'Style','pushbutton',... % road button
                'String','Road','units','normalized','Position',...
                [.2 .5 .27 .075],'Callback',{@roadButtonCallback,obj.Game});
            obj.Controls{7} = uicontrol('Parent',obj.LeftPanel,'Style','pushbutton',... % development card button
                'String','Card','units','normalized','Position',...
                [.53 .5 .27 .075],'Callback',{@drawDevCardCallback,obj.Game}); 
            obj.Controls{8} = uicontrol('Parent',obj.LeftPanel,'Style','pushbutton',... % bank trade button
                'String','Trade Bank','Units','normalized','Position',...
                [.2 .15 .6 .075],'Callback',{@bankTradeCallback,obj.Game});
            obj.Controls{9} = uicontrol('Parent',obj.LeftPanel,'Units','normalized',... % knight button
                'Position',[.2 .6 .27 .075],'String','Knight','Callback',...
                {@checkKnightCallback,obj.Game});
            obj.Controls{10} = uicontrol('Parent',obj.LeftPanel,'Units','normalized',... % dev card button
                'Position',[.53 .6 .27 .075],'String','Dev','Callback',...
                {@playCardCallback,obj.Game});
              
            num = 65;
      
            for i = 1:19
                pause(.1)
              obj.Hexes{i} = CatanHex(i,char(num),obj.ResourceArray{i},obj);
              if strcmp(obj.ResourceArray{i}, 'desert')
                num = num;
                obj.CatanRobber = Robber(obj.Hexes{i},obj);
                obj.Hexes{i}.Robber = obj.CatanRobber;
              else
                num = num + 1;
              end
                obj.Hexes{i}.draw;
                obj.Hexes{i}.drawToken;
            end
            
            for i = 20:37
                pause(.1)
              obj.Hexes{i} = CatanHex(i,'null','ocean',obj);
              obj.Hexes{i}.draw;
            end
        end
        
        function drawHexButtons(board,num) % num selects which function will be called next; 1 for settlement 2 for city and 3 for road
                for n = 1:19
                    board.HexButtons{n} = uicontrol('Parent',board.MiddlePanel,...
                    'Units','normalized','String',num2str(board.Hexes{n}.Token(2)),'Visible','on','Enable','on','Position',...
                    [((board.Hexes{n}.Position) - .025) .05 .05],'Callback',...
                    {@hexButtonCallback,board,n,num});
                end
        end
        
        function updateRightPanel(obj)
          c = obj.Game.CurrentPlayer;
          n = obj.Game.NumPlayers;
          
          for i = 1:n
          
            % find how many cards they have
            cardarray = obj.Game.Players{n}.Hand{1}
            cardnum = sum(cardarray,2)
            
            cardimage = imread('card.jpg');
          
            for j = 1:cardnum
              height = .0760
              width = .247
              bottom = 1-(.2*n+.1*floor(j/5))
              left = .05 + 1
              
              images{j} = axes('Parent','obj.Fig')
            end
            
            set(obj.PlayerAxes{n},'XLim',[0 1],'YLim',[0 1])
            c = 1
            
          end
          
        end
        
        function disableButtons(obj)
          for q = [1 3 4 5 6 7 8 9 10]
              set(obj.Controls{q},'Enable','off');
          end
        end
        
        function enableButtons(obj)
          for q = [1 3 4 5 6 7 8 9 10]
              set(obj.Controls{q},'Enable','on');
          end
        end
        
    end
    
end