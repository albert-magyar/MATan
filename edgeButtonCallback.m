function edgeButtonCallback(hObject,eventdata,hex,n,num)
  good = hex.checkEdge(n);
  
  for h = 1:6
      delete(hex.EdgeButtons{h})
  end
  
  if num == -2
    if good == 1
      hex.Board.Game.CurrentPlayer.Structures{2}{end+1} = Road(hex.Board.Game.CurrentPlayer,hex,n);
      next = mod(hex.Board.Game.CurrentPlayer.Index,hex.Board.Game.NumPlayers) + 1;
      prev = mod(hex.Board.Game.CurrentPlayer.Index-2,hex.Board.Game.NumPlayers) + 1;
      if (hex.Board.Game.CurrentPlayer.Points == 1) && (hex.Board.Game.Players{next}.Points == 0)
        hex.Board.Game.CurrentPlayer = hex.Board.Game.Players{next};
        hex.Board.Game.CurrentPlayer.buildFirstSettlement();
      elseif (hex.Board.Game.CurrentPlayer.Points == 1) && (hex.Board.Game.Players{next}.Points == 1)
        hex.Board.Game.CurrentPlayer = hex.Board.Game.CurrentPlayer;
        hex.Board.Game.CurrentPlayer.buildFirstSettlement();
      elseif (hex.Board.Game.CurrentPlayer.Points == 2) && (hex.Board.Game.Players{prev}.Points == 1)
        hex.Board.Game.CurrentPlayer = hex.Board.Game.Players{prev};
        hex.Board.Game.CurrentPlayer.buildFirstSettlement();
      elseif (hex.Board.Game.CurrentPlayer.Points == 2) && (hex.Board.Game.Players{prev}.Points == 2) && (hex.Board.Game.Players{next}.Points == 2)
        hex.Board.enableButtons;
        hex.Board.Game.beginTurn(hex.Board.Game.CurrentPlayer)
      end
      
    else
      helpdlg('Cannot build on that edge!','Error');
      hex.Board.Game.CurrentPlayer.buildFirstRoad();
      
    end
  elseif num == 3
    if good == 1
      hex.Board.Game.CurrentPlayer.Structures{2}{end+1} = Road(hex.Board.Game.CurrentPlayer,hex,n);
    end
    hex.Board.enableButtons;
  end
end