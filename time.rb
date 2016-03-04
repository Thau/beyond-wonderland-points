# frozen_string_literal: true

class Time
  def initialize(fps:, bpm:)
    @fps = fps
    @bpm = bpm
    @frame = 0
  end

  def tick
    @frame += 1
  end

  def time
    (1.0 / @fps) * @frame
  end

  def quarter_time
    60.0 / @bpm
  end

  def quarter_advance
    advance(quarter_time)
  end

  def half_time
    quarter_time * 2
  end

  def half_advance
    advance(half_time)
  end

  def whole_time
    quarter_time * 4
  end

  def whole_advance
    advance(whole_time)
  end

  def eighth_time
    quarter_time / 2.0
  end

  def eighth_advance
    advance(eighth_time)
  end

  def sixteenth_time
    quarter_time / 4.0
  end

  def sixteenth_advance
    advance(sixteenth_time)
  end

  private

  def advance(note_length)
    (time % note_length) / note_length
  end
end
