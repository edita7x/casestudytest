//
//  HomeItemDto.swift
//  alteacareTest
//
//  Created by Edit sanrio Putra on 26/10/22.
//

import Foundation

struct HomeItemDto: Codable {
    let doctor_id, name, slug, about: String
    let photo : DoctorImg
    let price: Price
    let specialization : Specialization
    let hospital : [Hospital]
    
}

struct DoctorImg : Codable {
    let formats: photoSize
}

struct photoSize : Codable {
    let small, medium, large, thumbnail: String
    
}

struct Price : Codable {
    let formatted: String
}

struct Specialization : Codable {
    let id, name : String
}

struct Hospital : Codable {
    let id, name : String
}
