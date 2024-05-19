require "app/map.rb"

class ScreenMap
  attr_accessor :map, :map_start_x, :map_start_y, :cell_width, :brush_color

  COLORS = [[255,0,0], [0,255,0], [0,0,255], [180,180,180], [0, 100, 150], [50,50,50]]

  def initialize(map, args)
    @map = map
    @map_painter = Map.new(@map)
    @map_start_x = 400
    @map_start_y = 600
    @cell_width = 27
    @map_rows = map.size
    @map_cols = map.first.size
    @brush_color = 4
    @palette_start = {
      x: 260.from_left,
      y: 300.from_top,
      width: 50
    }

    args.outputs.static_labels << [50,600, "Paint example - Flood fill", 250,250,210]
    args.outputs.static_labels << [100,570, "Click to fill with:", 230,110,210]
  end

  def paint(x, y, color)
    @map_painter.paint(x: x, y: y, old_color: @map[y][x], color: color)
  end

  def tick(args)
    args.gtk.request_quit if args.inputs.keyboard.key_down.escape

    if args.inputs.mouse.click
      args.state.last_mouse_click = args.inputs.mouse.click
      handle_click(args)
    end

    draw_bg(args)
    display_mouse_pos(args)
    draw_map(args)
    draw_color_palette(args)
  end

  def draw_bg(args)
    args.outputs.solids << [0,0,1280,720, 0,0,0]
    args.outputs.solids << [350,150,520,520, 0,0,80]
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
    rgb = get_color(color)
    args.outputs.solids << {
      x: map_start_x + (x*cell_width),
      y: map_start_y - (y*cell_width),
      w: cell_width, h: cell_width,
      r: rgb[0], g: rgb[1], b: rgb[2]
    }
  end

  def draw_color_palette(args)
    color = get_color(@brush_color)

    args.outputs.static_solids << {
      x: 290, y: 545, w: cell_width, h: cell_width,
      r: color[0], g: color[1], b: color[2]
    }
    COLORS.each_with_index do |c, i|
      args.outputs.solids << {
        x: @palette_start[:x], y: @palette_start[:y] - (i*50),
        w: @palette_start[:width], h: @palette_start[:width],
        r: c[0], g: c[1], b: c[2]
      }
    end
  end

  def handle_click(args)
    click = args.state.last_mouse_click
    return if handle_palette_click(args, click)

    m = map_cell_from_click(click)

    if m && m[0] <= @map_cols && m[1] <= @map_rows
      paint(m[0], m[1], @brush_color)
      @last_painted_cell = m
    end
  end

  def handle_palette_click(args, click)
    x = click.point.x
    y = click.point.y
    palette_down = @palette_start[:width]*(COLORS.size-1)
    if x >= @palette_start[:x] && x <= @palette_start[:x] + @palette_start[:width] &&
       y <= @palette_start[:y] + @palette_start[:width] && y >= @palette_start[:y] - palette_down

      palette_idx = (((720-y+palette_down) / 50)-10).to_i
      @brush_color = palette_idx
      return true
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
    COLORS[i]
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
