import ANSITerminal

let TILE_WIDTH  = 6
let TILE_HEIGHT = 3
let SHUFFLE_FACTOR = 15

public class Board {
  var height: Int
  var width : Int
  var size  : Int
  var top   : Int
  var left  : Int

  private var tile : Tile
  private var tiles: Tiles

  public func color(text: ANSIAttr, border: ANSIAttr, background: ANSIAttr) {
    let colors = TileColors(text: text, border: border, background: background)
    tile.color(colors)
  }

  private func swapUp() {
    // draw empty tile
    var r = top + tiles.empty.row*tiles.height
    var c = left + tiles.empty.col*tiles.width
    var t = tiles.symbols[tiles.empty.row][tiles.empty.col]
    tile.draw(row: r, col: c, text: t)
    // draw value tile
    r = top + (tiles.empty.row-1)*tiles.height
    c = left + tiles.empty.col*tiles.width
    t = tiles.symbols[tiles.empty.row-1][tiles.empty.col]
    tile.draw(row: r, col: c, text: t)
  }

  private func swapDown() {
    var r = top + tiles.empty.row*tiles.height
    var c = left + tiles.empty.col*tiles.width
    var t = tiles.symbols[tiles.empty.row][tiles.empty.col]
    tile.draw(row: r, col: c, text: t)
    r = top + (tiles.empty.row+1)*tiles.height
    c = left + tiles.empty.col*tiles.width
    t = tiles.symbols[tiles.empty.row+1][tiles.empty.col]
    tile.draw(row: r, col: c, text: t)
  }

  private func swapLeft() {
    var r = top + tiles.empty.row*tiles.height
    var c = left + tiles.empty.col*tiles.width
    var t = tiles.symbols[tiles.empty.row][tiles.empty.col]
    tile.draw(row: r, col: c, text: t)
    r = top + tiles.empty.row*tiles.height
    c = left + (tiles.empty.col-1)*tiles.width
    t = tiles.symbols[tiles.empty.row][tiles.empty.col-1]
    tile.draw(row: r, col: c, text: t)
  }

  private func swapRight() {
    var r = top + tiles.empty.row*tiles.height
    var c = left + tiles.empty.col*tiles.width
    var t = tiles.symbols[tiles.empty.row][tiles.empty.col]
    tile.draw(row: r, col: c, text: t)
    r = top + tiles.empty.row*tiles.height
    c = left + (tiles.empty.col+1)*tiles.width
    t = tiles.symbols[tiles.empty.row][tiles.empty.col+1]
    tile.draw(row: r, col: c, text: t)
  }

  public func move(to: Movement) {
    switch to {
      case .up:
        if tiles.empty.row < size-1 {
          tiles.swapEmpty(with: .down)
          swapUp()
        }
      case .down:
        if tiles.empty.row > 0 {
          tiles.swapEmpty(with: .up)
          swapDown()
        }
      case .left:
        if tiles.empty.col < size-1 {
          tiles.swapEmpty(with: .right)
          swapLeft()
        }
      case .right:
        if tiles.empty.col > 0 {
          tiles.swapEmpty(with: .left)
          swapRight()
        }
    }
  }

  public func shuffle(count: Int = 0) {
    let count = count == 0 ? size*TILE_WIDTH*TILE_HEIGHT*SHUFFLE_FACTOR : count

    draw()
    for c in 1...count {
      tiles.shuffleEmpty()
      if c % (SHUFFLE_FACTOR * size) == 0 { draw(false) } // boost drawing speed
      delay(10)
    }
    draw()
    setDefault()
  }

  public func isFinished() -> Bool {
    return tiles.isFinished()
  }

  public func draw(_ withBorder: Bool = true) {
    // draw each tile
    for r in 0..<size {
      for c in 0..<size {
        let h = tiles.height
        let w = tiles.width
        var tile = Tile(height: h, width: w, text: tiles.symbols[r][c])

        tile.color(self.tile.colors)
        tile.draw(row: top + r*h, col: left + c*w)
      }
    }
    // draw outer border
    if withBorder {
      setColor(fore: tile.colors.border, back: .onDefault)
      for r in 0..<height { writeAt(top+r, left+width, "█") }
      for c in 0...width { writeAt(top+height, left+c, "▀") }
    }
  }

  init(size: Int, top: Int, left: Int) {
    self.top  = top
    self.left = left
    self.size = size

    tile   = Tile(height: TILE_HEIGHT, width: TILE_WIDTH, text: "")
    width  = size * tile.width
    height = size * tile.height
    tiles  = Tiles(size: size, tileHeight: tile.height, tileWidth: tile.width)
  }
}