//
//  ContentView.swift
//  downloadimageEscaping
//
//  Created by Dip Dutt on 10/3/23.
//

import SwiftUI
import Combine


class imageModel {
    
    let url = URL(string: "https://picsum.photos/200")!
    
    
    func handleresponse(data:Data?, response:URLResponse?)->UIImage? {
        
        guard let data = data,
              let image = UIImage(data: data),
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        
        return image
        
    }
    
    //  with escaping
    func fetchImage(completionhandler:@escaping(_ image:UIImage? , _ error:Error?)->()) {
        
        URLSession.shared.dataTask(with: url) {  [weak self] data, response, error in
            
            let image = self?.handleresponse(data: data, response: response)
            completionhandler(image,error)
        }
        .resume()
    }
    
    // image with combine
    
//    func withCombine() -> AnyPublisher<UIImage?, Error> {
//        URLSession.shared.dataTaskPublisher(for: url)
//            .map(handleresponse)
//            .mapError( {$0} )
//            .eraseToAnyPublisher()
//    }
    
    
    // image with async await
    
    func withAsyncAwait() async throws -> UIImage? {
        do {
          let (data, response) =  try await URLSession.shared.data(from: url)
            return handleresponse(data: data,response: response)
        } catch  {
            throw error
        }
        
    }
}

class imageModelView:ObservableObject {
    @Published var image:UIImage? = nil
    let imageloder = imageModel()
    var cancellable = Set<AnyCancellable>()
    
    
    func fetchImage() async {
        
//        imageloder.fetchImage { [weak self] image, error in
//
//            if let image = image {
//                DispatchQueue.main.async {
//                    self?.image = image
//                }
//
//            }
            
//            imageloder.withCombine()
//            .receive(on: DispatchQueue.main)
//            .sink { _ in
//
//            } receiveValue: { [weak self] image in
//                self?.image = image
//
//            }
//            .store(in: &cancellable)
        try? await Task.sleep(nanoseconds: 2_000_000_000)
         let image =  try? await imageloder.withAsyncAwait()
        await MainActor.run {
            self.image = image
        }
    }
}
    


struct ContentView: View {
    @StateObject var Imagemodel = imageModelView()
    var body: some View {
        VStack {
            
            if let image = Imagemodel.image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 200, height: 200)
            }
        }
        .onAppear {
            Task {
                await Imagemodel.fetchImage()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
