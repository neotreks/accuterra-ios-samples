//
//  ControllerView.swift
//  AccuterraSampleApp
//
//  Created by Brian Elliott on 4/21/20.
//  Copyright © 2020 NeoTreks, Inc. All rights reserved.
//

import Foundation

import SwiftUI

struct ControllerView : View {
    
    @ObservedObject var viewRouter: ViewRouter
    
    var body: some View {
            VStack {
                if viewRouter.currentPage == "download" {
                    DownloadView(viewRouter: viewRouter)
                } else if viewRouter.currentPage == "home" {
                    NavigationView {
                        HomeView(viewRouter: viewRouter)
                        .navigationBarTitle(Text("AccuTerra SDK Samples"), displayMode: .inline)
                    }
                }
            }
    }
}
