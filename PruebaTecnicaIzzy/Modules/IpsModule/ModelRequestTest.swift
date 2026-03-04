//
//  ModelRequestTest.swift
//  PruebaTecnicaIzzy
//
//  Created by Charls Salazar on 04/03/26.
//

import UIKit

struct ModelRequestTest: Codable {
    let token: String
    let argumentos: Argumentos
    let apprequesttime: String
}

struct Argumentos: Codable {
    let deviceId: String
    let dispositivo: String
    let mac: String
    let so: String
    let version: String
    let passwordKey: String
    let telefono: String
}
