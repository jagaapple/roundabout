// =============================================================================================================================
// DEMO - IB INSPECTABLES - UI BUTTON
// =============================================================================================================================
import UIKit

extension UIButton {

  // ---------------------------------------------------------------------------------------------------------------------------
  // Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // Configure custom fields.
  @IBInspectable var backgroundDisabledColor: UIColor {
    get { return .clear }
    set {
      let size: CGSize = self.frame.size
      self.setBackgroundImage(self.createSolidColorImage(newValue, size: size), for: .disabled)
    }
  }


  // ---------------------------------------------------------------------------------------------------------------------------
  // Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  private func createSolidColorImage(_ color: UIColor, size: CGSize) -> UIImage {
    UIGraphicsBeginImageContext(size)

    let rect = CGRect(origin: .zero, size: size)
    let context = UIGraphicsGetCurrentContext()
    context!.setFillColor(color.cgColor)
    context!.fill(rect)

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return image!
  }

}
