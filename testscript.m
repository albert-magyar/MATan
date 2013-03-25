close all

clear

h = CatanBoard

h.Hexes{1}.drawRoad(1,1)

h.Hexes{1}.drawRoad(1,2)

qq = h.Hexes{1}.drawSettlement(1,3)

h.Hexes{1}.upgradeSettlement(1,3,qq)

h.Hexes{2}.drawRoad(1,4)

h.Hexes{2}.drawRoad(1,3)

qq = h.Hexes{2}.drawSettlement(1,3)
