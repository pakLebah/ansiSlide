import ANSITerminal

public enum Movement {
  case up
  case down
  case left
  case right
}

public struct Tiles {
  var symbols: [[String]] = [[]]
  var empty  : (row: Int, col: Int) = (0,0)
  var size   : Int
  var width  : Int
  var height : Int

  private mutating func fillSymbols() {
    symbols.removeAll()
    var count = 0
    for _ in 0..<size {
      var cols: [String] = []
      for _ in 0..<size {
        count += 1
        if count == 27 { count = 33 }  // jump to lowercase
        cols.append(String(UnicodeScalar(64+count)!))  // start from 'A'
      }
      symbols.append(cols)
    }
    symbols[size-1][size-1] = " "
    empty = (row: size-1, col: size-1)
  }

  public mutating func swapEmpty(with: Movement) {
    var tmp: String
    switch with {
      case .up:
        if empty.row > 0 {
          tmp = symbols[empty.row-1][empty.col]
          symbols[empty.row-1][empty.col] = " "
          symbols[empty.row][empty.col] = tmp
          empty.row -= 1
        }
      case .down:
        if empty.row < size-1 {
          tmp = symbols[empty.row+1][empty.col]
          symbols[empty.row+1][empty.col] = " "
          symbols[empty.row][empty.col] = tmp
          empty.row += 1
        }
      case .left:
        if empty.col > 0 {
          tmp = symbols[empty.row][empty.col-1]
          symbols[empty.row][empty.col-1] = " "
          symbols[empty.row][empty.col] = tmp
          empty.col -= 1
        }
      case .right:
        if empty.col < size-1 {
          tmp = symbols[empty.row][empty.col+1]
          symbols[empty.row][empty.col+1] = " "
          symbols[empty.row][empty.col] = tmp
          empty.col += 1
        }
    }
  }

  public mutating func shuffleEmpty() {
    let move = Int.random(in: 1...4)
    switch move {
      case  1: swapEmpty(with: .up)
      case  2: swapEmpty(with: .down)
      case  3: swapEmpty(with: .left)
      case  4: swapEmpty(with: .right)
      default: delay(1)
    }
  }

  public func isFinished() -> Bool {
    // hard coded solution for 3x3 and 4x4 board
    let correct3x3 = [["A","B","C"],["D","E","F"],["G","H"," "]]
    let correct4x4 = [["A","B","C","D"],["E","F","G","H"],
                      ["I","J","K","L"],["M","N","O"," "]]
    let correct5x5 = [["A","B","C","D","E"],["F","G","H","I","J"],
                      ["K","L","M","N","O"],["P","Q","R","S","T"],
                      ["U","V","W","X"," "]]

    // TODO: automatic checking for big board
    if size == 3 { return symbols == correct3x3 }
      else if size == 4 { return symbols == correct4x4 }
        else if size == 5 { return symbols == correct5x5 }
          else { return false }
  }

  init(size: Int, tileHeight: Int, tileWidth: Int) {
    self.size = size
    self.width = tileWidth
    self.height = tileHeight
    self.fillSymbols()
  }
}
