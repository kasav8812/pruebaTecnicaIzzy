//
//  SplashScreenViewController.swift
//  PruebaTecnicaIzzy
//
//  Created by Carlos Salazar Vazquez on 23/02/26.
//

import UIKit

class SplashScreenViewController: UIViewController {
    @IBOutlet weak var titleLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("Prueba Técnica IP List")
        delaySplash()
    }
    
    func setTitle(_ mTitle : String){
        titleLbl.text = mTitle
    }
    
    func delaySplash(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.loadModule()
        }
    }
    
    func loadModule(){
        let mNC = UINavigationController(rootViewController: IpListRouter.createModule())
        mNC.modalPresentationStyle = .overCurrentContext
        self.present(mNC,animated: true,completion: nil)
    }
}
