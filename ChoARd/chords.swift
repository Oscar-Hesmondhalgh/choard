import Foundation

let notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
let scales = ["major": [0,2,4,5,7,9,11], "minor": [0,2,3,5,7,8,10]];

enum Jazziness {
    case NONE
    case LITTLE
    case MOAR
    case JACCOBBB
}

func getChromaticScale(root: String) -> [String] {
    let idx = notes.firstIndex(of: root)
    return Array(notes[idx!...] + notes[..<idx!])
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
