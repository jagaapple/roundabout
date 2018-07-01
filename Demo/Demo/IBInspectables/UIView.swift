// =============================================================================================================================
// DEMO - IB INSPECTABLES - UI VIEW
// =============================================================================================================================
import UIKit

extension UIView {

  // ---------------------------------------------------------------------------------------------------------------------------
  // Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // Configure custom fields.
  @IBInspectable var cornerRadius: CGFloat {
    get { return self.layer.cornerRadius }
    set { self.layer.cornerRadius = newValue }
  }

}