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
        resetButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        // Change view to notify as recording
        recordingLabel.text = "recording in progress..."
        stopButton.hidden = false
        recordButton.enabled = false
        
        // Get the save file path
        let filePathURL = generateFilePathURL()
        
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
        // Stop recording
        audioRecorder.stop()
        
        // Stop audio session (can let the background apps like Music continue playing)
        let session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if !flag {
            println("Saving audio fail.")
            resetButton()
            return
        }
        
        // Save audio file
        recordedAudio = RecordedAudio(filePathUrl: recorder.url)
        
        // Audio file is saved, change the screen to play sounds
        performSegueWithIdentifier("stopRecording", sender: recordedAudio)
    }
    
    func resetButton() {
        recordingLabel.text = "Tap to Record"
        stopButton.hidden = true
        recordButton.enabled = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            playSoundsVC.receivedAudio = sender as! RecordedAudio
        }
    }
    
    func generateFilePathURL() -> NSURL {
        let directory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let recordingName = "my_audio.wav"
        return NSURL.fileURLWithPathComponents([directory, recordingName])!
    }
}

