import Foundation
import UIKit

class ChordDataSource: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    private let rootValues: [String] = [
        "C",
        "D",
        "E",
        "F",
        "G",
        "A",
        "B",
    ]

    private let typeValues: [String] = [
        "Major",
        "Minor"
    ]

    private let jazzValues: [String] = [
        "Cool",
        "Wanky",
        "Unlistenable"
    ]

    private let dataSources: [[String]]

    override init() {
        dataSources = [
            rootValues,
            typeValues,
            jazzValues
        ]

        super.init()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        dataSources.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        dataSources[component].count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        dataSources[component][row]
    }
}

class ChordPickerDataController: UIViewController {
    @IBOutlet var chordPicker: UIPickerView!

    var chordData: ChordDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        chordData = ChordDataSource()

        chordPicker.dataSource = chordData
        chordPicker.delegate = chordData
    }
}
