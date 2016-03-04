# frozen_string_literal: true

require 'chunky_png'
require 'parallel'

require_relative 'point'
require_relative 'cross_point'
require_relative 'diagonal_movement'
require_relative 'random_movement'
require_relative 'looping_path_movement'
require_relative 'time'

output_folder = 'output'
Dir.mkdir(output_folder) unless File.exist?(output_folder)

number_of_frames = 384
width = 1500
height = 500

time = Time.new(fps: 24, bpm: 120)

points = []
point_positions = []
width.times do |x|
  height.times do |y|
    dot_position = x % 25 == 0 && y % 25 == 0
    point_positions << [x, y] if dot_position
  end
end

Parallel.each(point_positions, threads: 16) do |x, y|
  puts("Generando rutas para X: #{x} Y: #{y}")
  definition = CrossPoint.new
  movement = LoopingPathMovement.new(width: width, height: height, x: x, y: y, max_path_length: 8)
  p = Point.new(x: x, y: y, pixel_definition: definition, movement: movement)
  points << p
end

filename = '000'
number_of_frames.times do |frame|
  full_filename = "#{output_folder}/#{filename}.png"
  image = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::BLACK)

  points.each do |point|
    point.tick(time)

    point.pixels.each do |x, y|
      x = x.round
      y = y.round
      if x.between?(0, width - 1) && y.between?(0, height - 1)
        image[x, y] = ChunkyPNG::Color.rgb(255, 255, 255)
      end
    end
  end

  image.save(full_filename)
  filename = filename.next

  time.tick
  puts("Out: #{full_filename}")
end
