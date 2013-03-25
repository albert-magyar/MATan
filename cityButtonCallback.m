function cityButtonCallback(hObject,eventdata,game)
  b = game.Board;
  b.disableButtons;
  p = game.CurrentPlayer;
  p.checkCity();
end