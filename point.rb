# frozen_string_literal: true

class Point
  attr_reader :x, :y

  def initialize(x:, y:, pixel_definition:, movement:)
    @x = x
    @y = y
    @pixel_definition = pixel_definition
    @movement = movement
  end

  def tick(time)
    new_position = @movement.tick(x, y, time)
    @x = new_position[0]
    @y = new_position[1]
  end

  def pixels
    @pixel_definition.pixels(x, y)
  end
end
