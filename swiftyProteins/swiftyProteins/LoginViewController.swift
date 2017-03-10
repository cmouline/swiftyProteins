//
//  LoginViewController.swift
//  swiftyProteins
//
//  Created by Chloe MOULINET on 2/9/17.
//  Copyright © 2017 Chloe MOULINET. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {

    let context = LAContext()
    var error: NSError?

    @IBOutlet weak var touchIDButtonOutlet: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) { // is TouchID available on the device ? Yes :
            
        } else { // is TouchID available on the device ? No :
            touchIDButtonOutlet.isHidden = true
            let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID, you need Touch ID to use this app.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            ac.view.tintColor = UIColor.red // change text color of the buttons
            ac.view.backgroundColor = UIColor.red  // change background color
            ac.view.layer.cornerRadius = 25   // change corner radius
            present(ac, animated: true)
        }
    }
    
    @IBAction func touchIDButton(_ sender: Any) {
        
        let reason = "Identify yourself!"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
            [unowned self] success, error in

            DispatchQueue.main.async {
            
                if success {
                    
                    self.performSegue(withIdentifier: "showLigandsList", sender: self)
                    
                } else {
                
                    if let errorObj = error as? NSError {
                        print("error: \(errorObj)")
                        print("error: \(errorObj.code)")
                        var message = "Touch ID may not be configured"
                        
                        switch errorObj.code {
                        case LAError.authenticationFailed.rawValue :
                            message = "There was a problem verifying your identity."
                        case LAError.userCancel.rawValue:
                            message = "Authentication canceled."
                            // Fallback button was pressed and an extra login step should be implemented for iOS 8 users.
                        // By the other hand, iOS 9+ users will use the pasccode verification implemented by the own system.
                        case LAError.userFallback.rawValue:
                            message = "You can only identify yourself with Touch ID."
                        case LAError.systemCancel.rawValue:
                            message = "An error happened and authentication was canceled by the system. Please try again."
                        case LAError.passcodeNotSet.rawValue:
                            message = "Passcode is not set on the device."
                        case LAError.touchIDNotAvailable.rawValue:
                            message = "Touch ID is not available on the device."
                        case LAError.touchIDNotEnrolled.rawValue:
                            message = "Touch ID has no enrolled fingers."
                        // iOS 9+ functions
                        case LAError.touchIDLockout.rawValue:
                            message = "There were too many failed Touch ID attempts and Touch ID is now locked."
                        case LAError.appCancel.rawValue:
                            message = "Authentication was canceled by application."
                        case LAError.invalidContext.rawValue:
                            message = "LAContext passed to this call has been previously invalidated."
                        // MARK: IMPORTANT: There are more error states, take a look into the LAError struct
                        default:
                            message = "Touch ID may not be configured"
                            break
                        }
                     
                        let ac = UIAlertController(title: "Authentication failed", message: message, preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        ac.view.tintColor = UIColor.red // change text color of the buttons
                        ac.view.backgroundColor = UIColor.red  // change background color
                        ac.view.layer.cornerRadius = 25   // change corner radius
                        self.present(ac, animated: true)
                        
                    }
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
