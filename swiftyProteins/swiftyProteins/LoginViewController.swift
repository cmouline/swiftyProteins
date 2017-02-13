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

        // Do any additional setup after loading the view.
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) { // is TouchID available on the device ? Yes :
            
        } else { // is TouchID available on the device ? No :
            touchIDButtonOutlet.isHidden = true
            let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID, you need Touch ID to use this app.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchIDButton(_ sender: Any) {
        
        let reason = "Identify yourself!"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
            [unowned self] success, authenticationError in
            
            DispatchQueue.main.async {
                if success {
//                        self.runSecretCode()
                    self.performSegue(withIdentifier: "showLigandsList", sender: self)
                } else {
                    let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
