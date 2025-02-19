class Array
  def to_s
    to_sentence
  end
end

class Model
  def modelname
    self.class.name.downcase
  end

  def self.from_array(ary)
    ary.map { |t| new(t) }
  end
end

class Daterange < Model
  attr_accessor :start, :finish

  def initialize(d)
    if d.is_a?(Hash)
      @start = d['start']
      @finish = d['end']
    else
      @start = d
      @finish = nil
    end
  end

  def to_s(format = "%F")
    finish ? "#{start.strftime(format)} - #{finish.strftime(format)}" : start.strftime(format)
  end

  def <=>(other)
    if finish && other.finish
      [start, finish] <=> [other.start, other.finish]
    else
      start <=> other.start
    end
  end
end

class Event < Model
  attr_accessor :title, :date, :speaker

  def initialize(e)
    @title = e['title']
    @date = Daterange.new(e['date'])
    @speaker = e['speaker']
  end
end
