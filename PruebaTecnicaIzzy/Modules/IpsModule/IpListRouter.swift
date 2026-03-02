//
//  IpListRouter.swift
//  PruebaTecnicaIzzy
//
//  Created by Carlos Salazar Vazquez on 23/02/26.
//

import UIKit

class IpListRouter: IpList_RouterProtocol {
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let storyBoard: UIStoryboard = UIStoryboard(name: "IpListViewController", bundle: nil)
                       let view = storyBoard.instantiateViewController(withIdentifier: "IpListViewController") as! IpListViewController
        let interactor = IpListInteractor()
        let repository = IpListRepository()

        let router = IpListRouter()
        let presenter = IpListPresenter(view: view,interactor: interactor, router: router)
        view.presenter = presenter
        router.viewController = view
        interactor.presenter = presenter
        interactor.repository = repository
        repository.presenter = presenter
        return view
    }
    
    func gotoMap(_ name : String, _ lat:String, _ lon:String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "IpListViewController", bundle: nil)
        let view = storyBoard.instantiateViewController(withIdentifier: "IpLocationViewController") as! IpLocationViewController
        view.lat = lat
        view.lon = lon
        view.name_city = name
        viewController?.navigationController?.pushViewController(view, animated: true)
    }
}
