//
//  SplashScreenView.swift
//  third
//
//  Created by Griffin Barnard on 11/21/22.
//

import SwiftUI

struct SplashScreenView : View{
    @State var isActive = false
    @State var size = 0.8
    @State var opacity = 0.5
    var body : some View {
        if(isActive){
            ContentView()
        } else{
            VStack{
                VStack{
                    Image( "d7cruiser").resizable().scaledToFit().frame(width: 200, height: 200)
                    Text("Griffin's Really Cool App").font(Font.custom("Baskerville-Bold", size: 26)).foregroundColor(.black.opacity(0.8))
                }.scaleEffect(size).opacity(opacity).onAppear{
                        withAnimation(.easeIn(duration: 1.2)){
                            self.size = 0.9
                            self.opacity=1
                        }
                }
            }.onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now()+2.0){
                    self.isActive=true
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}

