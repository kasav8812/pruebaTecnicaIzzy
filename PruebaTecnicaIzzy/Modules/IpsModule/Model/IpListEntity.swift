//
//  IpListEntity.swift
//  PruebaTecnicaIzzy
//
//  Created by Carlos Salazar Vazquez on 23/02/26.
//

import Foundation
import FirebaseFirestore

struct IpListEntity : Codable {
    var mId: String?
    let ip: String
    let location: Location
    let countryMetadata: CountryMetadata
    let currency: Currency
    let asn: ASN
    let timeZone: TimeZoneInfo

    enum CodingKeys: String, CodingKey {
        case mId = "id"
        case ip
        case location
        case countryMetadata = "country_metadata"
        case currency
        case asn
        case timeZone = "time_zone"
    }
}


struct Location: Codable {
    let continentCode: String
    let continentName: String
    let countryCode2: String
    let countryCode3: String
    let countryName: String
    let countryNameOfficial: String
    let countryCapital: String
    let stateProv: String
    let stateCode: String
    let district: String
    let city: String
    let zipcode: String
    let latitude: String
    let longitude: String
    let isEU: Bool
    let countryFlag: String
    let geonameId: String
    let countryEmoji: String

    enum CodingKeys: String, CodingKey {
        case continentCode = "continent_code"
        case continentName = "continent_name"
        case countryCode2 = "country_code2"
        case countryCode3 = "country_code3"
        case countryName = "country_name"
        case countryNameOfficial = "country_name_official"
        case countryCapital = "country_capital"
        case stateProv = "state_prov"
        case stateCode = "state_code"
        case district, city, zipcode, latitude, longitude
        case isEU = "is_eu"
        case countryFlag = "country_flag"
        case geonameId = "geoname_id"
        case countryEmoji = "country_emoji"
    }
}

struct CountryMetadata: Codable {
    let callingCode: String
    let tld: String
    let languages: [String]

    enum CodingKeys: String, CodingKey {
        case callingCode = "calling_code"
        case tld
        case languages
    }
}

struct Currency: Codable {
    let code: String
    let name: String
    let symbol: String
}

struct ASN: Codable {
    let asNumber: String
    let organization: String
    let country: String

    enum CodingKeys: String, CodingKey {
        case asNumber = "as_number"
        case organization
        case country
    }
}

struct TimeZoneInfo: Codable {
    let name: String
    let offset: Int
    let offsetWithDst: Int
    let currentTime: String
    let currentTimeUnix: Double
    let currentTzAbbreviation: String
    let currentTzFullName: String
    let standardTzAbbreviation: String
    let standardTzFullName: String
    let isDst: Bool
    let dstSavings: Int
    let dstExists: Bool
    let dstTzAbbreviation: String
    let dstTzFullName: String
    let dstStart: DSTChange
    let dstEnd: DSTChange

    enum CodingKeys: String, CodingKey {
        case name, offset
        case offsetWithDst = "offset_with_dst"
        case currentTime = "current_time"
        case currentTimeUnix = "current_time_unix"
        case currentTzAbbreviation = "current_tz_abbreviation"
        case currentTzFullName = "current_tz_full_name"
        case standardTzAbbreviation = "standard_tz_abbreviation"
        case standardTzFullName = "standard_tz_full_name"
        case isDst = "is_dst"
        case dstSavings = "dst_savings"
        case dstExists = "dst_exists"
        case dstTzAbbreviation = "dst_tz_abbreviation"
        case dstTzFullName = "dst_tz_full_name"
        case dstStart = "dst_start"
        case dstEnd = "dst_end"
    }
}

struct DSTChange: Codable {
    let utcTime: String
    let duration: String
    let gap: Bool
    let dateTimeAfter: String
    let dateTimeBefore: String
    let overlap: Bool

    enum CodingKeys: String, CodingKey {
        case utcTime = "utc_time"
        case duration
        case gap
        case dateTimeAfter = "date_time_after"
        case dateTimeBefore = "date_time_before"
        case overlap
    }
}
