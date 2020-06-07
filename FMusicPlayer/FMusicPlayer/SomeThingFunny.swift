//
//  SomeThingFunny.swift
//  FMusicPlayer
//
//  Created by 丁海能 on 2020/6/7.
//  Copyright © 2020 丁海能. All rights reserved.
//

import SwiftUI

struct SomethingFunny: View {
    let text = "有一个人卖跳蚤药，招牌上写着“卖上好蚤药”。路过的人问：“这药怎么用啊?” 卖药的回答说：“捉住跳蚤，把药涂在它的嘴上，跳蚤就死了。"
    var body: some View {
        Text(text).padding()
    }
}

struct SthFunny_Previews: PreviewProvider {
    static var previews: some View {
        SomethingFunny()
    }
}
