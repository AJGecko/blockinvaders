init = function()
  menu = 1
  startprotect = 1
  highscore = storage.get("highscore")
  player = object
    lifes = 3
    x = 0
    y = -60
    hitbox = []
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
      if this.di == "up" then
        this.y += 2
      end
      if this.di == "down" then
        this.y -= 2
      end
      if abs(this.x) > screen.width/2 then
        this.parent.del(this.id)
      end
      if abs(this.y) > screen.height/2 then
        this.parent.del(this.id)
      end
      for obj in enemys.enemys
        if obj.hitbox[0] < this.x and obj.hitbox[1] > this.x and this.y > obj.hitbox[2] and this.y < obj.hitbox[3] and this.di == "up" then 
          obj.lifes -= 1
          global.points += 1
          this.parent.del(this.id)
        end
      end
      if player.hitbox[0] < this.x and player.hitbox[1] > this.x and this.y > player.hitbox[2] and this.y < player.hitbox[3] and this.di == "down" then 
          if not protect and not wprotect then
            player.lifes -= 1
          end
          this.parent.del(this.id)
        end
      end
    draw = function()
      if this.di == "up" then
        screen.setDrawRotation(0)
        style = "_p"
      end
      if this.di == "down" then
        screen.setDrawRotation(180)
        style = "_e"
      end
      
      screen.drawSprite( "arrow"+ style , this.x, this.y, 6,8)
      screen.setDrawRotation(0)
    end
    
  end
  
  enemys = object
    enemys = []
    add = function(x ,y ,id)
      local enemy = new enemy(x,y,id,this)
      this.enemys.push(enemy)
    end
    del = function(id)
      for obj in this.enemys
        if obj.id == id then
          this.enemys.removeElement(obj)
        end
      end
    end
    update = function()
      for obj in this.enemys
        obj.update()
      end
    end
    draw = function()
      for obj in this.enemys
        obj.draw()
      end
    end
  end
  
  enemy = class 
    constructor = function(x,y,id,parent)
      this.x = x
      this.y = y
      this.rlock = 0
      this.llock = 0
      this.arlock = 0
      this.hitbox = []
      this.lifes = 1
      this.parent = parent
      this.id = id
    end
    draw = function()
      screen.drawSprite( "enemy", this.x, this.y, 28, 24)
    end
    update = function()
      this.hitbox = [this.x-14,this.x+14,this.y-12,this.y+12]
      if this.lifes <= 0 then
        this.parent.del(this.id)
      end
      
      local movelock = 0
      for obj in enemys.enemys
        if obj.id != this.id and obj.hitbox then 
          if abs(obj.y - this.y) < 15 then
            if this.x < player.x and obj.x > this.x and (obj.x - this.x) < 40 then
              movelock = 1
            end
            if this.x > player.x and obj.x < this.x and (this.x - obj.x) < 40 then
              movelock = 1
            end
          end
        end
      end
      
      if not movelock then
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
        do
          if abs(player.x - this.x) < 10 and this.arlock != 1 then
            arrows.add("down",random.nextInt(400), this.x, this.y-13)
            this.arlock = 1
            sleep(random.nextInt(7000)+1000)
            this.arlock = 0
          end
        end
      end
    end
    
  end
  
  
end

update = function()
  if menu == 1 then
    startupdate()
    
  end
  if menu == 2 then
    if keyboard.RIGHT and player.x < screen.width/2 - 14 and not protect then
      player.x += 2
    end
    if keyboard.LEFT and player.x > -screen.width/2 + 14 and not protect then
      player.x -= 2
    end
    if mouse.left and not playerarrowlock and not protect then
      arrows.add("up",random.nextInt(400), player.x, player.y+13)
      playerarrowlock = 1
    end
    if not mouse.left then
      playerarrowlock = 0
    end
    
    if mouse.right or keyboard.SPACE then
      protect = 1
    else
      protect = 0
    end
    if wprotect then
      player.hitbox = [player.x-(14+12),player.x+(14+12),player.y-(12+12),player.y+(14+12)]
    else
      player.hitbox = [player.x-(14+protect*12),player.x+(14+protect*12),player.y-(12+protect*12),player.y+(14+protect*12)]
    end
    enemys.update()
    arrows.update()
    
    if enemys.enemys.length == 0 then
      enemys.add(0,20,random.nextInt(400)+400)
      enemys.add(-40,20,random.nextInt(400)+400)
      enemys.add(40,20,random.nextInt(400)+400)
      enemys.add(80,20,random.nextInt(400)+400)
      enemys.add(-80,20,random.nextInt(400)+400)
      enemys.add(-120,20,random.nextInt(400)+400)
      enemys.add(120,20,random.nextInt(400)+400)
      
      enemys.add(0,70,random.nextInt(400)+400)
      enemys.add(-40,70,random.nextInt(400)+400)
      enemys.add(40,70,random.nextInt(400)+400)
      enemys.add(80,70,random.nextInt(400)+400)
      enemys.add(-80,70,random.nextInt(400)+400)
      enemys.add(-120,70,random.nextInt(400)+400)
      enemys.add(120,70,random.nextInt(400)+400)
    end
    
    if startprotect - 0.0125 < 0 then 
      
    else  
      startprotect -= 0.0125
    end
    if startprotect > 0.01 then
      wprotect = 1
    else
      wprotect = 0
    end
    
    if player.lifes <= 0 then
      if highscore < points then
        highscore = points
        storage.set("highscore",highscore)
      end
      menu = 3 
    end
    
  end
  
  if menu == 3 then
    if mouse.x < 45 and mouse.x > -45 and mouse.y < -15 and mouse.y > -45 then
      buttoncolor2 ="rgb(0,131,197)"
      if mouse.left then
        menu = 1
        mouse.left = 0
      end
    else
      buttoncolor2 = "rgb(0,170,255)"
    end
  end
end

draw = function()
  screen.clear("rgb(0,0,40)")
  if menu == 1 then
    startdraw()
  end
  if menu == 2 then
    arrows.draw()
    screen.drawSprite( "player", player.x, player.y, 24, 24 )
    if protect == 1 then
      screen.drawSprite( "protect", player.x, player.y, 48, 48  )
    end
    if wprotect == 1 then
      screen.setAlpha(startprotect)
      screen.drawSprite( "whiteprotect", player.x, player.y, 48, 48)
      screen.setAlpha(1)
    end
    enemys.draw()
    
    screen.drawText("Points: " + points,80,-85,20,"#fff")
    
    if player.lifes == 3 then
      screen.drawSprite( "heart", -90, -85, 13*2, 12*2)
      screen.drawSprite( "heart", -118, -85, 13*2, 12*2)
      screen.drawSprite( "heart", -62, -85, 13*2, 12*2)
    elsif player.lifes == 2 then
      screen.drawSprite( "heart", -90, -85, 13*2, 12*2)
      screen.drawSprite( "heart", -118, -85, 13*2, 12*2)
    elsif player.lifes == 1 then
      screen.drawSprite( "heart", -118, -85, 13*2, 12*2)
    end
  end
  
  if menu == 3 then
    screen.drawText("Game Over!",0,0,20,"#fff")
    screen.fillRect(0,-30,90,25,buttoncolor2)
    screen.drawText("Restart",0,-30,20,"rgb(227,236,255)")
  end
end







