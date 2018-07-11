// =============================================================================================================================
// DEMO - IB INSPECTABLES - UI VIEW
// =============================================================================================================================
import UIKit

extension UIView {

  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Custom Fields
  @IBInspectable var borderWidth: CGFloat {
    get { return self.layer.borderWidth }
    set { self.layer.borderWidth = newValue }
  }
  @IBInspectable var borderColor: UIColor {
    get { return .clear }
    set { self.layer.borderColor = newValue.cgColor }
  }
  @IBInspectable var cornerRadius: CGFloat {
    get { return self.layer.cornerRadius }
    set { self.layer.cornerRadius = newValue }
  }

}
