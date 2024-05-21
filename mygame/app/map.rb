class Map
  attr_accessor :map

  def initialize(map, debug: false)
    @map = map
    @debug = debug
  end

  def paint(x:, y:, base_color:, new_color:, sleep_time: 0)
    return if new_color == base_color

    coords_inside_matrix = y >= 0 && y < map.size && x >= 0 && x < map[0].size

    pixel_should_be_painted = coords_inside_matrix && map[y][x] == base_color

    return unless pixel_should_be_painted

    map[y][x] = new_color
    puts "paint(#{x}-#{y})" if @debug
    puts("  changing x:#{x} y:#{y}") if pixel_should_be_painted && @debug
    print(x, y, sleep_time) if @debug

    paint(x: x+1, y: y, base_color: base_color, new_color: new_color)
    paint(x: x, y: y+1, base_color: base_color, new_color: new_color)
    paint(x: x-1, y: y, base_color: base_color, new_color: new_color)
    paint(x: x, y: y-1, base_color: base_color, new_color: new_color)
  end

  def print(x, y, sleep_time)
    map.each { |row| puts row.to_s }
    sleep sleep_time
  end
end