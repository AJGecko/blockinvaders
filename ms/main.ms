init = function()
  menu = 2
  entitys = []
  player = object
    lifes = 3
    x = 0
    y = -70
  end
  
  
  arrows = object
    arrows = []
    add = function(di, id, x ,y)
      local arrow = new arrow(di, id , x, y, this)
      this.arrows.push(arrow)
    end
    del = function(id)
      for obj in this.arrows
        if obj.id == id then
          this.arrows.removeElement(obj)
        end
      end
    end
    update = function()
      for obj in this.arrows
        obj.update()
      end
    end
    draw = function()
      for obj in this.arrows
        obj.draw()
      end
    end
  end
  
  arrow = class
    constructor = function(di , id, x, y , parent) // di for direction
      this.di = di
      this.id = id
      this.x = x
      this.y = y
      this.parent = parent
    end
    update = function()
      if di == "up" then
        this.y += 2
      end
      if di == "down" then
        this.y -= 2
      end
      if abs(this.x) > screen.width/2 then
        this.parent.del(this.id)
      end
      if abs(this.y) > screen.height/2 then
        this.parent.del(this.id)
      end
    end
    draw = function()
      if di == "up" then
        screen.setDrawRotation(0)
      end
      if di == "down" then
        screen.setDrawRotation(180)
      end
      
      screen.drawSprite( "arrow", this.x, this.y, 6,8)
      screen.setDrawRotation(0)
    end
    
    
  end
  
  
  enemy = class 
    constructor = function(x,y)
      this.x = x
      this.y = y
      this.rlock = 0
      this.llock = 0
      this.hitbox = []
    end
    draw = function()
      screen.drawSprite( "enemy", this.x, this.y, 28, 24)
    end
    update = function()
      hitbox = [this.x-12,this.x+12,this.y-12]
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
    if mouse.left and not playerarrowlock then
      arrows.add("up",random.nextInt(400), player.x, player.y+13)
      playerarrowlock = 1
    end
    if not mouse.left then
      playerarrowlock = 0
    end
    testenemy.update()
  end
  arrows.update()
end

draw = function()
  screen.clear("rgb(0,0,20)")
  arrows.draw()
  screen.drawSprite( "player", player.x, player.y, 24, 24 )
  testenemy.draw()
end

