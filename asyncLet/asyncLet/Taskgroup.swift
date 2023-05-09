//
//  Taskgroup.swift
//  asyncLet
//
//  Created by Dip Dutt on 14/3/23.
//

import SwiftUI


class imageView {
  func fetchImagesAsyncLet()async throws ->[UIImage] {
    async let showImage1 = fetchImage(urlString:"https://picsum.photos/300" )
    async let showImage2 = fetchImage(urlString:"https://picsum.photos/300" )
    async let showImage3 = fetchImage(urlString:"https://picsum.photos/300" )
    async let showImage4 = fetchImage(urlString:"https://picsum.photos/300" )
    let (image1,image2,image3,image4) = await ( try showImage1, try showImage2,try showImage3, try showImage4)
    return [image1,image2,image3,image4]
}
    
    func FetchImagesTaskgroup() async throws ->[UIImage] {
        let urlstrings = ["https://picsum.photos/300","https://picsum.photos/300","https://picsum.photos/300","https://picsum.photos/300","https://picsum.photos/300"]
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            var images:[UIImage] = []
            
            
            for urlstring in urlstrings {
                group.addTask {
                    try? await self.fetchImage(urlString: urlstring)
                }
            }
            
            //            group.addTask() {
            //                try await self.fetchImage(urlString: "https://picsum.photos/300")
            //
            //            }
            //            group.addTask() {
            //                try await self.fetchImage(urlString: "https://picsum.photos/300")
            //            }
            //
            //            group.addTask() {
            //                try await self.fetchImage(urlString: "https://picsum.photos/300")
            //            }
            //
            //            group.addTask() {
            //                try await self.fetchImage(urlString: "https://picsum.photos/300")
            //            }
            
            for  try await image in group {
                if let image = image {
                    images.append(image)
                }
            }
            return images
        }
    }

    
    func fetchImage(urlString:String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
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

class TaskgroupviewModel:ObservableObject {
    @Published var images:[UIImage] = []
    let classManager = imageView()
    
    func getImages() async {
        
        if let images = try? await classManager.FetchImagesTaskgroup() {
            self.images.append(contentsOf: images)
        }
    }
}

struct Taskgroup: View {
    @StateObject var viewModel = TaskgroupviewModel()
    let columns = [GridItem(.flexible()),GridItem(.flexible())]
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height:150 )
                    }
                    
                }
            }
            .navigationTitle("Asynclet🥳")
               .task{
                   
                await viewModel.getImages()
            }
        }
    }
}

struct Taskgroup_Previews: PreviewProvider {
    static var previews: some View {
        Taskgroup()
    }
}
