// =============================================================================================================================
// DEMO - VIEWS - BOOKS - BOOKS EDIT DEFAULT TABLE VIEW CELL
// =============================================================================================================================
import UIKit

final class BooksEditDefaultTableViewCell: UITableViewCell {

  // ---------------------------------------------------------------------------------------------------------------------------
  // Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // Define structs.
  struct BooksEditItem {
    let name: String
    let initialValue: String?
    let didInputTextFieldHandler: ((String?) -> Void)
  }

  // Define internal variables.
  static var identifier: String { return "default" }

  // Define private variables.
  private(set) var didInputTextFieldHandler: ((String?) -> Void)!

  // Define IBOutlet variables.
  @IBOutlet weak private var nameLabel: UILabel!
  @IBOutlet weak private var textField: UITextField!


  // ---------------------------------------------------------------------------------------------------------------------------
  // Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // Internal Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  func prepare(item: BooksEditItem) {
    self.didInputTextFieldHandler = item.didInputTextFieldHandler
    self.textField.addTarget(self, action: #selector(self.didInputText), for: .editingChanged)

    self.bindToAppearance(item: item)
  }

  // Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  private func bindToAppearance(item: BooksEditItem) {
    self.nameLabel.text = item.name
    self.textField.text = item.initialValue
  }

  @objc private func didInputText(_ sender: UITextField) {
    self.didInputTextFieldHandler(sender.text)
  }
  
}
