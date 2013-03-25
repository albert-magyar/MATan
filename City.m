classdef City < Settlement
    
    properties
    end
    
    methods
        function obj = City(player,hex,n,settlement) % builds the city
            obj = obj@Settlement(player,hex,n);
            
            obj.Value = 2;
            settlement.removeSettlement;
            delete(obj.Drawing);
            hex.upgradeSettlement(player.Index,n,settlement.Drawing);

            player.RemainingStructures(2) = player.RemainingStructures(2) - 1; % subtract one from cities
            player.Hand{1}(2) = player.Hand{1}(2) - 2;
            player.Hand{1}(4) = player.Hand{1}(4) - 3; % subtract two grain, three ore
            player.Points = player.Points + 1; % add one victory point in addition to the one already added from the existing settlement
            end
        end
        
end
    
    
