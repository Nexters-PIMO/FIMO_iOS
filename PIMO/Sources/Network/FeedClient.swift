//
//  FeedClient.swift
//  PIMO
//
//  Created by 김영인 on 2023/03/19.
//  Copyright © 2023 pimo. All rights reserved.
//

import AVFoundation
import Combine
import Foundation

import ComposableArchitecture

struct FeedClient {
    let play: (String) -> EffectPublisher<Void, Never>
    let stop: () -> EffectPublisher<Void, Never>
}

extension DependencyValues {
    var feedClient: FeedClient {
        get { self[FeedClient.self] }
        set { self[FeedClient.self] = newValue }
    }
}

extension FeedClient: DependencyKey {
    static var liveValue: Self {
        let tts = TTSManager()
        
        return Self(
            play: { text in tts.play(text) },
            stop: { tts.stop() }
        )
    }
}

private class TTSManager: NSObject {
    var delegate: Delegate?
    private var synthesizer: AVSpeechSynthesizer?
    
    override init() {
        super.init()
    }
    
    func play(_ text: String) -> EffectPublisher<Void, Never> {
        let play = Future<Void, Never> { promise in
            let delegate = Delegate(
                didFinishPlaying: {
                    promise(.success(Void()))
                }
            )
            self.synthesizer = AVSpeechSynthesizer()
            self.synthesizer?.delegate = delegate
            
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
            utterance.rate = 0.4
            self.synthesizer?.stopSpeaking(at: .immediate)
            self.synthesizer?.speak(utterance)
        }
        
        return play.eraseToEffect()
    }
    
    func stop() -> EffectPublisher<Void, Never> {
        let stop = Future<Void, Never> { promise in
            self.synthesizer?.stopSpeaking(at: .immediate)
            promise(.success(Void()))
        }
        
        return stop.eraseToEffect()
    }
}

private final class Delegate: NSObject, AVSpeechSynthesizerDelegate {
    let didFinishPlaying: () -> Void
    
    init(didFinishPlaying: @escaping () -> Void) {
        self.didFinishPlaying = didFinishPlaying
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.didFinishPlaying()
    }
}
