import UIKit

class RootViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ChordPickerDataController {
            destination.delegate = self
        }
    }
}

extension RootViewController: UpdateyNotesDelegate {
    func update(notes: [String]) {
        if let viewCon = children.first(where: { $0.isKind(of: ViewController.self) }) as? ViewController {
            viewCon.selectedNotes = notes
            viewCon.updateKeyProperties()
        }
    }
}
