//
//  ViewController.swift
//  CodeScanner
//
//  Created by tcs on 9/20/16.
//  Copyright © 2016 Raj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var barcodeScanner: ScannerViewController?

    @IBOutlet weak var barcodeLabels: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func scannerView(sender: AnyObject) {
        barcodeScanner = self.storyboard!.instantiateViewControllerWithIdentifier("ScannerView") as? ScannerViewController
        barcodeScanner?.title = "Scan Pass"

        if let barcodeScanner = self.barcodeScanner {
            self.navigationController?.pushViewController(barcodeScanner, animated: true)
        }

        barcodeScanner?.scannedBarCode = { (barcode: String) in
            print("Received following barcode: \(barcode)")
            dispatch_async(dispatch_get_main_queue(), {
                self.barcodeLabels.text = barcode
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

