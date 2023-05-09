//
//  SwiftUIView.swift
//  asyncLet
//
//  Created by Dip Dutt on 14/3/23.
//

import SwiftUI


class dataNetworkManager {
    func getData(url:URL) async throws -> Data {
       return try await withCheckedThrowingContinuation { continuation in
           URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    continuation.resume(returning: data)
                } else if let error = error {
                    continuation.resume(throwing: error)
                }
//               else {
//                   continuation.resume(throwing: URLError(.badURL))
//               }
            }
           .resume()
        }
    }
}

class continutionViewModel:ObservableObject {
    @Published var image:UIImage? = nil
    let manager = dataNetworkManager()
    
    func getImage() async {
        guard let url = URL(string: "https://picsum.photos/300") else {
            return
        }
        do {
            let data =  try await manager.getData(url: url)
            if let image = UIImage(data:data) {
                self.image = image
            }
        } catch  {
            print(error)
        }
    }
}

struct SwiftUIView: View {
    @StateObject var viewmodel = continutionViewModel()
    var body: some View {
        VStack{
            if let image = viewmodel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        
        .task {
            await viewmodel.getImage()
            
        }
    }
}
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
