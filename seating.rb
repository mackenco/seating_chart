require 'csv'

class Classroom
  attr_reader :rows, :cols, :rules

  def initialize(rows, cols, roster, rules)
    @rows, @cols, @roster, @rules = rows, cols, roster, rules

    generate_seats
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def render
    @grid.map do |row|
      row.map do |student|
        student.name
      end.join(" ")
    end.join("\n")
  end

  def valid?
    @grid.flatten.all? { |seat| seat.valid? }
  end

  def generate_seats
    i = -1
    ros = @roster.shuffle
    @grid = Array.new(@rows) do |row|
      Array.new(@cols) do |col| 
        i += 1
        Student.new(self, [row, col], ros[i] )
      end
    end
  end
end

class Student
  DELTA = [
    [-2,  2], [-1,  2], [ 0,  2], [ 1,  2], [ 2,  2],
    [-2,  1], [-1,  1], [ 0,  1], [ 1,  1], [ 2,  1],
    [-2,  0], [-1,  0],           [ 1,  0], [ 2,  0],
    [-2, -1], [-1, -1], [ 0, -1], [ 1, -1], [ 2, -1],
    [-2, -2], [-1, -2], [ 0, -2], [ 1, -2], [ 2, -2]
  ]

  attr_reader :pos, :name

  def initialize(classroom, pos, name)
    @classroom, @pos, @name = classroom, pos, name
  end

  def neighbors
    adjacent_coords = DELTA.map do |(dx, dy)|
      [pos[0] + dx, pos[1] + dy]
    end.select do |row, col|
      row.between?(0, @classroom.rows - 1) && col.between?(0, @classroom.cols - 1)
    end

    adjacent_coords.map { |pos| @classroom[pos] }
  end

  def valid?
    neighbors.none? do |neighbor|
      next unless @classroom.rules[@name]
      @classroom.rules[@name].include?(neighbor.name)
    end
  end
end

roster, parsedRoster, rules = CSV.read('class1.csv', headers:true), [], {}
roster.each do |student| 
  name = student[0].split(",")[1].split(" ")[0].capitalize
  parsedRoster << name 
  rules[name] = student[1].split if student[1]
end

room = Classroom.new(5, 7, parsedRoster, rules)

until room.valid?
  room.generate_seats
end

puts room.render

