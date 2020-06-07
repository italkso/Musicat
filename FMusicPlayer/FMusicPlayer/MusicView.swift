//
//  MusicView.swift
//  FMusicPlayer
//
//  Created by 丁海能 on 2020/6/7.
//  Copyright © 2020 丁海能. All rights reserved.
//

import SwiftUI
import AVKit

struct MusicView: View {
    @State private var audioPlayer: AVAudioPlayer!
    @State private var data : Data = .init(count: 0)
    @State private var musics = ["music1","music2","music3"]
    @State private var title = ""
    @State private var count = 1
    @State private var playing = false
    @State private var width : CGFloat = 0
    @State private var amount: CGFloat = 0
    @State private var degree: Double = 0
    @State private var myFavorite = false
    @State private var enabled = false
    
    var body: some View {
        VStack{
            Text("音乐").font(.title).padding(.top,50)
            Spacer()
            Image(uiImage: self.data.count == 0 ? UIImage(named: "earphones")! : UIImage(data: self.data)!)
                .resizable()
                .frame(width: self.data.count == 0 ? 150 : nil, height: 150)
                .clipShape(Circle())
                .opacity(0.95)
                .rotationEffect(Angle(degrees: degree))
                .animation(//调节动画时间(慢进慢出)
                    Animation.easeInOut(duration: 5)
                .repeatForever(autoreverses: true) //循环
                )
                .overlay(
                       Circle()
                           .stroke(Color.init(red: 231/255, green: 70/255, blue: 60/255,opacity: 0.9))
                           //rgba(231, 76, 60,0.9)
                       .scaleEffect(amount)               //缩放
                           .opacity(Double(1.5 - amount))     //透明度
                       .animation(
                        Animation.easeInOut(duration: 4) //调节动画时间(慢出)
                           .repeatForever(autoreverses: false) //循环
                           )
                   )
                   .onAppear {
                       self.amount = 1.5
                       self.degree = 360
               }.padding()
            
            HStack(spacing:30){
                Button(action: {
                    self.enabled.toggle()
                }){
                    Image(systemName: "heart.fill")
                    .foregroundColor(enabled ? .pink : .gray)
                   .animation(.default)
                   .onTapGesture {
                       self.myFavorite = true
                       self.enabled = true
                    }
                }
                Image(systemName: "message")
                Image(systemName: "arrowshape.turn.up.right")
            }.padding(.top,50)
            Spacer()
            HStack{
                Text(self.title).font(.system(size:20)).foregroundColor(.blue)
            }
            
            ZStack(alignment: .leading) {
                Capsule().fill(Color.black.opacity(0.1)).frame(height: 6)
                
                Capsule().fill(Color.blue.opacity(0.5)).frame(width: self.width, height: 6)
                .gesture(DragGesture()
                    .onChanged({ (value) in
                        
                        let x = value.location.x
                        self.width = x
                        
                    }).onEnded({ (value) in
                        
                        let x = value.location.x
                        
                        let screen = UIScreen.main.bounds.width - 45
                        
                        let percent = x / screen
                        
                        self.audioPlayer.currentTime = Double(percent) * self.audioPlayer.duration
                    }))
            }.padding()
            HStack(spacing: UIScreen.main.bounds.width / 5 - 45){
                //上一曲
               Button(action: {
                   if self.count > 1{
                       self.count -= 1
                   } else {
                       self.count = 3
                   }
                   let sound = Bundle.main.path(forResource: "music\(self.count)", ofType: "mp3")
                   self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                   self.getData()
                   self.audioPlayer.play()
                   self.playing = true
               }){
                Image(systemName: "backward.fill").buttonStyle("backward.fill")
                }
                
                Button(action: {
                    self.audioPlayer.currentTime -= 10
                }){
                    Image(systemName: "gobackward.10").buttonStyle("gobackward.10")
                }
                
                //根据是否正在播放切换
                if playing {
                    Button(action: {
                        self.audioPlayer.pause()
                        self.playing = false
                    }){
                        Image(systemName: "pause.circle").buttonStyle("pause.circle")
                    }//播放
                } else {
                    Button(action: {
                        self.audioPlayer.play()
                        self.playing = true
                    }){
                        Image(systemName: "play.circle").buttonStyle("play.circle")
                    }//暂停
                }
                
             Button(action: {
                    let increaseTime = self.audioPlayer.currentTime + 10
                    if increaseTime < self.audioPlayer.duration {
                       self.audioPlayer.currentTime = increaseTime
                   }
               }){
                    Image(systemName: "goforward.10").buttonStyle("goforward.10")
               }
                
                //下一曲
                Button(action: {
                    if self.count < 3{
                        self.count += 1
                    } else {
                        self.count = 1
                    }
                    let sound = Bundle.main.path(forResource: "music\(self.count)", ofType: "mp3")
                    self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                    self.getData()
                    self.audioPlayer.play()
                    self.playing = true
                }){
                    Image(systemName: "forward.fill").buttonStyle("forward.fill")
                }
            }.padding()
            Spacer()
        }
        .onAppear {
            let music = Bundle.main.path(forResource: "music1", ofType: "mp3")
            self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: music!))
            self.getData()
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
                
                if self.audioPlayer.isPlaying{
                    
                    let screen = UIScreen.main.bounds.width - 30
                    
                    let value = self.audioPlayer.currentTime / self.audioPlayer.duration
                    
                    self.width = screen * CGFloat(value)
                }
            }
        }
    }
    
    func getData(){
          let asset = AVAsset(url: self.audioPlayer.url!)
          
          for i in asset.commonMetadata{
              
              if i.commonKey?.rawValue == "artwork"{
                  
                  let data = i.value as! Data
                  self.data = data
              }
              
              if i.commonKey?.rawValue == "title"{
                  
                  let title = i.value as! String
                  self.title = title
              }
          }
      }
}

//自定义修饰符(通过 extension View, 让修饰符写法更简单)
struct ButtonModifier: ViewModifier {
    let imageName:String
    func body(content: Content) -> some View{
        ZStack{
            content
            Image(imageName)
                .resizable()
                .foregroundColor(.primary)
                .frame(width:40,height: 40)
                .background(Color.white)
                .aspectRatio(contentMode: .fill)
        }
    }
}

extension View{
    func buttonStyle(_ imageName: String) -> some View {
        self.modifier(ButtonModifier(imageName: imageName))
    }
}

struct MusicView_Previews: PreviewProvider {
    static var previews: some View {
        MusicView()
    }
}

