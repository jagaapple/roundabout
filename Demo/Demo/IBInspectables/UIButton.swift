// =============================================================================================================================
// DEMO - IB INSPECTABLES - UI BUTTON
// =============================================================================================================================
import UIKit

extension UIButton {

  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Custom Fields
  @IBInspectable var backgroundDisabledColor: UIColor {
    get { return .clear }
    set {
      let size: CGSize = self.frame.size
      self.setBackgroundImage(self.createSolidColorImage(newValue, size: size), for: .disabled)
    }
  }


  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Private Functions
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
