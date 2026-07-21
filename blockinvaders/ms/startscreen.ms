startdraw = function()
  screen.drawText("Block Invaders",0,30,40,"rgb(0,85,255)")
  screen.fillRect(0,-30,90,25,buttoncolor)
  screen.drawText("Start",0,-30,20,"rgb(227,236,255)")
  screen.drawText("Highscore: " + highscore,0,-80,15,"rgb(227,236,255)")
  screen.drawText("A/D or Arrows = Move | Left Click = Shoot | Space/Right Click = Shield", 0, -5, 8, "#aaa")
  screen.drawText("Defeat as many enemies as possible!", 0, -60, 14, "#fff")

end

startupdate = function()
  if mouse.x < 45 and mouse.x > -45 and mouse.y < -15 and mouse.y > -45 then
    buttoncolor ="rgb(0,131,197)"
    if mouse.left then
      menu = 2
      player.lifes = 3
      points = 0
      startprotect = 1
    end
  else
    buttoncolor = "rgb(0,170,255)"
  end
end