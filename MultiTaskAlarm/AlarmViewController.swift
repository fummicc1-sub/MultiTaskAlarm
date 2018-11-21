//
//  ViewController.swift
//  MultiTaskAlarm
//
//  Created by Fumiya Tanaka on 2018/11/19.
//  Copyright © 2018 Fumiya Tanaka. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications

class AlarmViewController: UIViewController {

    @IBOutlet var pinkTimeLabel: UILabel!
    @IBOutlet var lightBlueLabel: UILabel!
    
    var pinkTimer: Timer!
    var lightBlueTimer: Timer!
    
    var pinkTimerSecond: Int = 10
    var lightBlueTimerSecond: Int = 100
    
    var audioPlayerPinkFinish: AVAudioPlayer!
    var audioPlayerLightBlueFinish: AVAudioPlayer!
    var audioPlayerPinkEachTime: AVAudioPlayer!
    var audioPlayerLightBlueEachTime: AVAudioPlayer!
    
    var pinkNotificationTrigger: UNNotificationTrigger!
    
    var lightBlueNotificationTrigger: UNNotificationTrigger!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatDate(pinkTime: pinkTimerSecond)
        formatDate(lightBlueTime: lightBlueTimerSecond)
        
        
        if let audioPlayer = setSoundPlayer(fileName: "FinishKitchen") {
            
            audioPlayerPinkFinish = audioPlayer
            audioPlayerLightBlueFinish = audioPlayer
        }
        
        if let audioPlayer = setSoundPlayer(fileName: "PiKitchen") {
            
            audioPlayerPinkEachTime = audioPlayer
            audioPlayerLightBlueEachTime = audioPlayer
        }
    }

    @objc func updatePinkTimer() {
        
        pinkTimerSecond = pinkTimerSecond - 1
        formatDate(pinkTime: pinkTimerSecond)
        audioPlayerPinkEachTime.play()
        
        if pinkTimerSecond <= 0 {
            
            audioPlayerPinkFinish.play()
            pinkTimer.invalidate()
        }
    }
    
    @objc func updateLightBlueTimer() {
        
        lightBlueTimerSecond = lightBlueTimerSecond - 1
        formatDate(lightBlueTime: lightBlueTimerSecond)
        audioPlayerLightBlueEachTime.play()
        
        if lightBlueTimerSecond <= 0 {
            
            audioPlayerLightBlueFinish.play()
            lightBlueTimer.invalidate()
        }
    }
    
    func formatDate(pinkTime: Int) {
    
        let hour = pinkTime / 3600 % 24
        let minute = pinkTime / 60 % 60
        let second = pinkTime % 60
        
        pinkTimeLabel.text = "\(hour):\(String(format: "%02d", minute)):\(String(format: "%02d", second))"
    }
    
    func formatDate(lightBlueTime: Int) {
        
        let hour = lightBlueTime / 3600 % 24
        let minute = lightBlueTime / 60 % 60
        let second = lightBlueTime % 60
        
        lightBlueLabel.text = "\(hour):\(String(format: "%02d", minute)):\(String(format: "%02d", second))"
    }
    
    func setSoundPlayer(fileName: String) -> AVAudioPlayer? {
        
        let path = Bundle.main.path(forResource: fileName, ofType: "mp3")
        
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            
            let audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            return audioPlayer
        }catch {
            
            print(error)
            return nil
        }
    }
    
    func setupNotification() {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            
            if error != nil {
                return
            }
            
            if granted {
                print("通知許可")
                
                center.delegate = self
            } else {
                print("通知拒否")
            }
        }
    }
    
    func setPinkNotification(second: TimeInterval) {
        
        pinkNotificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: second, repeats: false)
    }
    
    func setLightBlueNotification(second: TimeInterval) {
        
        lightBlueNotificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: second, repeats: false)
    }
    
    @IBAction func tappedStartButton() {
        
        pinkTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updatePinkTimer), userInfo: nil, repeats: true)
        
        lightBlueTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateLightBlueTimer), userInfo: nil, repeats: true)
        
        setupNotification()
        setPinkNotification(second: TimeInterval(pinkTimerSecond))
        setLightBlueNotification(second: TimeInterval(lightBlueTimerSecond))
    }
    
    @IBAction func tappedPlusMinuteButtoPink() {
        
        pinkTimerSecond = pinkTimerSecond + 60
        formatDate(pinkTime: pinkTimerSecond)
        
        setPinkNotification(second: TimeInterval(pinkTimerSecond))
        setLightBlueNotification(second: TimeInterval(lightBlueTimerSecond))
    }
    
    @IBAction func tappedPlusSecondButtonPink() {
        
        pinkTimerSecond = pinkTimerSecond + 1
        formatDate(pinkTime: pinkTimerSecond)
        
        setPinkNotification(second: TimeInterval(pinkTimerSecond))
        setLightBlueNotification(second: TimeInterval(lightBlueTimerSecond))
    }
    
    @IBAction func tappedPlusMinuteLightBlue() {
        
        lightBlueTimerSecond = lightBlueTimerSecond + 60
        formatDate(lightBlueTime: lightBlueTimerSecond)
        
        setPinkNotification(second: TimeInterval(pinkTimerSecond))
        setLightBlueNotification(second: TimeInterval(lightBlueTimerSecond))
    }
    
    @IBAction func tappedPlusSecondLightBlue() {
        
        lightBlueTimerSecond = lightBlueTimerSecond + 1
        formatDate(lightBlueTime: lightBlueTimerSecond)
        
        setPinkNotification(second: TimeInterval(pinkTimerSecond))
        setLightBlueNotification(second: TimeInterval(lightBlueTimerSecond))
    }
}

extension AlarmViewController: UNUserNotificationCenterDelegate {
}
