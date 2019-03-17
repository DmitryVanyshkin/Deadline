//
//  RegistrationScreenNavigation.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 08/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import UIKit
//Класс экраена навигации - скорее всего будет использоваться в дальнейшем для централизаци некоторых процессов
class RegistrationScreenNavigation: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func reloadInfoAtRegistrationScreen(){
        let screen = self.viewControllers.filter({$0.restorationIdentifier == "createAccountInfo"}).first!
        (screen as! RegistrationSceenViewController).viewWillAppear(true)
    }
    


}
