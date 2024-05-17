class Map
  attr_accessor :map

  def initialize(map, debug = false)
    @map = map
    @debug = debug
  end

  def paint(x, y, old_color, color, sleep_time = 0)
    coords_inside_matrix = y >= 0 && y < map.size && x >= 0 && x < map[0].size
    pixel_should_be_painted = coords_inside_matrix && map[y][x] == old_color

    return unless pixel_should_be_painted
    map[y][x] = color
    puts "paint(#{x}-#{y})" if @debug
    puts("  changing x:#{x} y:#{y}") if pixel_should_be_painted && @debug
    print(x, y, sleep_time) if @debug

    paint(x+1, y, old_color, color)
    paint(x, y+1, old_color, color)
    paint(x-1, y, old_color, color)
    paint(x, y-1, old_color, color)
  end

  def print(x, y, sleep_time)
    map.each { |row| puts row.to_s }
    sleep sleep_time
  end
end