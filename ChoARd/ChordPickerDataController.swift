import Foundation
import UIKit

class ChordDataSource: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    private let rootValues: [String] = [
        "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"
    ]

    private let typeValues: [String] = [
        "major",
        "minor"
    ]

    let scales = ["major": [0,2,4,5,7,9,11], "minor": [0,2,3,5,7,8,10]];

    func getChromaticScale(root: String) -> [String] {
        let idx = rootValues.firstIndex(of: root)
        return Array(rootValues[idx!...] + rootValues[..<idx!])
    }

    func getScale(chromaticScale: [String], quality: String) -> [String] {
        var scale: Array<String> = []

        for value in scales[quality]!{
            scale.append(String(chromaticScale[value]))
        }

        return scale
    }

    func getTriad(scale: [String]) -> [String]{
        return [scale[0], scale[2], scale[4]]
    }

    func getSeventh(scale: [String]) -> [String]{
        return [scale[6]]
    }

    func getSuspendedVoicing(scale: [String]) -> [String]{
        return [
            scale[0],
            scale[2],
            scale[4],
            scale[5],
            scale[6],
            scale[1],
            scale[2],
            scale[4]
        ]
    }


    func addOctaveNotation(chord: [String]) -> [String] {
        var highestNote: String = ""
        var highestOctave: Int = 0
        var updatedChord: [String] = []
        let chromaticScale: [String] = getChromaticScale(root: chord.first!)

        for note in chord {
            if (updatedChord.count > 0){
                let currentHighestNoteIndex = chromaticScale.firstIndex(of: highestNote)
                let nextNoteIndex = chromaticScale.firstIndex(of: note)

                if (nextNoteIndex! < currentHighestNoteIndex!){
                    highestOctave += 1
                }

                updatedChord.append(note + String(highestOctave))
            } else {
                updatedChord.append(note + "0")
            }

            highestNote = note
        }

        return updatedChord
    }

    func summonJacob(scale: [String]) -> [String]{
        var unused = Array(scale[1...])
        unused.shuffle()

        return [scale[0]] + unused
    }

    func getNotes(root: String, quality: String, jazziness: Jazziness) -> [String]{
        var chord: [String] = []
        let chromatic = getChromaticScale(root: root)
        let scale = getScale(chromaticScale: chromatic, quality: quality)

        if (jazziness == Jazziness.NONE){
            chord = getTriad(scale: scale)
        }

        if (jazziness == Jazziness.LITTLE){
            chord = getTriad(scale: scale) + getSeventh(scale: scale)
        }

        if (jazziness == Jazziness.MOAR){
            chord = getSuspendedVoicing(scale: scale)
        }

        if (jazziness == Jazziness.JACCOBBB){
            chord = summonJacob(scale: scale)
        }

        return addOctaveNotation(chord: chord)
    }

    enum Jazziness: String, CaseIterable {
        case NONE = "none"
        case LITTLE = "little"
        case MOAR = "moar"
        case JACCOBBB = "jacob"
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return rootValues.count
        case 1: return typeValues.count
        case 2: return Jazziness.allCases.count
        default: return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return rootValues[row]
        case 1: return typeValues[row]
        case 2: return Jazziness.allCases[row].rawValue
        default: return nil
        }
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
