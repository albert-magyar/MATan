function vertexButtonCallback(hObject,eventdata,hex,n,num)
  
  for h = 1:6
      delete(hex.VertexButtons{h})
  end
  
  if num == -1
    good = hex.checkVertex(n);
    if good == 1
      hex.Board.Game.CurrentPlayer.Structures{1}{end+1} = Settlement(hex.Board.Game.CurrentPlayer,hex,n);
      hex.Board.Game.CurrentPlayer.buildFirstRoad();
    else
      helpdlg('Cannot build on that vertex!','Error');
      hex.Board.Game.CurrentPlayer.buildFirstSettlement();
    end
  elseif num == 1
    good = hex.checkVertex(n);
    if good == 1
      hex.Board.Game.CurrentPlayer.Structures{1}{end+1} = Settlement(hex.Board.Game.CurrentPlayer,hex,n);
    else
      helpdlg('Cannot build on that vertex!','Error');
    end
    hex.Board.enableButtons;
  elseif num == 2
    sett = {};
    ns = 0;
    for i = 1:length(hex.Board.Game.CurrentPlayer.Structures{1})
      s = hex.Board.Game.CurrentPlayer.Structures{1}{i};
      if s.Value == 1
        for j = 1:3
          s.Location{j,1}.Position
          s.Location{j,2}
          if (s.Location{j,1}.Position == hex.Position) & (s.Location{j,2} == n)
            sett = s;
            ns = i;
          end
        end
      end
    end
    if ~isempty(sett)
      hex.Board.Game.CurrentPlayer.Structures{1}{ns} = City(hex.Board.Game.CurrentPlayer,hex,n,hex.Board.Game.CurrentPlayer.Structures{1}{ns});
    else
      helpdlg('Cannot build on that vertex!','Error');
    end
    hex.Board.enableButtons;
  end
  
end