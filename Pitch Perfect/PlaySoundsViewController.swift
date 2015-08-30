//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Adi Li on 30/8/15.
//  Copyright (c) 2015 Adi Li. All rights reserved.
//

import AVFoundation
import UIKit

class PlaySoundsViewController: UIViewController {
    
    var receivedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var audioPlayerNode: AVAudioPlayerNode!
    
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Create audio engine for pitch sound effect
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupAudioEngineWithEffect(nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetAudioPlayer() {
        // Reset player
        audioEngine.stop()
        audioEngine.reset()
        audioPlayerNode?.reset()
    }
    
    func setupAudioEngineWithEffect(effect: AVAudioNode?) {
        // Set normal audio node
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // Add effect
        var audioEffect = effect
        if effect == nil {
            audioEffect = AVAudioUnitTimePitch()
        }
        audioEngine.attachNode(audioEffect)
        
        // Connect the nodes in a filter flow
        audioEngine.connect(audioPlayerNode, to: audioEffect, format: nil)
        audioEngine.connect(audioEffect, to: audioEngine.outputNode, format: nil)
        
        // Set the file into player node
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    }
    
    func playAudioWithEffect(effect: AVAudioNode?) {
        resetAudioPlayer()
        
        // Add effect
        setupAudioEngineWithEffect(effect)
        
        // Start playing
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    func playAudioWithPitch(pitch: Float) {
        // Setup pitch effect
        let effect = AVAudioUnitTimePitch()
        effect.pitch = pitch
        
        playAudioWithEffect(effect)
    }
    
    func playAudioWithRate(rate: Float) {
        // Setup pitch effect
        let effect = AVAudioUnitTimePitch()
        effect.rate = rate
        
        playAudioWithEffect(effect)
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithRate(0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithRate(1.5)
    }

    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithPitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithPitch(-1000)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        let effect = AVAudioUnitReverb()
        effect.loadFactoryPreset(.MediumHall3)
        effect.wetDryMix = 80
        
        playAudioWithEffect(effect)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        let effect = AVAudioUnitDistortion()
        effect.preGain = -10
        effect.loadFactoryPreset(.MultiEcho1)
        
        playAudioWithEffect(effect)
    }
    
    @IBAction func stopPlaying(sender: UIButton) {
        resetAudioPlayer()
        setupAudioEngineWithEffect(nil)
    }
    
    @IBAction func resumeAudio(sender: UIButton) {
        if (!audioEngine.running) {
            audioEngine.startAndReturnError(nil)
        }
    }
    
    @IBAction func pauseAudio(sender: AnyObject) {
        if (audioEngine.running) {
            audioEngine.pause()
        }
    }

}
