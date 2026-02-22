import AVFoundation
import Foundation

class SpeechDelegate: NSObject, AVSpeechSynthesizerDelegate {
    var done = false

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        done = true
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        done = true
    }
}

// Read input: if arg is an existing file, read from it; otherwise treat as text
let text: String
if CommandLine.arguments.count > 1 {
    let arg = CommandLine.arguments[1]
    if FileManager.default.fileExists(atPath: arg) {
        // It's a file path — read contents and clean up
        text = (try? String(contentsOfFile: arg, encoding: .utf8)) ?? ""
        try? FileManager.default.removeItem(atPath: arg)
    } else {
        text = CommandLine.arguments.dropFirst().joined(separator: " ")
    }
} else {
    var stdinData = Data()
    while let byte = try? FileHandle.standardInput.availableData, !byte.isEmpty {
        stdinData.append(byte)
    }
    text = String(data: stdinData, encoding: .utf8) ?? ""
}

guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { exit(1) }

let rate = Float(ProcessInfo.processInfo.environment["SPEAK_RATE"] ?? "0.58") ?? AVSpeechUtteranceDefaultSpeechRate
let pitch = Float(ProcessInfo.processInfo.environment["SPEAK_PITCH"] ?? "0.9") ?? 1.0
let volume = Float(ProcessInfo.processInfo.environment["SPEAK_VOLUME"] ?? "1.0") ?? 1.0
let voicePref = ProcessInfo.processInfo.environment["SPEAK_VOICE"] ?? "personal"
let fallbackName = ProcessInfo.processInfo.environment["SPEAK_FALLBACK"] ?? "Samantha"

let synthesizer = AVSpeechSynthesizer()
let delegate = SpeechDelegate()
synthesizer.delegate = delegate

// Find personal voice by identifier or ObjC runtime
func findPersonalVoice() -> AVSpeechSynthesisVoice? {
    let voices = AVSpeechSynthesisVoice.speechVoices()
    for voice in voices {
        let id = voice.identifier.lowercased()
        if id.contains("personalvoice") || id.contains("personal-voice") || id.contains("personal_voice") {
            return voice
        }
    }
    for voice in voices {
        if voice.responds(to: Selector(("voiceType"))) {
            let typeValue = voice.perform(Selector(("voiceType")))
            if Int(bitPattern: typeValue?.toOpaque()) == 4 {
                return voice
            }
        }
    }
    return nil
}

// Select voice based on preference
func getVoice() -> AVSpeechSynthesisVoice? {
    if voicePref == "personal" {
        if let pv = findPersonalVoice() { return pv }
    }
    // Try by name
    let voices = AVSpeechSynthesisVoice.speechVoices()
    if voicePref != "personal" {
        if let named = voices.first(where: { $0.name == voicePref }) { return named }
    }
    // Fallback
    return voices.first(where: { $0.name == fallbackName }) ?? AVSpeechSynthesisVoice(language: "en-US")
}

let voice = getVoice()
let utterance = AVSpeechUtterance(string: text)
utterance.voice = voice
utterance.rate = rate
utterance.pitchMultiplier = pitch
utterance.volume = volume
synthesizer.speak(utterance)

// Run loop so delegate callbacks fire, exit when done
while !delegate.done {
    RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.1))
}
exit(0)
