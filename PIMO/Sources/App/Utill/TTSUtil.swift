//
//  TTSUtil.swift
//  PIMO
//
//  Created by 김영인 on 2023/03/02.
//  Copyright © 2023 pimo. All rights reserved.
//

import AVFoundation

class TTSUtil {
    
    static let shared = TTSUtil()
    
    private let synthesizer = AVSpeechSynthesizer()
    
    private init() { }
    
    func play(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = 0.4
        synthesizer.stopSpeaking(at: .immediate)
        synthesizer.speak(utterance)
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
