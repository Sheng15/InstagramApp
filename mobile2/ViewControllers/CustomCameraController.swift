//
//  CustomCameraController.swift
//  mobile2
//
//  Created by username on 18/10/18.
//  Copyright © 2018 LudwiG. All rights reserved.
//

import UIKit
import AVFoundation

class CustomCameraController: UIViewController {
    
    var captureSession = AVCaptureSession()
    private var sessionQueue: DispatchQueue!
    var backCamera : AVCaptureDevice!
    var frontCamera : AVCaptureDevice!
    var currentCamera : AVCaptureDevice!
    
    var photoOutput : AVCapturePhotoOutput!
    var cameraPreviewLayer : AVCaptureVideoPreviewLayer!
    var usingFrontCamera = false
    var image :UIImage?
    
    var flashMode: AVCaptureDevice.FlashMode = .on
    var settings : AVCapturePhotoSettings!
    
    enum CurrentFlashMode {
        case off
        case on
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settings = AVCapturePhotoSettings()
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPerviewLayer()
        startRunningCaptureSession()
    }
    
    func setupCaptureSession(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        sessionQueue = DispatchQueue(label: "session queue")
        
    }
    
    func setupDevice(usingFrontCamera: Bool = false) {
        sessionQueue.async {
            let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
            let devices = deviceDiscoverySession.devices
            
            for device in devices{
                if usingFrontCamera && device.position == .front {
                    self.currentCamera = device
                } else if device.position == .back {
                    self.currentCamera = device
                }
            }
        }
    }
    
    func setupInputOutput(){
        sessionQueue.sync {
            do{
                let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera)
                if self.captureSession.canAddInput(captureDeviceInput) {
                    self.captureSession.addInput(captureDeviceInput)
                }
                photoOutput = AVCapturePhotoOutput()
                photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])],completionHandler: nil)
                if self.captureSession.canAddOutput(photoOutput) {
                    self.captureSession.addOutput(photoOutput)
                }
            }catch{
                print(error)
            }
        }
    }
    
    func setupPerviewLayer(){
        cameraPreviewLayer = AVCaptureVideoPreviewLayer (session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    func startRunningCaptureSession(){
        captureSession.startRunning()
    }
    

    @IBAction func cameraButtonOnClick(_ sender: UIButton) {
        photoOutput?.capturePhoto(with: settings, delegate: self)
        //performSegue(withIdentifier: "cameraToFilter", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FilterController{
            vc.image = self.image
        }
    }
    
    @IBAction func cancelButtonOnClock(_ sender: UIButton) {
        performSegueToReturnBack()
    }


    @IBAction func gridButtonOnClick(_ sender: UIButton) {
    }
    
    @IBAction func flashButtonOnClick(_ sender: UIButton) {
        if self.currentCamera.isFlashAvailable {
            
            if flashMode == .on {
                settings.flashMode = .off
                flashMode = .off
            } else {
                settings.flashMode = .on
                flashMode = .on
            }
        }
        
    }
    
    
}



extension CustomCameraController: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(){
            image = UIImage(data: imageData)
            performSegue(withIdentifier: "cameraToFilter", sender: nil)

        }
    }
    
    func performSegueToReturnBack(){
        if let nav = self.navigationController{
            nav.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
        
    }
}
