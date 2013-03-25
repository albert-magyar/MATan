function hexButtonCallback(hObject,eventdata,board,n,num)
refresh
switch num
  case -2
    board.Hexes{n}.drawEdgeButtons(num)
  case -1
    board.Hexes{n}.drawVertexButtons(num)
  case 1
    board.Hexes{n}.drawVertexButtons(num)
  case 2
    board.Hexes{n}.drawVertexButtons(num)
  case 3
    board.Hexes{n}.drawEdgeButtons(num)
  case 4
    board.CatanRobber.placeRobber(board.Hexes{n})
end