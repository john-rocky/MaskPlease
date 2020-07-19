//
//  Vision.swift
//  MaskPlease
//
//  Created by 間嶋大輔 on 2020/05/12.
//  Copyright © 2020 daisuke. All rights reserved.
//
import UIKit
import Foundation
import Vision
import AVFoundation

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
         if isRequest {
             guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                 return
             }
             currentBuffer = pixelBuffer
             
             let exifOrientation = exifOrientationFromDeviceOrientation()
             let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation, options: [:])
             do {
                 try imageRequestHandler.perform(self.requests)
             } catch {
                 print(error)
             }
             isRequest = false
         }
     }
    
     func setupAVCapture() {
            var deviceInput: AVCaptureDeviceInput!
            
            // Select a video device, make an input
            let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front).devices.first
            do {
                deviceInput = try AVCaptureDeviceInput(device: videoDevice!)
            } catch {
                print("Could not create video device input: \(error)")
                return
            }
            
            session.beginConfiguration()
            session.sessionPreset = .vga640x480 // Model image size is smaller.
            
            // Add a video input
            guard session.canAddInput(deviceInput) else {
                print("Could not add video device input to the session")
                session.commitConfiguration()
                return
            }
            session.addInput(deviceInput)
            if session.canAddOutput(videoDataOutput) {
                session.addOutput(videoDataOutput)
                // Add a video data output
                videoDataOutput.alwaysDiscardsLateVideoFrames = true
                videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
                videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
            } else {
                print("Could not add video data output to the session")
                session.commitConfiguration()
                return
            }
            let captureConnection = videoDataOutput.connection(with: .video)
            captureConnection?.videoOrientation = .portrait
            // Always process the frames
            captureConnection?.isEnabled = true
            do {
                try  videoDevice!.lockForConfiguration()
                let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice?.activeFormat.formatDescription)!)
                bufferSize.width = CGFloat(dimensions.height)
                bufferSize.height = CGFloat(dimensions.width)
                videoDevice!.unlockForConfiguration()
            } catch {
                print(error)
            }
            session.commitConfiguration()
            //        previewLayer = AVCaptureVideoPreviewLayer(session: session)
            //        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            //        rootLayer = previewView.layer
            //        previewLayer.frame = rootLayer.bounds
            //        rootLayer.addSublayer(previewLayer)
            setupVision()
            
            // start the capture
            startCaptureSession()
        }
        
        func startCaptureSession() {
            session.startRunning()
        }
        
        public func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
            let curDeviceOrientation = UIDevice.current.orientation
            let exifOrientation: CGImagePropertyOrientation
            
            switch curDeviceOrientation {
            case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
                exifOrientation = .left
            case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
                exifOrientation = .upMirrored
            case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
                exifOrientation = .down
            case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
                exifOrientation = .up
            default:
                exifOrientation = .up
            }
            return exifOrientation
        }
        
        @discardableResult
        func setupVision() -> NSError? {
            // Setup Vision parts
            let error: NSError! = nil
            
                let faceCropRequest:VNDetectFaceRectanglesRequest = {
                    let request = VNDetectFaceRectanglesRequest(completionHandler: { (request, error) in
                        DispatchQueue.main.async(execute: {
                            // perform all the UI updates on the main queue
                            if let results = request.results {
                                self.drawVisionRequestResults(results)
                            }
                        })
                    })
                    request.revision = VNDetectFaceRectanglesRequestRevision2
                    return request
                }()
                
                self.requests = [faceCropRequest]
            
            return error
        }
        
        func drawVisionRequestResults(_ results: [Any]) {
            if currentBuffer != nil {
                currentBuffer = nil
                guard let observation = results.first as? VNFaceObservation else {
                    masking()
                    return
                }
                noMasking()
            }
        }
}
