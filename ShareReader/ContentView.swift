//
//  ContentView.swift
//  ShareReader
//
//  Created by Pramuditha Karunarathna on 2024-09-23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var allItems: [ImageItem]
    var body: some View {
        NavigationStack{
            ScrollView (.vertical){
                LazyVStack(spacing: 15){
                    ForEach(allItems){ item in
                        CardView(item: item)
                            .frame(height: 250)
                    }
                }
                .padding(15)
            }
            .navigationTitle("Favourites")
        }
    }
}


// cardView

struct CardView: View {
    var item: ImageItem
    
    @State private var previewUmage : UIImage?
    var body: some View {
        GeometryReader{
            let size = $0.size
            
            if let previewUmage{
                Image(uiImage: previewUmage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.width, height: size.height)
                
            }else{
                ProgressView()
                    .frame(width: size.width, height: size.height)
                    .task {
                        Task.detached(priority: .high){
                            let thumbnail = await UIImage(data: item.data)?.byPreparingThumbnail(ofSize: size)
                            await MainActor.run {
                                previewUmage = thumbnail
                            }
                        }
                    }
            }
            
            
        }
    }
}

#Preview {
    ContentView()
}
