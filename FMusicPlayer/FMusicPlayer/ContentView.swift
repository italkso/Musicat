//
//  ContentView.swift
//  FMusicPlayer
//
//  Created by 丁海能 on 2020/6/7.
//  Copyright © 2020 丁海能. All rights reserved.
//

/*
加入 SomeThingFunny.swift 主要是为了演示 TabView 的用法
*/

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            Image("backgroundImage")
                .resizable()
                .opacity(0.05)
                .edgesIgnoringSafeArea(.all)
            
            TabView {
                MusicView()
                    .tabItem{
                    Image(systemName: "music.note")
                    Text("音乐")
                }
                SomethingFunny()
                    .tabItem{
                    Image(systemName: "book.fill")
                    Text("笑话")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
