require "app/map.rb"

class ScreenMap
  attr_accessor :map

  def initialize(map)
    @map = map
    @map_painter = Map.new(@map)

    paint(2, 2, 1)
  end

  def paint(x, y, color)
    @map_painter.paint(x: x, y: y, old_color: @map[y][x], color: color)
  end

  def tick(args)
    args.outputs.labels << [50,600, "Paint example - Flood fill", 250,250,210]
    args.outputs.labels << [150,570, "Click to fill ->", 230,110,210]
    args.outputs.solids << [0,0,1280,720, 0,0,0]
    args.outputs.solids << [350,100,620,560, 0,0,80]

    map.each_with_index do |row, i|
      row.each_with_index do |value, j|
        map_color = map[i][j]
        rgb = get_color(map_color)
        args.outputs.solids << [400 + (j*35), 600 - (i*35), 27, 27, **rgb]
      end
    end
  end

  def get_color(i)
    [ [255,0,0], [0,255,0], [0,0,255], [180,180,180], [0, 100, 150], [50,50,50] ][i]
  end
end

@map = [
  [0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4],
  [0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4],
  [2, 2, 1, 2, 2, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4],
  [0, 0, 2, 0, 0, 0, 0, 4, 0, 0, 0, 1, 2, 3, 4],
  [0, 0, 2, 0, 0, 3, 4, 4, 0, 0, 0, 1, 2, 3, 4],
  [0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 1, 2, 3, 4],
  [0, 0, 1, 0, 3, 1, 0, 0, 0, 0, 0, 1, 2, 3, 4],
  [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0],
  [0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1, 2, 0, 1],
  [0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0],
  [0, 0, 2, 0, 0, 3, 4, 4, 0, 0, 0, 1, 2, 3, 4],
  [0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4],
  [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4],
  [0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0],
]

def tick(args)
  args.state.screen_map ||= ScreenMap.new(@map)
  args.state.screen_map.tick(args)
end
