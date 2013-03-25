classdef Player < handle
    
    properties
        Hand = {[4 2 6 2 2]} % the first index in hand is a 1x5 array
        % counting the amount of resources the player has. It follows the
        % order [brick grain lumber ore wool], initialized so that there
        % are enough resources for 2 settlements and 2 roads
        Points = 0;
        LongestRoad = 0;
        LargestArmy = 0;
        Structures = {{} {} {}}; % {settlements cities roads}
        RemainingStructures = [5 4 15]; % settlements, cities, roads
        Index
        CatanGame
        CatanBoard
        Building = 0;
    end
    
    methods
        function obj = Player(game,num,board)
            obj.Index = num;
            obj.CatanGame = game;
            obj.CatanBoard = board;
            obj.Hand{1} = [5 5 5 5 5];
        end
        
        function drawDevCard(player)
            
            if player.Hand{1}(2) < 1 % if not enough resources, cancel
                helpdlg('You do not have enough resources for a development card',...
                    'Development Card')
            elseif player.Hand{1}(4) < 1
                helpdlg('You do not have enough resources for a development card',...
                    'Development Card')
            elseif player.Hand{1}(5) < 1
                helpdlg('You do not have enough resources for a development card',...
                    'Development Card')
            elseif player.CatanGame.Deck == 0
                helpdlg('There are no more development cards to draw',...
                    'Development Card')
            else
                value = rand;
                if value <= .56 % 14/25 development cards are knights
                    player.Hand{end + 1} = SoldierCard(player);
                elseif value > .56 && value <= .76 % 5/25 development cards are victory points
                    player.Points = player.Points + 1;
                    player.Hand{end + 1} = Card(player); % card with no function; the victory point has been added, so this simply adds one card to the visible development card total
                else % 6/25 development cards are progress cards
                    pcval = rand;
                    if pcval <= (1/3) % 2 of each type of progress cards
                        player.Hand{end + 1} = ProgCard(player,1); % 1 is roadbuilding card
                    elseif (pcval > (1/3)) && (pcval <= (2/3))
                        player.Hand{end + 1} = ProgCard(player,2); % 2 is monopoly card
                    else
                        player.Hand{end + 1} = ProgCard(player,3); % 3 is year of plenty card
                    end
                end
                player.CatanGame.Deck = player.CatanGame.Deck - 1;
                player.Hand{1}([2 4 5]) = player.Hand{1}([2 4 5]) - 1;
                helpdlg('Drew one development card!','Development Card')
            end
        end
        
        function playKnight(player,card)
            moveRobber(player.CatanGame.Board.CatanRobber)
            player.Hand{card}.Played = 1;
        end
        
        function checkKnight(player)
            use = 0;
            for n = 2:length(player.Hand)
                if strcmp(class(player.Hand{n}),'SoldierCard') && (player.Hand{n}.Played == 0)
                    use = 1;
                    break
                end
            end
            if use
                playKnight(player,n)
            else
                helpdlg('You have no Knight Cards to play','Knight')
            end
        end
        
        
        function trade(player)
           f = figure('Position',[350 200 600 300],'MenuBar','none');
           up = uipanel('Parent',f,'units','normalized','Position',[0 .5 1 .5]);
           ul = uipanel('Parent',f,'units','normalized','Position',[0 0 1 .5]);
           uptxt = uicontrol('Parent',up,'units','normalized','Position',...
               [0 .9 .15 .1],'style','text','string','Your request');
           lotxt = uicontrol('Parent',ul,'units','normalized','Position',...
               [0 .9 .1 .1],'style','text','string','Your offer');
           
           ax{1,1} = axes('parent',up,'units','normalized','position',...
               [.05 .1 .15 .8],'visible','off');
           ax{2,1} = axes('parent',up,'units','normalized','position',...
               [.225 .1 .15 .8],'visible','off');
           ax{3,1} = axes('parent',up,'units','normalized','position',...
               [.4 .1 .15 .8],'visible','off');
           ax{4,1} = axes('parent',up,'units','normalized','position',...
               [.575 .1 .15 .8],'visible','off');
           ax{5,1} = axes('parent',up,'units','normalized','position',...
               [.75 .1 .15 .8],'visible','off');
           
           ax{1,2} = axes('parent',ul,'units','normalized','position',...
               [.05 .1 .15 .8],'visible','off');
           ax{2,2} = axes('parent',ul,'units','normalized','position',...
               [.225 .1 .15 .8],'visible','off');
           ax{3,2} = axes('parent',ul,'units','normalized','position',...
               [.4 .1 .15 .8],'visible','off');
           ax{4,2} = axes('parent',ul,'units','normalized','position',...
               [.575 .1 .15 .8],'visible','off');
           ax{5,2} = axes('parent',ul,'units','normalized','position',...
               [.75 .1 .15 .8],'visible','off');
           
           pdown{1,1} = uicontrol('parent',up,'units','normalized','position',...
               [.1 .15 .05 .2],'style','edit','string',0);
           pdown{2,1} = uicontrol('parent',up,'units','normalized','position',...
               [.275 .15 .05 .2],'style','edit','string',0);
           pdown{3,1} = uicontrol('parent',up,'units','normalized','position',...
               [.45 .15 .05 .2],'style','edit','string',0);
           pdown{4,1} = uicontrol('parent',up,'units','normalized','position',...
               [.625 .15 .05 .2],'style','edit','string',0);
           pdown{5,1} = uicontrol('parent',up,'units','normalized','position',...
               [.8 .15 .05 .2],'style','edit','string',0);
           
           pdown{1,2} = uicontrol('parent',ul,'units','normalized','position',...
               [.1 .15 .05 .2],'style','edit','string',0);
           pdown{2,2} = uicontrol('parent',ul,'units','normalized','position',...
               [.275 .15 .05 .2],'style','edit','string',0);
           pdown{3,2} = uicontrol('parent',ul,'units','normalized','position',...
               [.45 .15 .05 .2],'style','edit','string',0);
           pdown{4,2} = uicontrol('parent',ul,'units','normalized','position',...
               [.625 .15 .05 .2],'style','edit','string',0);
           pdown{5,2} = uicontrol('parent',ul,'units','normalized','position',...
               [.8 .15 .05 .2],'style','edit','string',0);
           
           whodt = uicontrol('parent',f,'units','normalized','position',...
               [.92 .29 .06 .1],'style','edit');
           whotxt = uicontrol('parent',f,'units','normalized','position',...
               [.9 .39 .1 .06],'style','text','string','Player');
           
           rect{1,1} = rectangle('parent',ax{1,1},'facecolor',[.588 .086 .043]);
           rect{2,1} = rectangle('parent',ax{2,1},'facecolor','y');
           rect{3,1} = rectangle('parent',ax{3,1},'facecolor',[.133 .545 .133]);
           rect{4,1} = rectangle('parent',ax{4,1},'facecolor',[.5 .5 .5]);
           rect{5,1} = rectangle('parent',ax{5,1},'facecolor','g');
           
           rect{1,2} = rectangle('parent',ax{1,2},'facecolor',[.588 .086 .043]);
           rect{2,2} = rectangle('parent',ax{2,2},'facecolor','y');
           rect{3,2} = rectangle('parent',ax{3,2},'facecolor',[.133 .545 .133]);
           rect{4,2} = rectangle('parent',ax{4,2},'facecolor',[.5 .5 .5]);
           rect{5,2} = rectangle('parent',ax{5,2},'facecolor','g');
           

           offerbut = uicontrol('Parent',f,'units','normalized','Position',...
               [.9 .49 .1 .2],'style','pushbutton','string','Offer',...
               'Callback',{@offerTradeCallback,player,whodt,f,pdown});

               
        end
        
        function offerTrade(player,whodt,oldfig,pdown)
           
           stopTrade = 0;
           values = cell(size(pdown));
           
           for i = 1:5
               for j = 1:2
                   values{i,j} = str2num(get(pdown{i,j},'string'));
                   if isempty(values{i,j}) % if one of the boxes was not filled in
                       stopTrade = 1;
                   end
               end
           end
           
           for i = 1:5
               for j = 1:2
                   valueArray(j,i) = values{i,j};
               end
           end
           
           if isempty(get(whodt,'string')) || (stopTrade == 1)
               trader = player.CatanGame.Players{player.Index}; % this will trigger the first if statement in the next loop if no value was entered in whodt, or if one of the boxes did not have an entry
           else
               trader = player.CatanGame.Players{str2num(get(whodt,'string'))};
           end
           
            if trader.Index == player.Index % cannot trade with yourself
                helpdlg('You cannot trade with yourself','Trade')
            elseif ~isempty(find(player.Hand{1} < valueArray(2,:))) % does the trade initiator have enough resources for the trade
                helpdlg('You do not have enough resources','Trade')
            elseif ~isempty(find(trader.Hand{1} < valueArray(1,:))) % does the opponent have enough resources for the trade
                helpdlg('The opponent does not have enough resources','Trade')
            else
               close(oldfig)
               f = figure('Position',[350 200 600 300],'MenuBar','none');
               up = uipanel('Parent',f,'units','normalized','Position',[0 .5 1 .5]);
               ul = uipanel('Parent',f,'units','normalized','Position',[0 0 1 .5]);
               uptxt = uicontrol('Parent',up,'units','normalized','Position',...
                   [0 .9 .15 .1],'style','text','string','Your request');
               lotxt = uicontrol('Parent',ul,'units','normalized','Position',...
                   [0 .9 .1 .1],'style','text','string','Your offer');

               ax{1,1} = axes('parent',up,'units','normalized','position',...
                   [.05 .1 .15 .8],'visible','off');
               ax{2,1} = axes('parent',up,'units','normalized','position',...
                   [.225 .1 .15 .8],'visible','off');
               ax{3,1} = axes('parent',up,'units','normalized','position',...
                   [.4 .1 .15 .8],'visible','off');
               ax{4,1} = axes('parent',up,'units','normalized','position',...
                   [.575 .1 .15 .8],'visible','off');
               ax{5,1} = axes('parent',up,'units','normalized','position',...
                   [.75 .1 .15 .8],'visible','off');

               ax{1,2} = axes('parent',ul,'units','normalized','position',...
                   [.05 .1 .15 .8],'visible','off');
               ax{2,2} = axes('parent',ul,'units','normalized','position',...
                   [.225 .1 .15 .8],'visible','off');
               ax{3,2} = axes('parent',ul,'units','normalized','position',...
                   [.4 .1 .15 .8],'visible','off');
               ax{4,2} = axes('parent',ul,'units','normalized','position',...
                   [.575 .1 .15 .8],'visible','off');
               ax{5,2} = axes('parent',ul,'units','normalized','position',...
                   [.75 .1 .15 .8],'visible','off');

               ind{1,1} = uicontrol('parent',up,'units','normalized','position',...
                   [.1 .15 .05 .2],'style','text','string',values{1,2});
               ind{2,1} = uicontrol('parent',up,'units','normalized','position',...
                   [.275 .15 .05 .2],'style','text','string',values{2,2});
               ind{3,1} = uicontrol('parent',up,'units','normalized','position',...
                   [.45 .15 .05 .2],'style','text','string',values{3,2});
               ind{4,1} = uicontrol('parent',up,'units','normalized','position',...
                   [.625 .15 .05 .2],'style','text','string',values{4,2});
               ind{5,1} = uicontrol('parent',up,'units','normalized','position',...
                   [.8 .15 .05 .2],'style','text','string',values{5,2});

               ind{1,2} = uicontrol('parent',ul,'units','normalized','position',...
                   [.1 .15 .05 .2],'style','text','string',values{1,1});
               ind{2,2} = uicontrol('parent',ul,'units','normalized','position',...
                   [.275 .15 .05 .2],'style','text','string',values{2,1});
               ind{3,2} = uicontrol('parent',ul,'units','normalized','position',...
                   [.45 .15 .05 .2],'style','text','string',values{3,1});
               ind{4,2} = uicontrol('parent',ul,'units','normalized','position',...
                   [.625 .15 .05 .2],'style','text','string',values{4,1});
               ind{5,2} = uicontrol('parent',ul,'units','normalized','position',...
                   [.8 .15 .05 .2],'style','text','string',values{5,1});

               yesbut = uicontrol('Parent',f,'units','normalized','Position',...
                   [.9 .5 .1 .2],'style','pushbutton','string','Accept',...
                   'Callback',{@finishTradeCallback,player,trader,1,f,valueArray});
               nobut = uicontrol('Parent',f,'units','normalized','position',...
                   [.9 .3 .1 .2],'style','pushbutton','string','Decline',...
                   'Callback',{@finishTradeCallback,player,trader,0,f,valueArray});

               rect{1,1} = rectangle('parent',ax{1,1},'facecolor',[.588 .086 .043]);
               rect{2,1} = rectangle('parent',ax{2,1},'facecolor','y');
               rect{3,1} = rectangle('parent',ax{3,1},'facecolor',[.133 .545 .133]);
               rect{4,1} = rectangle('parent',ax{4,1},'facecolor',[.5 .5 .5]);
               rect{5,1} = rectangle('parent',ax{5,1},'facecolor','g');

               rect{1,2} = rectangle('parent',ax{1,2},'facecolor',[.588 .086 .043]);
               rect{2,2} = rectangle('parent',ax{2,2},'facecolor','y');
               rect{3,2} = rectangle('parent',ax{3,2},'facecolor',[.133 .545 .133]);
               rect{4,2} = rectangle('parent',ax{4,2},'facecolor',[.5 .5 .5]);
               rect{5,2} = rectangle('parent',ax{5,2},'facecolor','g');
            end
           
        end
        
        function finishTrade(player,trader,num,oldfig,valueArray)
            close(oldfig)
            if num == 1
                arrayto = valueArray(1,:);
                arrayfrom = valueArray(2,:);
                player.Hand{1} = player.Hand{1} + arrayto - arrayfrom;
                trader.Hand{1} = trader.Hand{1} + arrayfrom - arrayto;
                helpdlg('Trade successful','Trade')
            else
                helpdlg('Trade rejected','Trade')
            end
        end
        
        function bankTrade(player)
            f = figure('Position',[350 200 600 300],'MenuBar','none');
            up = uipanel('Parent',f,'units','normalized','Position',[0 .5 1 .5]);
            ul = uipanel('Parent',f,'units','normalized','Position',[0 0 1 .5]);
            uptxt = uicontrol('Parent',up,'units','normalized','Position',...
                [0 .9 .15 .1],'style','text','string','From bank');
            lotxt = uicontrol('Parent',ul,'units','normalized','Position',...
                [0 .9 .1 .1],'style','text','string','To bank');
            
            ax{1,1} = axes('parent',up,'units','normalized','position',...
                [.05 .1 .15 .8],'visible','off');
            ax{2,1} = axes('parent',up,'units','normalized','position',...
                [.225 .1 .15 .8],'visible','off');
            ax{3,1} = axes('parent',up,'units','normalized','position',...
                [.4 .1 .15 .8],'visible','off');
            ax{4,1} = axes('parent',up,'units','normalized','position',...
                [.575 .1 .15 .8],'visible','off');
            ax{5,1} = axes('parent',up,'units','normalized','position',...
                [.75 .1 .15 .8],'visible','off');
           
            ax{1,2} = axes('parent',ul,'units','normalized','position',...
                [.05 .1 .15 .8],'visible','off');
            ax{2,2} = axes('parent',ul,'units','normalized','position',...
                [.225 .1 .15 .8],'visible','off');
            ax{3,2} = axes('parent',ul,'units','normalized','position',...
                [.4 .1 .15 .8],'visible','off');
            ax{4,2} = axes('parent',ul,'units','normalized','position',...
                [.575 .1 .15 .8],'visible','off');
            ax{5,2} = axes('parent',ul,'units','normalized','position',...
                [.75 .1 .15 .8],'visible','off');
            
            rect{1,1} = rectangle('parent',ax{1,1},'facecolor',[.588 .086 .043]);
            rect{2,1} = rectangle('parent',ax{2,1},'facecolor','y');
            rect{3,1} = rectangle('parent',ax{3,1},'facecolor',[.133 .545 .133]);
            rect{4,1} = rectangle('parent',ax{4,1},'facecolor',[.5 .5 .5]);
            rect{5,1} = rectangle('parent',ax{5,1},'facecolor','g');
           
            rect{1,2} = rectangle('parent',ax{1,2},'facecolor',[.588 .086 .043]);
            rect{2,2} = rectangle('parent',ax{2,2},'facecolor','y');
            rect{3,2} = rectangle('parent',ax{3,2},'facecolor',[.133 .545 .133]);
            rect{4,2} = rectangle('parent',ax{4,2},'facecolor',[.5 .5 .5]);
            rect{5,2} = rectangle('parent',ax{5,2},'facecolor','g');
            
            pdown{1,1} = uicontrol('parent',up,'units','normalized','position',...
                [.1 .15 .05 .2],'style','edit','string',0);
            pdown{2,1} = uicontrol('parent',up,'units','normalized','position',...
                [.275 .15 .05 .2],'style','edit','string',0);
            pdown{3,1} = uicontrol('parent',up,'units','normalized','position',...
                [.45 .15 .05 .2],'style','edit','string',0);
            pdown{4,1} = uicontrol('parent',up,'units','normalized','position',...
                [.625 .15 .05 .2],'style','edit','string',0);
            pdown{5,1} = uicontrol('parent',up,'units','normalized','position',...
                [.8 .15 .05 .2],'style','edit','string',0);
           
            pdown{1,2} = uicontrol('parent',ul,'units','normalized','position',...
                [.1 .15 .05 .2],'style','edit','string',0);
            pdown{2,2} = uicontrol('parent',ul,'units','normalized','position',...
                [.275 .15 .05 .2],'style','edit','string',0);
            pdown{3,2} = uicontrol('parent',ul,'units','normalized','position',...
                [.45 .15 .05 .2],'style','edit','string',0);
            pdown{4,2} = uicontrol('parent',ul,'units','normalized','position',...
                [.625 .15 .05 .2],'style','edit','string',0);
            pdown{5,2} = uicontrol('parent',ul,'units','normalized','position',...
                [.8 .15 .05 .2],'style','edit','string',0);
            
            offerbut = uicontrol('Parent',f,'units','normalized','Position',...
                [.9 .4 .1 .2],'style','pushbutton','string','Trade',...
                'Callback',{@checkBankTradeCallback,player,f,pdown});
            
        end
        
        function checkBankTrade(player,oldFig,values)
            close(oldFig)
            stopTrade = 0;
            %values = cell(size(pdown));
           
            
            if stopTrade == 0
                for i = 1:5
                    for j = 1:2
                        valueArray(j,i) = values{i,j};
                    end
                end

                if sum(valueArray(2,:))/sum(valueArray(1,:)) ~= 4 % needs to be a 4:1 ratio, player cards to bank cards
                    stopTrade = 1;
                end

                if stopTrade == 0
                    finishBankTrade(player,valueArray)
                end
            end
            
        end    
        
        function finishBankTrade(player,valueArray)
            player.Hand{1} = player.Hand{1} + valueArray(1,:) - valueArray(2,:);
            helpdlg('The bank has accepted your trade','Trade Bank')
        end
        
        
        function stealResource(player,hObject,eventdata,num,oldfig) 
            close(oldfig)
            taken = 0;
            for n = 1:player.CatanGame.NumPlayers
                taken = player.CatanGame.Players{n}.Hand{1}(num) + taken;
                player.CatanGame.Players{n}.Hand{1}(num) = 0;
            end
            player.Hand{1}(num) = taken;
            helpdlg('Monopoly!')
        end
        
        function robResource(player,location)
            helpdlg('Robbed!','Robber')
        end
        
        function buildFirstSettlement(player)
          set(player.CatanBoard.Controls{2},'String',player.CatanGame.CurrentPlayerString);
          drawHexButtons(player.CatanGame.Board,-1)
        end
        
        function buildFirstRoad(player)
          drawHexButtons(player.CatanGame.Board,-2)
        end
        
        
        function checkSettlement(player)
            if sum((player.Hand{1}([1 2 3 5]) < 1)) > 0 % check amount of resources
                helpdlg('You do not have enough resources to build a settlement',...
                    'Settlement')
                player.CatanBoard.enableButtons;
            elseif player.RemainingStructures(1) == 0
                helpdlg('You have no more settlements to build','Settlement')
                player.CatanBoard.enableButtons;
            else
                drawHexButtons(player.CatanGame.Board,1);
            end
        end
        
        function checkCity(player)
            if (player.Hand{1}(2) < 2) || (player.Hand{1}(4) < 3) % check to see how many resources he has
                helpdlg('You do not have enough resources to build a city',...
                    'City')
                player.CatanBoard.enableButtons;
            elseif player.RemainingStructures(2) == 0
                helpdlg('You have no more cities to build','City')
                player.CatanBoard.enableButtons;
            else
                drawHexButtons(player.CatanGame.Board,2);
            end
            
        end
        
        function checkRoad(player)
            if (player.Hand{1}(1) < 1) || (player.Hand{1}(3) < 1) % if there are not enough resources
                helpdlg('You do not have enough resources to build a road',...
                    'Road')
                player.CatanBoard.enableButtons;
            elseif player.RemainingStructures(3) == 0
                helpdlg('You have no more roads to build','Road')
                player.CatanBoard.enableButtons;
            else
                drawHexButtons(player.CatanGame.Board,3)
            end
        end
        
    end
    
end