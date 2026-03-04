//
//  IpListInteractor.swift
//  PruebaTecnicaIzzy
//
//  Created by Carlos Salazar Vazquez on 23/02/26.
//
import Foundation

class IpListInteractor:NSObject, IpList_PresenterToInteractor {
    var presenter: IpList_InteractorToPresenter!
    var repository : IpListRepository!
    
    func callApi(_ ip: String)  {
        presenter.showLoader()
        let params = IpListRequest(apiKey: "f0fdac54b7874dd49edd1ba3e4b2f47f" , ip: ip)
        Task {
            let result : Result<IpListEntity, NetworkError> = await WSManager.shared.request(url: APIDefinitions.WS_GET_ip,method: HTTPMethod.GET, body: params, headers: ["Content-Type": "application/json"], retries: 1)
            switch result {
            case .success(let response):
                self.repository.addIpToFireStore(response)
                print("Success:", response.ip)
            case .failure(let error):
                self.presenter.showMessageError(errorMessage: error.localizedDescription)
                print("Error:", error)
            }
        }
    }
    
    func fetchAllIps() {
        presenter.showLoader()
        repository.fetchIps()
    }
    
    func deleteIp(_ idIp: String) {
        presenter.showLoader()
        repository.deleteIp(idIp)
    }
    
}
