//
//  RegistrationSceenViewController.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 04/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import UIKit

//Экран регистрации, тут будет много и объемно
//Опять делегат. Черт возьми, зачем? Чтобы можно было имплементить методы текстового поля - например прописать, что происходит при начале редактирования текстового поля и тд

class RegistrationSceenViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var registrateButton: UIButton!          //Я не буду комментировать, что это за поля, там всё и так очевидно из названий. Будет не понятно - спросите. Маковского, 2, А192(2)
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
    
    var userToAdd = ApplicationData.shared.getUserToAdd     //Мы при регистрации добавляем пользователя на сервер, пускай он будет отдельным полем
    

    override func viewDidLoad() {
        super.viewDidLoad()
        registrateButton.isEnabled = false          //Кнопка регистрации по дефолту недоступна
        preloadButtons()
        self.navigationController?.isNavigationBarHidden = false
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }
    
    func preloadButtons(){
        registrateButton.layer.cornerRadius = 12
    }
    
    
    //Это уже что-то новенькое - метод, вызываемый при появлении этого экрана заново. НЕ ИНИЦИАЛИЗАЦИИ, а появлении именно на свет божий. Это большая разница!!!
    //Зачем это нужно - предположим вы хотите выбрать майнор - вас отбрасывает на другой экран. Так вот, чтобы другие поля не забыли свои значения, мы прогружаем это всё
    override func viewWillAppear(_ animated: Bool) {
        //Я не знаю, что здесь описывать. Мы просто из поля userToAdd разбрасываем его инфу по лейблам, кнопкам и тд
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
        
        //Что за вопросительные знаки?? Тернарный оператор, так меньше строчек уходит, чем если if-конструкция
        
    }
    
    //Метод, вызываемый в тот момент, когда мы перестаем редактировать данные в текстфилде
    //У каждого текстфилда есть уникальный тэг, по которому мы и пониаем, за что он отвечает
    //В зависимости от этого, обновляем у пользователя для добавления то или иное поле
    
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
    
    //Функция проверки на поля. Зачем? В зависимости от того, какой у нас курс и выбрали ли мы курс вообще, становится доступным/недоступным выбор майнора и группы
    
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
    
    
    //Аналогичный метод

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
    
    //Ха-ха-ха, описал несколькими файлами ниже. Я сделал универсальную таблицу для выбора специальности/группы/майнор
    //У каждой кнопки, отвечающей за выбор этих свойств, есть уникальный тег, исходя из которого мы понимаем, что же надо выбирать и с какими данными открывать таблицу
    
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
    
    //Регистрируем пользователя блин, если все поля заполнены, то кнопка регистрации будет доступна и мы сможем всё выбрать
    
    @IBAction func registrateUser(_ sender: UIButton) {
        if sender.isEnabled == true{
            ApplicationData.shared.getServer.newUser(user : userToAdd!)
            userToAdd = nil
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

}

//Расширение на выставления цвета кнопки на каждое состоянии

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
