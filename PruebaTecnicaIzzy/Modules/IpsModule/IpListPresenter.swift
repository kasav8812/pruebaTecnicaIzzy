//
//  IpListPresenter.swift
//  PruebaTecnicaIzzy
//
//  Created by Carlos Salazar Vazquez on 23/02/26.
//

import UIKit

class IpListPresenter {
    var view: IpList_PresenterToView?
    var interactor : IpList_PresenterToInteractor?
    private let router: IpList_RouterProtocol
    init(view: IpList_PresenterToView? = nil, interactor: IpList_PresenterToInteractor? = nil, router: IpList_RouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension IpListPresenter: IpList_ViewToPresenter {
    func gotoMap(name: String, lat: String, lon: String) {
        router.gotoMap(name, lat, lon)
    }
    
    func getIps(ipSearch : String) {
        interactor?.callApi(ipSearch)
    }
}

extension IpListPresenter: IpList_InteractorToPresenter {
    func showLoader() {
        view?.showLoader()
    }
    
    func retrieveIps(_ responseList: IpListEntity) {
        view?.dismissLoader()
        view?.showListIps(responseList)
    }
    
    func showMessageError(errorMessage: String) {
        view?.dismissLoader()
        view?.displayMessageError(errorMessage: errorMessage)
    }
}



protocol IpList_ViewToPresenter{
    func getIps(ipSearch: String)
    func gotoMap(name : String, lat:String, lon:String)
}

protocol IpList_PresenterToInteractor{
    func callApi(_ ip: String)
}

protocol IpList_InteractorToPresenter{
    func retrieveIps(_ responseList: IpListEntity)
    func showMessageError(errorMessage : String)
    func showLoader()
}

protocol IpList_PresenterToView{
    func showListIps(_ responseList : IpListEntity)
    func displayMessageError(errorMessage : String)
    func dismissLoader()
    func showLoader()
}

protocol IpList_RouterProtocol{
    func gotoMap(_ name : String, _ lat:String, _ lon:String)
}
