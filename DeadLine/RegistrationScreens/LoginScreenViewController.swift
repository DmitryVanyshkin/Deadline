//
//  LoginScreenViewController.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 04/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import UIKit

class LoginScreenViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrateButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        renderButtons()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func renderButtons(){
        registrateButton.layer.cornerRadius = 12
        loginButton.layer.cornerRadius = 12
        loginButton.layer.borderWidth = 1.5
        loginButton.layer.borderColor = registrateButton.backgroundColor?.cgColor
    }
    

    @IBAction func signInPress(_ sender: UIButton) {
    
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
