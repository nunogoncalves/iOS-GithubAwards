////
////  SwiftUIView.swift
////  OctoPodium
////
////  Created by Nuno Gonçalves on 20/06/2019.
////  Copyright © 2019 Nuno Gonçalves. All rights reserved.
////
//
//import SwiftUI
//
//struct OctoCatView : View {
//
//    @Binding var eyesOpened: Bool
//
//    var body: some View {
//        ZStack {
//            Image(uiImage: #imageLiteral(resourceName: "OctoCat"))
//                .resizable()
//                .frame(width: 200, height: 200, alignment: .center)
//            HStack(alignment: .center, spacing: 40) {
//                Eye(opened: $eyesOpened)
//                Eye(opened: $eyesOpened)
//            }
//            .padding(EdgeInsets(top: 90, leading: 0, bottom: 0, trailing: 0))
//        }
//    }
//}
//
//private struct Eye : View {
//
//    @Binding var opened: Bool
//
//    var body: some View {
//        Image(uiImage: opened ? #imageLiteral(resourceName: "EyeBall") : #imageLiteral(resourceName: "X"))
//            .resizable()
//            .aspectRatio(contentMode: .fill)
//            .frame(width: eyeWidth, height: eyeHeight, alignment: .center)
//    }
//
//    private var eyeWidth: CGFloat { opened ? 34 : 24 }
//    private var eyeHeight: CGFloat { opened ? 50 : 25 }
//}
//
//fileprivate extension CGFloat {
//}
//#if DEBUG
//struct SwiftUIView_Previews : PreviewProvider {
//    static var previews: some View {
//        Group {
//            OctoCatView(eyesOpened: .constant(true))
//            OctoCatView(eyesOpened: .constant(false))
//        }
//        .previewLayout(.sizeThatFits)
//    }
//}
//#endif
