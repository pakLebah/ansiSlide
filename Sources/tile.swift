import ANSITerminal

public struct TileColors {
  var text: ANSIAttr
  var border: ANSIAttr
  var background: ANSIAttr

  init(text: ANSIAttr, border: ANSIAttr, background: ANSIAttr) {
    self.text = text
    self.border = border
    self.background = background
  }
}

public struct Tile {
  var height: Int
  var width : Int
  var text  : String
  var style : ANSIAttr = .bold
  var colors = TileColors(text: .yellow, border: .blue, background: .onLightBlue)

  public func draw(row: Int, col: Int, text: String? = nil) {
    let txt = text ?? self.text

    if txt == " " {
      setColor(fore: colors.border, back: foreToBack(colors.border))
    } else {
      setColor(fore: colors.border, back: colors.background)
    }

    for r in 0..<height { writeAt(row+r, col, "█") }
    for c in 1..<width  { writeAt(row, col+c, "▀") }
    for r in 1..<height {
      for c in 1..<width { writeAt(row+r, col+c, " ") }
    }

    let altColor: ANSIAttr = .white  // hard coded color for big board
    setStyle(style)
    if txt == " " {
      setColor(fore: backToFore(colors.background), back: colors.border)
    } else {
      let t = txt.lowercased()
      if txt == t {
        setColor(fore: altColor, back: colors.background)
      } else {
        setColor(fore: colors.text, back: colors.background)
      }
    }

    writeAt(row+height/2, col+width/2, txt)
    setDefault(style: true)
  }

  public mutating func style(_ style: ANSIAttr) {
    if isStyle(style.rawValue) {
      self.style = style
    }
  }

  public mutating func color(_ colors: TileColors) {
    self.colors = colors
  }

  init(height: Int, width: Int, text: String) {
    self.height = height
    self.width = width
    self.text = text
  }
}
