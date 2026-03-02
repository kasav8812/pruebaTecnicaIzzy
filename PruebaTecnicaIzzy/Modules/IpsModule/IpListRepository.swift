//
//  IpListRepository.swift
//  PruebaTecnicaIzzy
//
//  Created by Charls Salazar on 01/03/26.
//

import FirebaseCore
import FirebaseFirestore

class IpListRepository: NSObject {
    var presenter: IpList_InteractorToPresenter!

    func addIpToFireStore(_ mItem : IpListEntity) {
        var mObject = mItem
        mObject.mId = UUID().uuidString
        do {
            try Firestore.firestore().collection("BDTest").document(mObject.mId ?? UUID().uuidString).setData(from: mObject)
            fetchIps()
        } catch {
            presenter.showMessageError(errorMessage: error.localizedDescription)
            print("Error writing document: \(error)")
        }
    }
    
    func fetchIps(){
        Task {
            do {
                let snapshot = try await Firestore.firestore().collection("BDTest").getDocuments()
                let item = snapshot.documents.compactMap { document in
                    try? document.data(as: IpListEntity.self)
                }
                presenter.retrieveIps(item)
            } catch {
                presenter.showMessageError(errorMessage: error.localizedDescription)
                print("Error writing document: \(error)")
            }
        }
    }
    
    func deleteIp(_ id: String){
        Task{
            do {
                try await Firestore.firestore().collection("BDTest").document(id).delete()
                fetchIps()
            } catch {
                presenter.showMessageError(errorMessage: error.localizedDescription)
                print("Error writing document: \(error)")
            }
        }
    }
    
}
