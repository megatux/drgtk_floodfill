require "app/map.rb"

class ScreenMap
  attr_accessor :map, :map_start_x, :map_start_y, :cell_width

  def initialize(map, args)
    @map = map
    @map_painter = Map.new(@map)
    @map_start_x = 400
    @map_start_y = 600
    @cell_width = 27
    @map_rows = map.size
    @map_cols = map.first.size
    @brush_color = 4

    args.outputs.static_labels << [50,600, "Paint example - Flood fill", 250,250,210]
    args.outputs.static_labels << [100,570, "Click to fill with:", 230,110,210]
    args.outputs.static_solids << [290,545, cell_width, cell_width, *get_color(@brush_color)]
  end

  def paint(x, y, color)
    @map_painter.paint(x: x, y: y, old_color: @map[y][x], color: color)
  end

  def tick(args)
    if args.inputs.mouse.click
      args.state.last_mouse_click = args.inputs.mouse.click
      handle_click(args)
    end

    draw_bg(args)
    display_mouse_pos(args)
    draw_map(args)
  end

  def draw_bg(args)
    args.outputs.solids << [0,0,1280,720, 0,0,0]
    args.outputs.solids << [350,100,620,560, 0,0,80]
  end

  def display_mouse_pos(args)
    msg = "Mouse x:#{args.inputs.mouse.x.to_i} y:#{args.inputs.mouse.y.to_i}"
    args.outputs.labels << [110,530, msg, 200,100,100]
    if @last_painted_cell
      msg = "col:#{@last_painted_cell[0]} row:#{@last_painted_cell[1]} painted"
      args.outputs.labels << [100,500, msg, 200,100,100]
    end
  end

  def draw_map(args)
    map.each_with_index do |row, i|
      row.each_with_index do |value, j|
        map_color = map[i][j]
        draw_cell(args, j, i, map_color)
      end
    end
  end

  def draw_cell(args, x, y, color)
    args.outputs.solids << [
      map_start_x + (x*cell_width),
      map_start_y - (y*cell_width),
      cell_width, cell_width,
      *get_color(color)
    ]
  end

  def handle_click(args)
    m = map_cell_from_click(args.state.last_mouse_click)

    if m && m[0] <= @map_cols && m[1] <= @map_rows
      paint(m[0], m[1], @brush_color)
      @last_painted_cell = m
    end
  end

  def map_cell_from_click(click)
    return unless click

    x = click.point.x - map_start_x
    y = cell_width + map_start_y - click.point.y.to_f

    return unless x && y

    xx = (x / cell_width).to_i
    yy = (y / cell_width).to_i

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
  [0, 0, 0, 0, 1, 0, 0, 3, 3, 3, 0, 1, 2, 0, 0],
  [0, 0, 0, 0, 2, 0, 0, 3, 3, 3, 0, 1, 2, 0, 1],
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
