//
//  ContentView.swift
//  useTask in swiftUI
//
//  Created by Dip Dutt on 13/3/23.
//

import SwiftUI

class TaskView:ObservableObject {
    @Published var image:UIImage?
    @Published var image2:UIImage?

    
    func fetchImage() async {
         try? await Task.sleep(nanoseconds: 2_000_000_000)
        guard let url = URL(string: "https://picsum.photos/1000") else {
            return
        }
        
        do {
           let (data,_) =  try await URLSession.shared.data(from: url)
            await MainActor.run(body: {
                self.image = UIImage(data: data)
                print("image sucess fully")
            })
            
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        guard let url = URL(string: "https://picsum.photos/1000") else {
            return
        }
        
        do {
           let (data,_) =  try await URLSession.shared.data(from: url)
            await MainActor.run(body: {
                self.image2 = UIImage(data: data)
            })
          
        } catch  {
            print(error.localizedDescription)
        }
    }
}

struct Homeview:View {
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("Cilck here😀") {
                    ContentView()
                }
            }
        }
    }
}



struct ContentView: View {
    @StateObject var imageModel = TaskView()
    @State var cancelTask:Task<(),Never>? = nil
    var body: some View {
        VStack {
            if let image = imageModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width:200 , height: 200)
                
            }
            if let image = imageModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width:200 , height: 200)
            }
        }
        
        .task {
            await imageModel.fetchImage()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
