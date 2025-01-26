//
//  ANFImageView.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/24/25.
//

import SwiftUI
import Combine

struct ANFImageView: View {
    
    @ObservedObject var imageLoader:ImageLoader = ImageLoader()
    @State private var image: Image
    @State private var remotePath: String
    
    var completion: (Image) -> Void = {_ in }
    
    init(image: Image, remotePath: String, loadCompletion: @escaping (Image) -> Void){
        self.image = image
        self.remotePath = remotePath
        self.completion = loadCompletion
        loadImage(urlString: remotePath, placeholder: image)
    }
    
    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .onReceive(imageLoader.dataPublisher) { data in
                if data == image { return }
                self.image = data
                self.completion(data)
            }
    }
    
    func loadImage(urlString: String, placeholder: Image?, loadCompletion: Void? = nil) {
        imageLoader.loadImage(from: urlString, placeholder: placeholder)
    }
}

#Preview {
    VStack {
        ANFImageView(
            image: Image("anf-US-20160601-app-women-dresses"),
            remotePath: "https://placecats.com/300/200",
            loadCompletion: {_ in }
        )
    }
}

class ImageLoader: ObservableObject {
    
    var dataPublisher = PassthroughSubject<Image, Never>()
    
    var img = Image(uiImage: UIImage()) {
        didSet {
            Task { @MainActor in
                dataPublisher.send(img)
            }
        }
    }
    
    func loadImage(from path: String, placeholder: Image?) {
        if let placeholder {
            self.img = placeholder
        }
        
        //  Only Load Remote URLs
        guard let url = URL(string: path),
              url.absoluteString.starts(with: "http")
        else { return }
        
        Task {
            do {
                let (data, _)  = try await URLSession.shared.data(from: url)
                img = Image(uiImage: UIImage(data: data) ?? UIImage())
            } catch {
                print("Could not load image: \(url.absoluteString), error: \(error.localizedDescription)")
            }
        }
    }
    
    
//
//    func loadImage(fromURL path: String) async -> UIImage {
//        if let img = UIImage(named: path) {
//            print("Placeholder")
//            return img
//        } else if let imgURL = URL(string: path) {
//            print("URL")
//            do {
//                let (data, _)  = try await URLSession.shared.data(from: imgURL)
//                print("Got Data")
//                return UIImage(data: data) ?? UIImage()
//            } catch {
//                return UIImage()
//            }
//        }
//        return UIImage()
//    }
//    
//    func set(path: String) {
//        Task {
//            self.img = await loadImage(fromURL: path)
//        }
//    }
    
//    init(urlString:String) {
//        guard let url = URL(string: urlString) else { return }
//        
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else { return }
//            DispatchQueue.main.async {
//                self.data = data
//            }
//        }
//        task.resume()
//    }
}
