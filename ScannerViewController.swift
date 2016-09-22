//
//  ScannerSwift.swift
//  CodeScanner
//
//  Created by tcs on 9/20/16.
//  Copyright (c) 2016 Raj. All rights reserved.
//

import UIKit
import AVFoundation

public class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice: AVCaptureDevice?

    public var scannedBarCode: ((String) -> ())?

    private var allowedTypes = [AVMetadataObjectTypeUPCECode,
        AVMetadataObjectTypeCode39Code,
        AVMetadataObjectTypeCode39Mod43Code,
        AVMetadataObjectTypeEAN13Code,
        AVMetadataObjectTypeEAN8Code,
        AVMetadataObjectTypeCode93Code,
        AVMetadataObjectTypeCode128Code,
        AVMetadataObjectTypePDF417Code,
        AVMetadataObjectTypeQRCode,
        AVMetadataObjectTypeAztecCode,
        AVMetadataObjectTypeInterleaved2of5Code,
        AVMetadataObjectTypeITF14Code,
        AVMetadataObjectTypeDataMatrixCode]

    public override func viewDidLoad() {
        super.viewDidLoad()
        // Retrieve the default capturing device for using the camera
        self.captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var error: NSError?
        let input: AnyObject!
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        } catch let inputError as NSError {
            error = inputError
            input = nil
        }
        
        if (error != nil) {
            // If any error occurs, simply log the description of it and don't continue any more.
            print("\(error?.localizedDescription)")
            return
        }
        
        // Initialize the captureSession object and set the input device on the capture session.
        captureSession = AVCaptureSession()
        
        captureSession?.addInput(input as! AVCaptureInput)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = self.allowedTypes
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResize
        videoPreviewLayer?.frame = self.view.layer.bounds
        self.view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession?.startRunning()
    }

    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
       
    }

    public override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()

        videoPreviewLayer?.frame = self.self.view.layer.bounds

        let orientation = UIApplication.sharedApplication().statusBarOrientation

        switch (orientation) {
            case UIInterfaceOrientation.LandscapeLeft:
            videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.LandscapeLeft

            case UIInterfaceOrientation.LandscapeRight:
            videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.LandscapeRight

            case UIInterfaceOrientation.Portrait:
            videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.Portrait

            case UIInterfaceOrientation.PortraitUpsideDown:
            videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.PortraitUpsideDown

            default:
            print("Unknown orientation state")
        }
    }

    public override func viewDidLayoutSubviews() {

    }

    public override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        videoPreviewLayer?.frame = self.view.layer.bounds
    }

    public func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {

        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            scannedBarCode!("No Code is detected")
        } else {
            // Get the metadata object.
            let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

            if self.allowedTypes.contains(metadataObj.type) {
                // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
                let _ = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject

                if metadataObj.stringValue != nil {
                    scannedBarCode!(metadataObj.stringValue)
                }
            }
        }
        stopScanning()
    }

    func stopScanning() {
        self.videoPreviewLayer?.removeFromSuperlayer()

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            // do some task
            for out in (self.captureSession?.outputs)! {
                self.captureSession?.removeOutput(out as! AVCaptureOutput)
            }
            self.captureSession?.stopRunning()
            self.videoPreviewLayer = nil
        }
        self.navigationController?.popViewControllerAnimated(true)
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
