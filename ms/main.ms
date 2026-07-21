init = function()
  menu = 2
  player = object
    lifes = 3
    x = 0
    y = -70
  end
  
  enemy = class 
    constructor = function(x,y)
      this.x = x
      this.y = y
      this.rlock = 0
      this.llock = 0
    end
    draw = function()
      screen.drawSprite( "enemy", this.x, this.y, 28, 24)
    end
    update = function()
      do
        if this.x < player.x and this.rlock != 1 then
          if abs(player.x - this.x) > 5 then
            this.x += 5
          elsif player.x > this.x then
            this.x += abs(player.x - this.x)
          end
          this.rlock = 1
          sleep(random.nextInt(600)+400)
          this.rlock = 0
        end
        if this.x > player.x and this.llock != 1 then
          if abs(player.x - this.x) > 5 then
            this.x -= 5
          elsif player.x > this.x then
            this.x -= (player.x - this.x)
          end
          this.llock = 1
          sleep(random.nextInt(600)+400)
          this.llock = 0
        end
      end
    end
    
  end
  
  testenemy = new enemy(20,30)
  
  
end

update = function()
  if menu == 1 then
    
    
  end
  if menu == 2 then
    if keyboard.RIGHT and player.x < screen.width/2 - 14 then
      player.x += 2
    end
    if keyboard.LEFT and player.x > -screen.width/2 + 14 then
      player.x -= 2
    end
    testenemy.update()
  end
  
end

draw = function()
  screen.clear("rgb(0,0,20)")
  screen.drawSprite( "player", player.x, player.y, 24, 24 )
  testenemy.draw()
end