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
            let result : Result<IpListEntity, NetworkError> = await WSManager.shared.request(url: APIDefinitions.WS_GET_ip,method: HTTPMethod.GET, body: params, headers: [:], retries: 1)
            switch result {
            case .success(let response):
                self.repository.addIpToFireStore(response)
                print("Success:", response.ip)
            case .failure(let error):
                self.presenter.showMessageError(errorMessage: error.localizedDescription)
                print("Error:", error)
            }
        }
        callApiPost()
    }
    
    func callApiPost(){
        let args = Argumentos(deviceId: "iPhone", dispositivo: "IPH", mac: "73:D6:C2:7F:50:92", so: "iOS 17.5", version: "14.7.1", passwordKey: "Masivo1206", telefono: "2288538080")
        let params = ModelRequestTest(token: "7dE2SmhEJEgNqm9ddaPHZ2FfPDbxfFgVi1YvMa7VyAdRtTOhVFZJo6CyM", argumentos: args, apprequesttime: "1722554649480.849121")
        
        Task {
            let result : Result<ModelResponseTest, NetworkError> = await WSManager.shared.request(url: APIDefinitions.WS_GET_POST,method: HTTPMethod.POST, body: params, headers: ["Authorization":"Bearer 479987c7-c264-375f-91d6-55346af3a529"], retries: 1)
            switch result {
            case .success(let response):
                print("Success:", response)
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
