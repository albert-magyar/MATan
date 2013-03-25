classdef Robber < handle
    
    properties
        CurrentSpace
        CatanBoard
        Drawing
    end
    
    methods
        function obj = Robber(location,board)
            obj.CurrentSpace = location;
            obj.CatanBoard = board;
            location.Robber = obj;
            location.drawRobber()
        end
        
        function moveRobber(robber) % need to remove drawing of robber
            if ~isempty(robber.Drawing)
              delete(robber.Drawing(1));
              delete(robber.Drawing(2));
            end
            robber.CurrentSpace.Type = robber.CurrentSpace.Type(1:end-1);
            helpdlg('Select a hex to place the robber','Robber')
            drawHexButtons(robber.CatanBoard,4)
        end
        
        function placeRobber(robber,location)
            for n = 1:19
              delete(robber.CatanBoard.HexButtons{n})
            end
            robber.CurrentSpace = location;
            robber.CurrentSpace.Type = strcat(robber.CurrentSpace.Type,'~');
            robber.drawRobber(location)
            % robResource(player,location)
        end
        
        function drawRobber(robber,location)
          r = rectangle('Position',[location.Position-.030,.06,.06],'Curvature',[1,1],...
            'Parent',location.Board.BoardAxes,'FaceColor',[.5 .5 .5],'Tag','hello');
          t = text('Position',(location.Position-[0.004 0]),...
            'Parent',location.Board.BoardAxes,'BackgroundColor',[.5 .5 .5],'Color',[1 1 1],'String',num2str(location.Token(2)));
          robber.Drawing = [r t];
        end
          
    end
    
end