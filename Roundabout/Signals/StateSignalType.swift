// =============================================================================================================================
// ROUNDABOUT - SIGNALS - STATE SIGNAL TYPE
// =============================================================================================================================
import Foundation

public protocol StateSignalType {
  func input(_ state: Any)
}