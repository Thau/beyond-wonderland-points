# frozen_string_literal: true

class RandomMovement
  def initialize(width:, height:)
    @width = width
    @height = height
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

  def lerp(start_loc, end_loc, percent)
    start_loc + (percent * (end_loc - start_loc))
  end

  def update_initials(x, y)
    @initial_x = x
    @initial_y = y
  end

  def set_objective
    if Random.rand < 0.1
      @final_x = @initial_x + 25
      @final_y = @initial_y + 25
    else
      @final_x = @initial_x
      @final_y = @initial_y
    end
  end
end
