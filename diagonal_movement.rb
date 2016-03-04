# frozen_string_literal: true

class DiagonalMovement
  def initialize(width:, height:)
    @width = width
    @height = height
  end

  def tick(x, y, time)
    update_initials(x, y, time)

    if time.whole_advance < 0.25
      x = lerp(@initial_x, @initial_x + 25, time.quarter_advance) % @width
      y = lerp(@initial_y, @initial_y + 25, time.quarter_advance) % @height
    end
    [x, y]
  end

  private

  def lerp(start_loc, end_loc, percent)
    start_loc + (percent * (end_loc - start_loc))
  end

  def update_initials(x, y, time)
    if time.quarter_advance < 0.01
      @initial_x ||= x - 25
      @initial_y ||= y - 25

      @initial_x += 25
      @initial_y += 25
    end
  end
end
