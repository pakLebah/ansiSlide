import ANSITerminal

let board = Board(size: 4, top: 3, left: 1)
var stats = Stats(top: board.top, left: board.left, width: board.width, height: board.height)

// not operator as function to be more readable
@inlinable public func not(_ value: Bool) -> Bool {
  return !value
}

// shortcut to write text at given position
@inlinable public func writeAt(_ row: Int, _ col: Int, _ text: String) {
  moveTo(row, col)
  write(text)
}

private func title() {
  let title = " TERMINAL SLIDER ".asWhite.backColor(88)
  write("▐".foreColor(88).onDefault+title+"▌".foreColor(88).onDefault)
}

private func shuffleBoard() {
  cursorOff()
  stats.writeStatus("Shuffling tiles...")
  stats.reset()
  board.shuffle()
  stats.writeStatus("Use "+"arrow keys".underline+" to play.")
  stats.startTime()
  clearBuffer()
}

private func wrongAnswer() {
  cursorOff()
  moveToColumn(1)
  clearToEndOfLine()
  write("Please answer it with "+"Y".asLightGreen+" or "+"N".asYellow+"!")
  delay(1000)
  clearBuffer()
}

private func askAgain() {
  cursorOn()
  moveToColumn(1)
  clearToEndOfLine()
  write("Do you want to play again? ")
  clearBuffer()
}

private func playAgain() -> Bool {
  askAgain()
  while true {
    if keyPressed() {
      let char = readChar().lowercased()

      if char == "y" {
        write("Y", suspend: 500)
        return true
      } else if char == "n" {
        write("N", suspend: 500)
        return false
      } else if char == ESC {
        // reject key sequence
        if readKey().code != .none {
          wrongAnswer()
          askAgain()
        } else { return false }
      } else {
        wrongAnswer()
        askAgain()
      }
    }
  }
}

private func done() -> Bool {
  let thanks = "Thank you for playing!".asWhite

  if board.isFinished() {
    stats.writeStatus("Well done!".asLightGreen)
    moveLineDown(3)

    if not(playAgain()) {
      moveToColumn(1)
      clearToEndOfLine()
      writeln(thanks)
      return true
    }
    else {
      clearLine()
      return false
    }
  }
  else {
    stats.writeStatus(thanks)
    moveLineDown(2)
    return true
  }
}

/**********–––––––––– MAIN PROGRAM ––––––––––**********/

clearScreen()
cursorOff()
title()

while true {
  shuffleBoard()

  while true {
    var quit = false

    if keyPressed() {
      stats.steps += 1
      let code = readCode()

      if code == 27 {
        let key = readKey()

        if key.code == .none {  // ESC to quit
          quit = true
        }
        else {
          // accepted input keys
          switch key.code {
            case .up   : board.move(to: .up)
            case .down : board.move(to: .down)
            case .left : board.move(to: .left)
            case .right: board.move(to: .right)
            default    : break
          }
          stats.lastKey = key.code
        }
      }

      stats.writeStatus("Press "+"ESC".asLightRed+" to quit.")
      if not(quit) { quit = board.isFinished() }
    }
    else {
      stats.printStats()
    }
    if quit { break }
  }
  if done() { break }
}

cursorOn()
setDefault(style: true)
