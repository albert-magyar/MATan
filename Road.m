classdef Road < Structure
    
    properties
    end
    
    methods
        
        function obj = Road(player,hex,n)
            obj = obj@Structure(player);
            obj.Location = hex;
            player.RemainingStructures(3) = player.RemainingStructures(3) - 1;% subtract one from roads
            player.Hand{1}([1 3]) = player.Hand{1}([1 3]) - 1; % take away resources
            hex.drawRoad(player.Index,n);
        end
        
    end
    
end