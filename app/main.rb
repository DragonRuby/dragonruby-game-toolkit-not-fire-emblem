# Size of board is always 1280x720

def tick args
  size = 64

  # * FIXME - ~Numeric#times~ over ~while~ loops.
  # Don't use ~while~ loops in Ruby. Use ~Numeric#times~
  # #+begin_src ruby
  #   12.times do |i|
  #     21.times do |j|
  #     end
  #   end
  # #+end_src
  # Draw a checkerboard as a placeholder game board
  i = 0
  j = 0
  while i < 12 do
    while j < 21 do
      args.outputs.solids << [(j*size), (i*size), size, size, 0, 0, ((i+j) % 2 == 0) ? 255 : 0]
      j += 1
    end
    j = 0
    i += 1
  end

  args.state.player.x ||= 0
  args.state.player.y ||= 0
  args.state.player.w ||= 64
  args.state.player.h ||= 64
  args.state.player.direction ||= 1

  # Get the keyboard input and set player properties

  # * FIXME: ~Keyboard#right_left~
  # There is ~args.inputs.keyboard.right_left~ that returns -1, 0, 1.
  # Take a look at the dueling starships sample app.

  # menu overlay
  if args.inputs.keyboard.key_down.enter
    args.state.menu_overlay = [1080, 0, 200, 720, 100, 0,   0, 250]
  end
  # display menu overlay
  if args.state.menu_overlay
       
    args.outputs.solids << args.state.menu_overlay

    args.state.move_button ||= new_button :move, 1081, 650, "Move"

    # render button generically using `args.outputs.primitives`
    args.outputs.primitives << args.state.move_button[:primitives]

    # check if the click occurred using the button_clicked? helper method
    if button_clicked? args, args.state.move_button
      args.gtk.notify! "Move button was clicked!"
    end
    
    args.state.attack_button ||= new_button :attack, 1081, 600, "Attack"

    # render button generically using `args.outputs.primitives`
    args.outputs.primitives << args.state.attack_button[:primitives]

    # check if the click occurred using the button_clicked? helper method
    if button_clicked? args, args.state.attack_button
      args.gtk.notify! "Attack button was clicked!"
    end

    args.state.items_button ||= new_button :items, 1081, 550, "Items"

    # render button generically using `args.outputs.primitives`
    args.outputs.primitives << args.state.items_button[:primitives]

   
    
    # check if the click occurred using the button_clicked? helper method
    if button_clicked? args, args.state.items_button
      
        args.state.itemMenu_overlay = [880, 0, 200, 720, 150, 0,   0, 250]
        args.gtk.notify! "Items button was clicked!"
        
    end

    if args.state.itemMenu_overlay
      args.outputs.solids << args.state.itemMenu_overlay

      args.outputs.labels << [960, 700, "Items"]
      # create items
      args.state.potion_button ||= new_button :potion, 881, 600, "Potion"

      # render button generically using `args.outputs.primitives`
      args.outputs.primitives << args.state.potion_button[:primitives]

      # check if the click occurred using the button_clicked? helper method
      if button_clicked? args, args.state.potion_button
        args.gtk.notify! "Potion Used!"
      end

      args.state.elixer_button ||= new_button :potion, 881, 550, "Elixer"

      # render button generically using `args.outputs.primitives`
      args.outputs.primitives << args.state.elixer_button[:primitives]

      # check if the click occurred using the button_clicked? helper method
      if button_clicked? args, args.state.elixer_button
        args.gtk.notify! "Elixer Used!"
      end
    end

    args.state.wait_button ||= new_button :wait, 1081, 500, "Wait"

    # render button generically using `args.outputs.primitives`
    args.outputs.primitives << args.state.wait_button[:primitives]

    # check if the click occurred using the button_clicked? helper method
    if button_clicked? args, args.state.wait_button
      args.gtk.notify! "Wait button was clicked!"
    end
    
  end
  
  
  if args.inputs.keyboard.right
    args.state.player.direction = 1
    if ((args.state.tick_count - args.state.player.started_running_at) % 30) == 0
      args.state.player.x += size
    end
  elsif args.inputs.keyboard.left
    args.state.player.direction = -1
    if ((args.state.tick_count - args.state.player.started_running_at) % 30) == 0
      args.state.player.x -= size
    end
  end

  if args.inputs.keyboard.key_down.right
    args.state.player.direction = 1
    args.state.player.started_running_at = args.state.tick_count
    args.state.player.x += size
  elsif args.inputs.keyboard.key_down.left
    args.state.player.direction = -1
    args.state.player.started_running_at = args.state.tick_count
    args.state.player.x -= size
  end

  # * FIXME: ~Keyboard#up_down~
  # There is ~args.inputs.keyboard.up_down~ that returns -1, 0, 1. Take a look at the
  # dueling starships sample app.
  if args.inputs.keyboard.up
    args.state.player.direction = 1
    if ((args.state.tick_count - args.state.player.started_running_at) % 30) == 0
      args.state.player.y += size
    end
  elsif args.inputs.keyboard.down
    args.state.player.direction = -1
    if ((args.state.tick_count - args.state.player.started_running_at) % 30) == 0
      args.state.player.y -= size
    end
  end

  if args.inputs.keyboard.key_down.up
    args.state.player.direction = 1
    args.state.player.started_running_at = args.state.tick_count
    args.state.player.y += size
  elsif args.inputs.keyboard.key_down.down
    args.state.player.direction = -1
    args.state.player.started_running_at = args.state.tick_count
    args.state.player.y -= size
  end

  #Wrap player around the stage
  if args.state.player.x > 1280
    args.state.player.x = -64
    args.state.player.started_running_at ||= args.state.tick_count
  elsif args.state.player.x < -64
    args.state.player.x = 1280
    args.state.player.started_running_at ||= args.state.tick_count
  end

  if args.state.player.y > 720
    args.state.player.y = -64
    args.state.player.started_running_at ||= args.state.tick_count
  elsif args.state.player.y < -64
    args.state.player.y = 720
    args.state.player.started_running_at ||= args.state.tick_count
  end

  #Display the flying dragon
  args.outputs.sprites << display_dragon(args)
  args.outputs.labels << [30, 700, "Use arrow keys to move around.", 255, 255, 255]
end

# helper method to create a button
def new_button id, x, y, text
  # create a hash ("entity") that has some metadata
  # about what it represents
  entity = 
  {
    id: id,
    rect: { x: x, y: y, w: 200, h: 50 }
  }

  # for that entity, define the primitives 
  # that form it
  entity[:primitives] = 
  [
    { x: x, y: y, w: 200, h: 50 }.border,
    { x: x + 75, y: y + 30, text: text }.label
  ]
    
  entity
end

# helper method for determining if a button was clicked
def button_clicked? args, button
  return false unless args.inputs.mouse.click
  return args.inputs.mouse.point.inside_rect? button[:rect]
end


def display_dragon args
  start_looping_at = 0
  number_of_sprites = 6
  number_of_frames_to_show_each_sprite = 4
  does_sprite_loop = true
  sprite_index = start_looping_at.frame_index number_of_sprites,
                                              number_of_frames_to_show_each_sprite,
                                              does_sprite_loop
  {
    x: args.state.player.x,
    y: args.state.player.y,
    w: args.state.player.w,
    h: args.state.player.h,
    path: "sprites/dragon-#{sprite_index}.png",
    flip_horizontally: args.state.player.direction < 0
  }
end
