//
//  ViewController.swift
//  TouchIdDemo
//
//  Created by Rajat on 4/24/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func authWithTouchId(_ sender: UIButton) {
        // 1
        let context = LAContext()
        var error: NSError?
        
        // 2
        // check if Touch ID is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // 3
            let reason = "Authenticate with Touch ID"
            context.localizedFallbackTitle = "Use Passcode"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply:
                {[unowned self] (succes, error) in
                    // 4
                    if succes {
                        self.showAlertController("Touch ID Authentication Succeeded")
                    }
                    else {
                        self.reportTouchIdError(error: error as! NSError)
//                        self.showAlertController("Touch ID Authentication Failed")
                    }
            })
        }
            // 5
        else {
            showAlertController("Touch ID not available")
        }
    }
    
    func reportTouchIdError(error: NSError) {
        switch error.code {
        case LAError.authenticationFailed.rawValue:
            print("Authentication failed")
        case LAError.passcodeNotSet.rawValue:
            print("Passcode not set")
        case LAError.systemCancel.rawValue:
            print("Authentication was cancelled by the system")
        case LAError.userCancel.rawValue:
            print("user cancel auth")
        case LAError.touchIDNotEnrolled.rawValue:
            print("User has not enrolled any finger with touch id")
        case LAError.touchIDNotAvailable.rawValue:
            print("Touch id not available")
        case LAError.userFallback.rawValue:
            print("User tapped enter password")
        default:
            print(error.localizedDescription)
        }
    }
    
    func showAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
