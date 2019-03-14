//
//  LoginFullViewController.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 08/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import UIKit

class LoginFullViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var wrongInfoLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled = false
        preloadButton()
        self.navigationController?.isNavigationBarHidden = false
        wrongInfoLabel.isHidden = true
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    
    func preloadButton(){
        loginButton.layer.cornerRadius = 12
        loginButton.setButtonColor()
    }
    
    @IBAction func checkForFullFields(_ sender: Any) {
        if (!loginField.text!.isEmpty && !passwordField.text!.isEmpty){
            loginButton.isEnabled = true
        }
        else{
            loginButton.isEnabled = false
            
        }
        wrongInfoLabel.isHidden = true
        loginButton.setButtonColor()
    }
    
    
    @IBAction func loginPress(_ sender: Any) {
        
        ApplicationData.shared.currentUser = ApplicationData.shared.server.authorizeUser(email: loginField.text!, password: passwordField.text!) ?? userDmitriy
        
        if (ApplicationData.shared.currentUser != nil){
            let mainPart = UIStoryboard(name: "ApplicationScreens", bundle: nil).instantiateInitialViewController() as! UITabBarController
            self.present(mainPart, animated: true, completion: nil)
        }
        else{
            wrongInfoLabel.isHidden = false
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
}
