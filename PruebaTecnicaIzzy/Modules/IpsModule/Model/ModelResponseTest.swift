//
//  Untitled.swift
//  PruebaTecnicaIzzy
//
//  Created by Charls Salazar on 04/03/26.
//

struct ModelResponseTest: Codable {
    let codigoRespuesta: Int
    let mensajeRespuesta: String
    let alertaDetalle: AlertaDetalle
}

struct AlertaDetalle: Codable {
    let titulo: String
    let body: String
    let tipo: String
}
