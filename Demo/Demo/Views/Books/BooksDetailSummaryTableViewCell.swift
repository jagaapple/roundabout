// =============================================================================================================================
// DEMO - VIEWS - BOOKS - BOOKS DETAIL SUMMARY TABLE VIEW CELL
// =============================================================================================================================
import UIKit
import Roundabout

final class BooksDetailSummaryTableViewCell: UITableViewCell {

  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Internal Variables
  static var identifier: String { return "summary" }

  // MARK: Private Variables
  private var titleSignal: StateSignal<String, ApplicationState>? {
    willSet { self.titleSignal?.unsubscribe(self) }
    didSet { self.titleSignal?.subscribe(self, didChange: self.bindTitleToAppearance) }
  }
  private var descriptionSignal: StateSignal<String?, ApplicationState>? {
    willSet { self.descriptionSignal?.unsubscribe(self) }
    didSet { self.descriptionSignal?.subscribe(self, didChange: self.bindDescriptionToAppearance) }
  }

  // MARK: IBOutlet Variables
  @IBOutlet weak private var titleLabel: UILabel!
  @IBOutlet weak private var descriptionLabel: UILabel!


  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Initializers
  // ---------------------------------------------------------------------------------------------------------------------------
  deinit {
    self.titleSignal = nil
    self.descriptionSignal = nil
  }

  // MARK: Internal Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  func prepare(titleSignal: StateSignal<String, ApplicationState>, descriptionSignal: StateSignal<String?, ApplicationState>) {
    self.titleSignal = titleSignal
    self.descriptionSignal = descriptionSignal
  }

  // MARK: Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  private func bindTitleToAppearance(_ title: String) {
    self.titleLabel.text = title
  }

  private func bindDescriptionToAppearance(_ description: String?) {
    self.descriptionLabel.text = description
  }

}
