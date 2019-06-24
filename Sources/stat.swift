import Foundation
import ANSITerminal

public struct Stats {
  var steps: Int = 0
  var lapse: Int = 0
  var lastKey: ANSIKeyCode = .none

  private var top: Int
  private var left: Int
  private var width: Int
  private var height: Int
  private let space = 5
  private var start = Date()

  public mutating func startTime() {
    start = Date()
  }

  public mutating func printStats() {
    let step = " steps ".white.onDarkGray+RPT.darkGray.onDefault
    var time = " time ".white.onDarkGray+RPT.darkGray.onDefault
    let key  = " key ".white.onDarkGray+RPT.darkGray.onDefault

    // calculate time lapse
    lapse = Int(Date().timeIntervalSince(start))
    let sec  = lapse % 60
    let min  = (lapse / 60) % 60
    let hour = lapse / 3600

    if hour > 0 { time += " \(hour)h \(min)m \(sec)s " }
      else if min > 0 { time += " \(min)m \(sec)s " }
        else { time += " \(sec)s " }

    let tail = "         "  // clear previous text remnants
    writeAt(top+1, left+width+space, step+" \(steps)"+tail)
    writeAt(top+3, left+width+space, time+tail)
    writeAt(top+5, left+width+space, key+" \(lastKey)"+tail)
  }

  public func writeStatus(_ text: String) {
    moveTo(top+height-1, left+width+space)
    clearToEndOfLine()
    write(text)
  }

  public mutating func reset() {
    steps = 0
    lapse = 0
    lastKey = .none
  }

  init(_ top: Int, _ left: Int, _ width: Int, _ height: Int) {
    self.top = top
    self.left = left
    self.width = width
    self.height = height
  }
}
