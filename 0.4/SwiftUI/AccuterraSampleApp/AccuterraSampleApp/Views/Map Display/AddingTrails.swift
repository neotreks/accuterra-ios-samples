//
//  AddingTrails.swift
//  AccuterraSampleApp
//
//  Created by Brian Elliott on 4/17/20.
//  Copyright © 2020 NeoTreks, Inc. All rights reserved.
//

import SwiftUI
import AccuTerraSDK
import Mapbox
import Combine

struct AddingTrails: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject var mapInteraction = MapInteraction()
    
    var body: some View {
        ZStack(alignment: .top) {
            MapView(mapCenter: self.mapInteraction.mapCenter, mapBounds: self.mapInteraction.mapBounds, zoomAnimation: self.mapInteraction.zoomAnimation ).initMap()
        }
        .navigationBarTitle(Text("Adding Trails"), displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action : {
                self.mode.wrappedValue.dismiss()
            }){
                Image(systemName: "arrow.left")
            })
        .edgesIgnoringSafeArea([.bottom])
    }
    
}

struct AddingTrails_Previews: PreviewProvider {
    static var previews: some View {
        return CreateMap()
    }
}
