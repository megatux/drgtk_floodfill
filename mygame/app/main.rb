require "app/map.rb"

class ScreenMap
  attr_accessor :map, :map_start_x, :map_start_y, :point_width

  def initialize(map, args)
    @map = map
    @map_painter = Map.new(@map)
    @map_start_x = 400
    @map_start_y = 600
    @point_width = 27
    @map_rows = map.size
    @map_cols = map.first.size

    args.outputs.static_labels << [50,600, "Paint example - Flood fill", 250,250,210]
    args.outputs.static_labels << [150,570, "Click to fill ->", 230,110,210]
  end

  def paint(x, y, color)
    @map_painter.paint(x: x, y: y, old_color: @map[y][x], color: color)
  end

  def tick(args)
    args.state.last_mouse_click = args.inputs.mouse.click if args.inputs.mouse.click
    handle_click(args) if args.state.last_mouse_click

    draw_bg(args)
    display_mouse_pos(args)
    draw_map(args)
  end

  def draw_bg(args)
    args.outputs.solids << [0,0,1280,720, 0,0,0]
    args.outputs.solids << [350,100,620,560, 0,0,80]
  end

  def display_mouse_pos(args)
    msg = "Mouse x:#{args.state.last_mouse_click.point.x.to_i} y:#{args.state.last_mouse_click.point.y.to_i}"
    args.outputs.labels << [110,530, msg, 200,100,100]
  end

  def draw_map(args)
    map.each_with_index do |row, i|
      row.each_with_index do |value, j|
        map_color = map[i][j]
        args.outputs.solids << [
          map_start_x + (j*point_width),
          map_start_y - (i*point_width),
          point_width,
          point_width,
          **get_color(map_color)
        ]
      end
    end
  end

  def handle_click(args)
    m = map_cell_from_click(args.state.last_mouse_click)
    if m && m[0] <= @map_cols && m[1] <= @map_rows
      msg = "col:#{m[0]} row:#{m[1]} painted"
      args.outputs.labels << [100,500, msg, 200,100,100]
      paint(m[0], m[1], 4)
    end
  end

  def map_cell_from_click(click)
    return unless click

    x = click.point.x - map_start_x
    y = point_width + map_start_y - click.point.y.to_f

    return unless x && y

    xx = (x / point_width).to_i
    yy = (y / point_width).to_i

    return if xx < 0 || yy < 0 || xx > 14 || yy > 14

    [xx, yy]
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
  [4, 0, 2, 0, 0, 3, 4, 4, 0, 0, 0, 1, 2, 3, 4],
  [3, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4],
  [2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4],
  [1, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0],
  [0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0],
]

def tick(args)
  args.state.screen_map ||= ScreenMap.new(@map, args)
  args.state.screen_map.tick(args)
end
