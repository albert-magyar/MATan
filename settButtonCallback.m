function settButtonCallback(hObject,eventdata,game)
  b = game.Board;
  b.disableButtons;
  p = game.CurrentPlayer;
  p.checkSettlement();
end