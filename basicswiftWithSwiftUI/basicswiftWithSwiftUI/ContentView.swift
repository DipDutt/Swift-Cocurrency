//
//  ContentView.swift
//  basicswiftWithSwiftUI
//
//  Created by Dip Dutt on 18/3/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, world!")
        }
        .onAppear {
            runtest()
            structfunc()
            classfunc()
            //structfunc2()
            //classfunc2()
            
            actorfunc()
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct myStruct  {
    var tittle:String
}
// immutable struct
struct customStruct  {
    var tittle:String
    
     mutating func updateTittle(newTittle:String) {
        self.tittle = newTittle
    }
}

extension ContentView {
    
private func runtest() {
    print("Test started")
        
}
private func structfunc() {
    let ObjA = myStruct(tittle: "struct a")
    print(ObjA.tittle)
    var ObjB = ObjA
    print(ObjB.tittle)
    
    ObjB.tittle = "struct b"
    print("here we change the tittle of objB")
    
    print(ObjA.tittle)
    print(ObjB.tittle)
}
    
private func classfunc() {
    let objA = myClass(tittle: "class a")
    print(objA.tittle)
    
    let objb = objA
    print(objb.tittle)
    
    objb.tittle = "class b"
    
    print(objA.tittle)
    print(objb.tittle)
        
}
    
    
private func actorfunc() {
    Task {
        let objA = myActor(tittle: "class a")
        await print(objA.tittle)
        
        let objb = objA
        await print(objb.tittle)
        
        await objb.updateTittle(newTittle: "class b")
        
        await print(objA.tittle)
        await print(objb.tittle)
    }
            
    }
    
    
    
    
    
    private func structfunc2() {
        var ObjA = myStruct(tittle: "1")
        print(ObjA.tittle)
        ObjA.tittle = "2"
        print(ObjA.tittle)
        
        
        var struct2 = customStruct(tittle: "1")
        print(struct2.tittle)
        
        struct2 = customStruct(tittle: "2")
        print(struct2.tittle)
        
        
        var struct3 = customStruct(tittle: "1")
        print(struct3.tittle)
        struct3.updateTittle(newTittle: "2")
        print(struct3.tittle)
    }

}


class myClass {
    var tittle:String
    init(tittle:String) {
        self.tittle = tittle
    }
    
     func updateTittle(newTittle:String) {
       self.tittle = newTittle
   }
}


actor myActor {
    var tittle:String
    init(tittle:String) {
        self.tittle = tittle
    }
    
     func updateTittle(newTittle:String) {
       self.tittle = newTittle
   }
}


extension ContentView {
    private  func classfunc2() {
        
        let class1 = myClass(tittle: "title1")
        print(class1.tittle)
        class1.tittle = "title2"
        print(class1.tittle)
        
        
        let class2 = myClass(tittle: "title1")
        print(class1.tittle)
        class2.updateTittle(newTittle: "title2")
        print(class2.tittle)
    }
    
}
