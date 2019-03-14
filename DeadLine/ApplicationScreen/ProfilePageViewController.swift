//
//  ProfilePageViewController.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 10/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutFromSystem(_ sender: Any) {
        let mainPart = UIStoryboard(name: "RegistrationScreens", bundle: nil).instantiateInitialViewController() as! RegistrationScreenNavigation
        self.present(mainPart, animated: true, completion: nil)
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
