//
//  ImageItem.swift
//  ShareReader
//
//  Created by Pramuditha Karunarathna on 2024-09-23.
//

import SwiftUI
import SwiftData

@Model
class ImageItem{
    @Attribute(.externalStorage)
    var data: Data
    init(data: Data){
        self.data = data
    }
}
