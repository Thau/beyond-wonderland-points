# frozen_string_literal: true

class LoopingPathMovement
  def initialize(width:, height:, x:, y:, max_path_length:,separation:)
    @width = width
    @height = height
    @initial_x = x
    @initial_y = y
    @separation = separation
    @max_path_length = max_path_length

    if Random.rand < 0.2
      @paths = []

      search_path([[x, y]], 0)
      @path = @paths.sample
      @path.shift
    else
      @path = [[x, y]]
    end
  end

  def tick(x, y, time)
    if time.quarter_advance < 0.01
      update_initials(x, y)
    end

    if time.quarter_advance < 0.01 && time.whole_advance < 0.25
      set_objective
    end

    if time.whole_advance < 0.25
      x = lerp(@initial_x, @final_x, time.quarter_advance)
      y = lerp(@initial_y, @final_y, time.quarter_advance)
    else
      x = @final_x
      y = @final_y
    end

    [x % @width, y % @height]
  end

  private

  def search_path(path, depth)
    if depth > 0 && path.last == [@initial_x, @initial_y]
      @paths << path
      return
    end

    if depth >= @max_path_length
      return
    end

    x = path.last[0]
    y = path.last[1]

    candidates(x, y).each do |c_x, c_y|
      next if path.include?([c_x, c_y]) && [c_x, c_y] != path.first
      if c_x.between?(@separation, @width - @separation) && c_y.between?(@separation, @height - @separation)
        search_path(path + [[c_x, c_y]], depth + 1)
      end
    end
  end

  def candidates(x, y)
    [
      [x, y + @separation],
      [x + @separation, y + @separation],
      [x + @separation, y],
      [x + @separation, y - @separation],
      [x, y - @separation],
      [x - @separation, y - @separation],
      [x - @separation, y],
      [x - @separation, y + @separation]
    ]
  end

  def lerp(start_loc, end_loc, percent)
    start_loc + (percent * (end_loc - start_loc))
  end

  def update_initials(x, y)
    @initial_x = x
    @initial_y = y
  end

  def set_objective
    return if @path.empty?
    next_point = @path.shift
    @final_x = next_point[0]
    @final_y = next_point[1]
  end
end
