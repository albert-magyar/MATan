function roadButtonCallback(hObject,eventdata,game)
  b = game.Board;
  b.disableButtons;
  p = game.CurrentPlayer;
  p.checkRoad();
end