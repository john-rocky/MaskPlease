//
//  ViewController.swift
//  MaskPlease
//
//  Created by 間嶋大輔 on 2020/05/12.
//  Copyright © 2020 daisuke. All rights reserved.
//

import UIKit
import Vision
import AVFoundation

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (Timer) in
            self.isRequest = true
            
        }
        initialViewsSettings()
        viewsSetting()
//        setupAVCapture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewsSetting()
    }
    
    var maskingLabel = UILabel()
    var nomaskingLabel = UILabel()
    
    var thankYouMaskingView = UIImageView()
    var pleaseMaskingView = UIImageView()
    var pleaseMaskingView2 = UIImageView()
    
    var talker = AVSpeechSynthesizer()
    var talking = false
    
    func masking(){
        
        thankYouMaskingView.isHidden = false
        pleaseMaskingView.isHidden = true
        pleaseMaskingView2.isHidden = true
        nomaskingLabel.isHidden = true
        maskingLabel.isHidden = false
        talking = false
    }
    
    func noMasking() {
        thankYouMaskingView.isHidden = true
        maskingLabel.isHidden = true
        pleaseMaskingView.isHidden = false
        pleaseMaskingView2.isHidden = false
        nomaskingLabel.isHidden = false
        
        if !talking {
            let utterance = AVSpeechUtterance(string: NSLocalizedString("Please wear a mask.", comment: "") )
            utterance.voice = AVSpeechSynthesisVoice(language: NSLocalizedString("en-US", comment: ""))
            talker.speak(utterance)
            talking = true
            pleaseMaskingView.alpha = 1
            pleaseMaskingView2.alpha = 0
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, options: [], animations: {
                self.pleaseMaskingView.alpha = 0
                self.pleaseMaskingView2.alpha = 1
            }) { (UIViewAnimatingPosition) in
                
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, options: [], animations: {
                    self.pleaseMaskingView.alpha = 1
                    self.pleaseMaskingView2.alpha = 0
                }) { (UIViewAnimatingPosition) in
                    
                    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, options: [], animations: {
                        self.pleaseMaskingView.alpha = 0
                        self.pleaseMaskingView2.alpha = 1
                    }) { (UIViewAnimatingPosition) in
                        
                        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, options: [], animations: {
                            self.pleaseMaskingView.alpha = 1
                            self.pleaseMaskingView2.alpha = 0
                        }) { (UIViewAnimatingPosition) in
                            
                            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, options: [], animations: {
                                self.pleaseMaskingView.alpha = 0
                                self.pleaseMaskingView2.alpha = 1
                            }) { (UIViewAnimatingPosition) in
                            }
                        }
                    }
                }
            }
        }
        
        
        
    }
    
    var requests = [VNRequest]()
    var currentBuffer:CVImageBuffer?
    let session = AVCaptureSession()
    let videoDataOutput = AVCaptureVideoDataOutput()
    let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    var bufferSize: CGSize = .zero
    var objectBounds = CGRect.zero
    var isRequest = false
    
    
}

