//
//  ContentView.swift
//  asyncLet
//
//  Created by Dip Dutt on 14/3/23.
//

import SwiftUI

struct ContentView: View {
    @State var images:[UIImage] = []
    let columns = [GridItem(.flexible()),GridItem(.flexible())]
    let url = URL(string: "https://picsum.photos/300")!
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height:150 )
                    }
                    
                }
            }
            .navigationTitle("Asynclet🥳")
            
        }
        .onAppear {
            Task {
                
                async let showImage1 = fetchImage()
                async let showImage2 = fetchImage()
                async let showImage3 = fetchImage()
                async let showImage4 = fetchImage()
                
                let (image1,image2,image3,image4) = await ( try showImage1, try showImage2,try showImage3, try showImage4)
                
                self.images.append(contentsOf: [image1,image2,image3,image4])
                
//                let Image1 = try await fetchImage()
//                self.images.append(Image1)
//
//                 let Image2 = try await fetchImage()
//                self.images.append(Image2)
//
//
//                 let Image3 = try await fetchImage()
//                self.images.append(Image3)
//
//                 let Image4 = try await fetchImage()
//                self.images.append(Image4)
                
                
                
            }
            
        }
    }
    func fetchImage() async throws -> UIImage {
        do {
            let (data,_) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                return image
            }
            else {
                throw URLError(.badURL)
            }
        } catch  {
            throw error
        }
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
