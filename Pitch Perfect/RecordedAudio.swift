//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Adi Li on 30/8/15.
//  Copyright (c) 2015 Adi Li. All rights reserved.
//

import UIKit

class RecordedAudio: NSObject {
    var filePathUrl: NSURL
    var title: String
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
    convenience init(filePathUrl: NSURL) {
        var title = "audio.wav"
        if let last = filePathUrl.lastPathComponent {
            title = last
        }
        self.init(filePathUrl: filePathUrl, title: title)
    }
}
