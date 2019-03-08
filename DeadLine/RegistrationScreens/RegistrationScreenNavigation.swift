//
//  RegistrationScreenNavigation.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 08/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import UIKit

class RegistrationScreenNavigation: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func reloadInfoAtRegistrationScreen(){
        let screen = self.viewControllers.filter({$0.restorationIdentifier == "createAccountInfo"}).first!
        (screen as! RegistrationSceenViewController).viewWillAppear(true)
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
