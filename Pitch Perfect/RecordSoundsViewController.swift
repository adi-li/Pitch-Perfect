//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Adi Li on 30/8/15.
//  Copyright (c) 2015 Adi Li. All rights reserved.
//

import AVFoundation
import UIKit

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.resetButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        println("in recordAudio")
        
        // Change view to notify as recording
        recordingLabel.hidden = false
        stopButton.hidden = false
        recordButton.enabled = false
        
        // Get the save file path
        let filePathURL = self.filePathURL()
        println("Ready to save to \(filePathURL))")
        
        // Setup audio session
        let session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // Initialize and prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePathURL, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        
        // Start record
        audioRecorder.record()
        
    }

    @IBAction func stopRecording(sender: UIButton) {
        println("in stopRecording")
        
        // Stop recording
        audioRecorder.stop()
        
        // Stop audio session (can let the background apps like Music continue playing)
        let session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if !flag {
            println("Saving audio fail.")
            self.resetButton()
            return
        }
        
        // Save audio file
        recordedAudio = RecordedAudio()
        recordedAudio.filePathUrl = recorder.url
        recordedAudio.title = recorder.url.lastPathComponent
        
        // Audio file is saved, change the screen to play sounds
        self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
    }
    
    func resetButton() {
        recordingLabel.hidden = true
        stopButton.hidden = true
        recordButton.enabled = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            playSoundsVC.receivedAudio = sender as! RecordedAudio
        }
    }
    
    func filePathURL() -> NSURL {
        let directory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "yyyyMMdd-HHmmss"
//        let recordingName = formatter.stringFromDate(NSDate()) + ".wav"
        let recordingName = "my_audio.wav"
        return NSURL.fileURLWithPathComponents([directory, recordingName])!
    }
}

