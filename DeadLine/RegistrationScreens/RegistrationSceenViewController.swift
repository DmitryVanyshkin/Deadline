//
//  RegistrationSceenViewController.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 04/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import UIKit

class RegistrationSceenViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var registrateButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var middleNameTextField: UITextField!
    @IBOutlet weak var specNameLabel: UILabel!
    @IBOutlet weak var minorNameLabel: UILabel!
    @IBOutlet weak var gradeNameLabel: UILabel!
    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var minorView: UIView!
    
    var userToAdd = ApplicationData.shared.getUserToAdd
    

    override func viewDidLoad() {
        super.viewDidLoad()
        registrateButton.isEnabled = false
        preloadButtons()

        // Do any additional setup after loading the view.
    }
    
    func preloadButtons(){
        registrateButton.layer.cornerRadius = 12
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registrateButton.isEnabled = false
        checkForFields()
        groupView.isHidden = false
        minorView.isHidden = false
        userToAdd = ApplicationData.shared.getUserToAdd
        checkForAllFieldsFull()
        guard let userInfo = userToAdd else {
            specNameLabel.text = "Выберите специальность"
            gradeNameLabel.text = "Выберите группу"
            minorNameLabel.text = "Выберите майнор"
            return
        }
        
        emailTextField.text = userInfo.getEmail
        passwordTextField.text = userInfo.getPassword
        lastNameTextField.text = userInfo.getLastName
        firstNameTextField.text = userInfo.getFirstName
        middleNameTextField.text = userInfo.getMiddleName
        specNameLabel.text = userInfo.getSpecializeFull.isEmpty ? "Выберите специальность" : userInfo.getSpecializeFull
        minorNameLabel.text = userInfo.getMinor.isEmpty ? "Выберите майнор" : userInfo.getMinor
        gradeNameLabel.text = userInfo.getGroup.isEmpty ? "Выберите группу" : userInfo.getGroup
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            userToAdd?.setEmail(email: textField.text!)
        case 1:
            userToAdd?.setPassword(password: textField.text!)
        case 2:
            userToAdd?.setLastName(name: textField.text!)
        case 3:
            userToAdd?.setFirstName(name: textField.text!)
        case 4:
            userToAdd?.setFatherName(name: textField.text!)
        default:
            break
        }
        
        checkForFields()
    }
    
    
    func checkForFields(){
        userToAdd = ApplicationData.shared.getUserToAdd
        guard let _ = userToAdd else{
            return
        }
        if !(emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty || lastNameTextField.text!.isEmpty || firstNameTextField.text!.isEmpty || middleNameTextField.text!.isEmpty || specNameLabel.text!.isEmpty || userToAdd!.getSpecializeFull.isEmpty || userToAdd!.getGroup.isEmpty){
            let grade = userToAdd!.countGrade ?? -1
            if (grade == 2 || grade == 3){
                if !(userToAdd!.getMinor.isEmpty){
                    registrateButton.isEnabled = true
                }
                else{
                    registrateButton.isEnabled = false
                }
            }
            else{
                registrateButton.isEnabled = true
            }
            
        }
        else{
            registrateButton.isEnabled = false
        }
        registrateButton.setButtonColor()
    }
    
    

    func checkForAllFieldsFull(){
        guard let userInfo = userToAdd else{
            groupView.isHidden = true
            minorView.isHidden = true
            return
        }
        
        guard let grade = userInfo.countGrade else {
            minorView.isHidden = true
            return
        }
        
        
        if (userInfo.getSpecializeFull.isEmpty){
            groupView.isHidden = true
            minorView.isHidden = true
        }
        
        if (grade < 2 || grade > 3){
            minorView.isHidden = true
        }
    }
    
    
    
    func renderButtons(){
        registrateButton.layer.cornerRadius = 12
    }
    
    @IBAction func openChooseTable(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            ApplicationData.shared.setDisplay(what: WhatDisplay.groupName)
        case 1:
            ApplicationData.shared.setDisplay(what: WhatDisplay.groupNumber)
        case 2:
            ApplicationData.shared.setDisplay(what: WhatDisplay.minors)
        default:
            break
        }
        self.performSegue(withIdentifier: "ShowChooseTable", sender: nil)
    }
    
    @IBAction func registrateUser(_ sender: UIButton) {
        if sender.isEnabled == true{
            ApplicationData.shared.getServer.newUser(user : userToAdd!)
            userToAdd = nil
            self.navigationController?.popToRootViewController(animated: true)
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

extension UIButton{
    func setButtonColor(){
        switch self.state {
        case .disabled:
            self.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.8, alpha: 1.0)
        case .normal:
            self.backgroundColor = UIColor(red: 0, green: 0.458, blue: 1, alpha: 1.0)
        default:
            break
        }
    }
}
