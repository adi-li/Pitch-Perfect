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
    var audioPlayer: AVAudioPlayer!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Load audio file to player
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        // Create audio engine for pitch sound effect
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetAudioPlayer() {
        // Reset player
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.rate = 1
        
        // Reset engine
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioWithRate(rate: Float) {
        self.resetAudioPlayer()
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func playAudioWithPitch(pitch: Float) {
        self.resetAudioPlayer()
        
        // Set normal audio node
        let playerNode = AVAudioPlayerNode()
        audioEngine.attachNode(playerNode)
        
        // Add effect
        let pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.pitch = pitch
        audioEngine.attachNode(pitchEffect)
        
        // Connect the nodes in a filter flow
        audioEngine.connect(playerNode, to: pitchEffect, format: nil)
        audioEngine.connect(pitchEffect, to: audioEngine.outputNode, format: nil)
        
        // Set the file into player node
        playerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        // Start playing
        playerNode.play()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        self.playAudioWithRate(0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        self.playAudioWithRate(1.5)
    }

    @IBAction func playChipmunkAudio(sender: UIButton) {
        self.playAudioWithPitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        self.playAudioWithPitch(-1000)
    }
    
    @IBAction func stopPlaying(sender: UIButton) {
        self.resetAudioPlayer()
    }
}
