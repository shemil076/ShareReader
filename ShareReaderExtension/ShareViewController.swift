//
//  ShareViewController.swift
//  ShareReaderExtension
//
//  Created by Pramuditha Karunarathna on 2024-09-23.
//

import UIKit
import Social
import SwiftUI
import SwiftData

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .red
        
        isModalInPresentation = true
        
        if let itemProviders = (extensionContext!.inputItems.first as? NSExtensionItem)?.attachments {
            let hostingView = UIHostingController(rootView: ShareView(intemProviders: itemProviders , extentionContext: extensionContext))
            hostingView.view.frame = view.frame
            view.addSubview(hostingView.view)
        }
        
        
    }
}


fileprivate struct ShareView : View {
    var intemProviders : [NSItemProvider]
    var extentionContext : NSExtensionContext?
//    view properties
    
    @State  private var items: [Item] = []
    var body: some View {
        GeometryReader{
            let size = $0.size
            
            VStack(spacing: 15){
                Text("Add to share Reader")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .leading){
                        Button("Cancel", action: dismiss)
                            .tint(.red)
                    }
                    .padding(.bottom, 10)
                
                ScrollView(.horizontal){
                    LazyHStack(spacing: 10){
                        ForEach(items) { item in
                            Image(uiImage: item.previrewImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: size.width - 30)
                        }
                    }
                    .padding(.horizontal, 15)
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .frame(height: 300)
                .scrollIndicators(.hidden)
                
//                Save Button
                
                Button {
                    SaveItems()
                } label: {
                    Text("Save")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.vertical,10)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(.blue, in: .rect(cornerRadius: 10))
                        .contentShape(.rect)
                }

                
                Spacer(minLength: 0)
            }
            .padding(15)
            .onAppear(perform: {
                extractItems(size: size)
            })
            
        }
        
    }
    
    
//    Extrscting image data and createing Thumbnail preview iamges
    
    func extractItems(size: CGSize){
        guard items.isEmpty else{ return }
        DispatchQueue.global(qos: .userInteractive).async {
            for provider in intemProviders{
                let _ = provider.loadDataRepresentation(for: .image){data, error in
                    if let data, let image = UIImage(data: data), let thumbnail = image.preparingThumbnail(of: .init(width: size.width, height:300)){
                        /// UI must be updated on main thread
                        DispatchQueue.main.async {
                            items.append(.init(imageData: data, previrewImage: thumbnail))
                        }
                    }
                }
            }
        }
        
    }
    
//    Saving items to switf data
    
    func SaveItems(){
        do {
            let context = try ModelContext(.init(for: ImageItem.self))
//            saving Items
            
            for item in items{
                context.insert(ImageItem(data: item.imageData))
            }
            
//            Saving context
            try context.save()
            
//            closing
            dismiss()
        }catch{
            print(error.localizedDescription)
            dismiss()
        }
    }
    
    func dismiss(){
        extentionContext?.completeRequest(returningItems: [])
    }
    
    private struct Item: Identifiable{
        let id: UUID = .init()
        var imageData : Data
        var previrewImage: UIImage
    }
        
}
