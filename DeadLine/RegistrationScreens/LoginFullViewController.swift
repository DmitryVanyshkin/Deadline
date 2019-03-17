//
//  LoginFullViewController.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 08/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import UIKit

//Класс, отвечабющаий за экран, на котором мы вводим логин и пароль

class LoginFullViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var loginField: UITextField!     //Текстовое поле для введения эл почты и пароля
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var wrongInfoLabel: UILabel!     //Текстовый лейбл, вызвающийся в случае введения неправильных данных
    @IBOutlet weak var loginButton: UIButton!       //Кнопка для логина. Гы
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.isSecureTextEntry = true      //Пароль - штука секретная, поэтому на экране будут выводиться точки вместо символов пароля
        loginButton.isEnabled = false               //Кнопку логина надо сделать недоступной, пока не оба поля пустые
        preloadButton()
        self.navigationController?.isNavigationBarHidden = false
        wrongInfoLabel.isHidden = true
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    
    func preloadButton(){               //Наводим красоту - скругления кнопок и выставления цветов - подобные методы есть в различных классах, я опишу только здесь
        loginButton.layer.cornerRadius = 12
        loginButton.setButtonColor()
    }
    
    @IBAction func checkForFullFields(_ sender: Any) {      //Метод, вызываемый при каждом изменении текстового поля - проверяет, а нет или у нас пустых полей и в зависимости от этого делает кнопку входа доступной/недоступной
        if (!loginField.text!.isEmpty && !passwordField.text!.isEmpty){
            loginButton.isEnabled = true
        }
        else{
            loginButton.isEnabled = false
            
        }
        wrongInfoLabel.isHidden = true
        loginButton.setButtonColor()
    }
    
    
    @IBAction func loginPress(_ sender: Any) {  //Действие, происходящее при нажатии кнопки входа в систему
        
        ApplicationData.shared.currentUser = ApplicationData.shared.server.authorizeUser(email: loginField.text!, password: passwordField.text!)    //Делаем авторизацию - для этого запрашиваем у пока что локального сервера, есть ли такие логины и пароли
        //Данный метод вернет пользователя, если таковой есть и nil, если такового нет. ПРИМЕЧАНИЕ nil == NULL
        
        if (ApplicationData.shared.currentUser != nil){ //Если пользователь нашелся, то загружаем экран основного приложения
            let mainPart = UIStoryboard(name: "ApplicationScreens", bundle: nil).instantiateInitialViewController() as! UITabBarController
            self.present(mainPart, animated: true, completion: nil)
        }
        else{       //Если такого пользователя нет, то появится лейбл, уведомляющий о неверном входе
            wrongInfoLabel.isHidden = false
        }
    }
    
}

//ПРИМЕЧАНИЕ Что такое extension - расширение класса, которое мы можем использовать для всех классов, унаследованных от указанного

extension UIViewController {            //Кастомное расширение для всех классов экранов - прячет клавиатуру, если мы нажали в пустое место экрана - так жить удобнее
    func hideKeyboardWhenTappedAround() {       //Метод фиксации жеста и проверка, находится ли он за пределами клавиатуры
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
}
