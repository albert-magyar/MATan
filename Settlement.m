classdef Settlement < Structure
    
    properties
        OrderBuilt;
        Value = 1;
        Vertex;
        Drawing;
    end
    
    methods
        function obj = Settlement(player,hex,n)
            obj = obj@Structure(player);
            obj.Location = {hex, n};
            obj.Vertex = n;
            % ADD CODE TO FIND COORDINATES
            player.RemainingStructures(1) = player.RemainingStructures(1) - 1; % subtract one from settlements
            obj.OrderBuilt = 5 - player.RemainingStructures(1);
            player.Hand{1}([1 2 3 5]) = player.Hand{1}([1 2 3 5]) - 1; % subtract resources
            player.Points = player.Points + 1; % add a victory point for a built settlement
            obj.Drawing = hex.drawSettlement(player.Index,n);
            obj.Location = obj.findAdjacentHexes;
        end
                
        function removeSettlement(settlement)
            settlement.Owner.RemainingStructures(1) = settlement.Owner.RemainingStructures(1) + 1; % add one to settlements
            settlement.Location = [];
        end
        
        function hexes = findAdjacentHexes(settlement)
          hs = [.07000 .12991; .14000 .00000];
          v = settlement.Location{2};
          x = settlement.Location{1}.Position(1);
          y = settlement.Location{1}.Position(2);
          hexes = cell(3,2);
          hexes{1,1} = settlement.Location{1};
          hexes{1,2} = v;
          switch v
            case 1
              centers = [x-hs(1,1),y-hs(1,2);x+hs(1,1),y-hs(1,2)];
              vs = [3 5];
            case 2
              centers = [x+hs(1,1),y-hs(1,2);x+hs(2,1),y+hs(2,2)];
              vs = [4 6];
            case 3
              centers = [x+hs(1,1),y+hs(1,2);x+hs(2,1),y+hs(2,2)];
              vs = [1 5];
            case 4
              centers = [x-hs(1,1),y+hs(1,2);x+hs(1,1),y+hs(1,2)];
              vs = [2 6];
            case 5
              centers = [x-hs(1,1),y+hs(1,2);x-hs(2,1),y+hs(2,2)];
              vs = [1 3];
            case 6
              centers = [x-hs(1,1),y-hs(1,2);x-hs(2,1),y+hs(2,2)];
              vs = [4 2];
          end
          
          for i = 1:37
            c = settlement.Owner.CatanBoard.Hexes{i}.Position;
            if norm(c-centers(1,:)) < 0.01
              hexes{2,1} = settlement.Owner.CatanBoard.Hexes{i};
              hexes{2,2} = vs(1);
            end
          end
          
          for i = 1:37
            c = settlement.Owner.CatanBoard.Hexes{i}.Position;
            if norm(c-centers(2,:)) < 0.01
              hexes{3,1} = settlement.Owner.CatanBoard.Hexes{i};
              hexes{3,2} = vs(2);
            end
          end
              
          
        end
    end
    
    properties (Dependent)
      Collect;
    end
    
    methods 
        function col = get.Collect(settlement)
          col = cell(3,2);
          for n = 1:3
            col{n,1} = settlement.Location{n,1}.Token(2);
            col{n,2} = settlement.Location{n,1}.Type;
          end
        end
    end
end