classdef CatanHex < handle
  
  properties
    % These values do not change for objects of class CatanHex
    BoardPositionMatrix = [.40 .24019; .50 .24019; .60 .24019; .65 .37010;...
      .70 .50000; .65 .62990; .60 .75981; .50 .75981; .40 .75981; .35 .62990;...
      .30 .50000; .35 .37010; .45 .37010; .55 .37010; .60 .50000; .55 .62990;...
      .45 .62990; .40 .50000; .50 .50000];
    
    OceanPositionMatrix = [.35 .11028; .45 .11028; .55 .11028; .65 .11028;...
      .70 .24019; .75 .37010; .80 .50000; .75 .62990; .70 .75981; .65 .88972;...
      .55 .88972; .45 .88972; .35 .88972; .30 .75981; .25 .62990; .20 .50000;...
      .25 .37010; .30 .24019]
    
    TokenMatrix = [5 2 6 3 8 10 9 12 11 4 8 10 9 4 5 6 3 11
      4 1 5 2 5 3 4 1 2 3 5 3 4 3 4 5 2 2];
    
    HexCorners = [-.086603 0; -.043301 .05; .043301 .05; .086603 0; .043301 -.05; -.043301 -.05];
  end
  
  properties
    TopEdge
    TopLeftEdge
    TopRightEdge
    BottomEdge
    BottomLeftEdge
    BottomRightEdge
  end
  
  properties
    Board
    Token % Token is a 1x3 double array of a letter (ASCII int), number, and number of dots
    Type % Type is a string that describes the resource type
    Position % Position is the relative coordinates of the center of the hexagon.
    Patch
    Robber
    VertexButtons
    EdgeButtons
  end
  
  properties
    NextHex
    PrevHex
  end
  
  methods
    function obj = CatanHex(number,letter,type,board)
      obj.Board = board;
      obj.HexCorners(:,2) = obj.HexCorners(:,2).*1.4;
      
      if strcmp(type,'ocean')
        obj.OceanPositionMatrix(:,1) = obj.OceanPositionMatrix(:,1) - 0.5;
        obj.OceanPositionMatrix(:,1) = obj.OceanPositionMatrix(:,1).*1.4;
        obj.OceanPositionMatrix(:,1) = obj.OceanPositionMatrix(:,1) + 0.5;
        obj.Position = obj.OceanPositionMatrix(number-19,1:2);
        obj.Token = [0 0 0];
      else
        obj.BoardPositionMatrix(:,1) = obj.BoardPositionMatrix(:,1) - 0.5;
        obj.BoardPositionMatrix(:,1) = obj.BoardPositionMatrix(:,1).*1.4;
        obj.BoardPositionMatrix(:,1) = obj.BoardPositionMatrix(:,1) + 0.5;
        obj.Position = obj.BoardPositionMatrix(number,1:2);
        if ~strcmp(type,'desert')
          q = double(letter);
          num = obj.TokenMatrix(1,q-64);
          dots = obj.TokenMatrix(2,q-64);
          obj.Token = [q num dots];
        else
          obj.Token = [0 0 0];
        end
      end
      obj.Type = type;
      obj.HexCorners = [obj.HexCorners(1:6,2)+obj.Position(1) obj.HexCorners(1:6,1)+obj.Position(2)];
      
    end
    
    function draw(obj)
      switch obj.Type
        case 'wood'
          c = [.133 .545 .133];
        case 'wheat'
          c = 'y';
        case 'sheep'
          c = 'g';
        case 'ore'
          c = [.5 .5 .5];
        case 'brick'
          c = [.588 .086 .043];
        case 'desert'
          c = [.933 .910 .667];
        case 'ocean'
          c = 'b';
        otherwise
          error('Untyped hexagons!')
      end
      obj.Patch = patch(obj.HexCorners(1:6,1),obj.HexCorners(1:6,2),c,...
        'Parent',obj.Board.BoardAxes);
    end
    
    function token = drawToken(obj,letter)
      if obj.Token(2) ~=0
      r = rectangle('Position',[obj.Position-.030,.06,.06],'Curvature',[1,1],...
        'Parent',obj.Board.BoardAxes,'FaceColor',[.933 .910 .667],'Tag','hello');
      t = text('Position',(obj.Position-[0.004 0]),...
        'Parent',obj.Board.BoardAxes,'BackgroundColor',[.933 .910 .667],'String',num2str(obj.Token(2)));
      uistack(t,'top');
      end
    end
    
    function settle = drawSettlement(obj,player,vertex)
      PatchArray = [ .0000  .0180
                    -.0126  .0045
                    -.0126 -.0120
                     .0126 -.0120
                     .0126  .0045];
      PatchArrayShift = obj.HexCorners(vertex,:);
      PatchArray = [PatchArray(:,1)+PatchArrayShift(1) PatchArray(:,2)+PatchArrayShift(2)];
      switch player
        case 1
          color = 'r';
        case 2
          color = 'b';
        case 3
          color = [1 0.498 0];
        case 4
          color = 'w';
      end
      settle = patch(PatchArray(:,1),PatchArray(:,2),color,'Parent',obj.Board.BoardAxes);
    end
    
    function city = upgradeSettlement(obj,player,vertex,settlement)
      
      PatchArray = [ .0091  .0200
                     .0000  .0100
                     .0000  .0000
                    -.0182  .0000
                    -.0182 -.0200
                     .0182 -.0200
                     .0182  .0100];
      PatchArrayShift = obj.HexCorners(vertex,:);
      PatchArray = [PatchArray(:,1)+PatchArrayShift(1) PatchArray(:,2)+PatchArrayShift(2)];
      switch player
        case 1
          color = 'r';
        case 2
          color = 'b';
        case 3
          color = [1 0.498 0];
        case 4
          color = 'w';
      end
      delete(settlement);
      city = patch(PatchArray(:,1),PatchArray(:,2),color,'Parent',obj.Board.BoardAxes);
    end
    
    function road = drawRoad(obj,player,edge)
      switch player
        case 1
          color = 'r';
        case 2
          color = 'b';
        case 3
          color = [1 0.498 0];
        case 4
          color = 'w';
      end
      
      PatchArray = {[.0366,.01654;-.0326,-.02347;-.0366,-.01654;.0326,.02347],...
        [.004,.040;.004,-.040;-.004,-.040;-.004,.040],...
        [-.0366,.01654;.0326,-.02347;.0366,-.01654;-.0326,.02347]};
      
      q = mod(edge-1,3)+1;
      
      PatchOrigin = (obj.HexCorners(edge,:) + obj.HexCorners(mod(edge,6)+1,:))/2;
      PatchArray{q} = [PatchArray{q}(:,1)+PatchOrigin(1) PatchArray{q}(:,2)+PatchOrigin(2)];
      road = patch(PatchArray{q}(:,1),PatchArray{q}(:,2),color,'Parent',obj.Board.BoardAxes);
    end
    
    function drawVertexButtons(hex,num)
        for n = 1:19
          delete(hex.Board.HexButtons{n})
        end
         
        for n = 1:6
            hex.VertexButtons{n} = uicontrol('Parent',hex.Board.MiddlePanel,...
                'Units','normalized','Position',[(hex.HexCorners(n,:) - .02) .04 .04],...
                'Callback',{@vertexButtonCallback,hex,n,num});
        end
    end
    
    function drawEdgeButtons(hex,num)
        for n = 1:19
          delete(hex.Board.HexButtons{n})
        end
        
        for n = 1:6
            hex.EdgeButtons{n} = uicontrol('Parent',hex.Board.MiddlePanel,...
                'Units','normalized','Position',[((hex.HexCorners(n,:) + hex.HexCorners(mod(n,6) + 1,:))/2) - .02 .04 .04],...
                'Callback',{@edgeButtonCallback,hex,n,num});
        end
    end
    
    function good = checkVertex(hex,vertex)
        good = 1;
    end
    
    function good = checkEdge(hex,edge)
        good = 1;
    end
    
    function drawRobber(hex)
        
    end
    
  end
  
  
end