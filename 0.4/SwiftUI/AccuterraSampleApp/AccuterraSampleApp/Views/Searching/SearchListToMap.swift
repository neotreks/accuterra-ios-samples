//
//  SearchingListToMap.swift
//  AccuterraSampleApp
//
//  Created by Brian Elliott on 4/17/20.
//  Copyright © 2020 NeoTreks, Inc. All rights reserved.
//

import SwiftUI
import AccuTerraSDK
import Mapbox
import Combine

struct SearchListToMap: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var mapInteractions = MapInteractions()
    @State var alertMessages = MapAlertMessages()
    @ObservedObject var vm = TrailsViewModel()
    var featureToggles = FeatureToggles(displayTrails: true, allowTrailTaps: true, allowPOITaps: false)
    var mapVm = MapViewModel()
    
    init() {
        vm.doTrailsSearch()
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                MapView(mapInteractions:self.$mapInteractions, features: self.featureToggles, mapAlerts:self.$alertMessages)
                    .frame(width: geometry.size.width, height: geometry.size.height / 2)
                    .background(Color.orange)
                List {
                    if self.vm.trails != nil {
                        ForEach(self.vm.trails!.indices, id: \.self){ idx in
                            HStack {
                                Button(action: {
                                    let trailId = self.vm.trails![idx].id
                                    let trail = self.vm.getTrailById(trailId:trailId)
                                    if let trail = trail {
                                        self.mapInteractions = self.mapVm.setTrailBounds(trailId:trailId, trail: trail)
                                    }
                                }, label: {
                                    TrailListRow(trailName: self.vm.trails![idx].name)
                                })
                            }
                        }
                    }
                    else {
                        Text("No trails found!")
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height / 2)
            }
        }
        .navigationBarTitle(Text("Search List to Map    "), displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action : {
                self.mode.wrappedValue.dismiss()
            }){
                Image(systemName: "arrow.left")
            })
    }
}
