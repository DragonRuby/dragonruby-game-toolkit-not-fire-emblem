#Size of board is always 1280x720

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

  #Get the keyboard input and set player properties

  # * FIXME: ~Keyboard#right_left~
  # There is ~args.inputs.keyboard.right_left~ that returns -1, 0, 1.
  # Take a look at the dueling starships sample app.
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
