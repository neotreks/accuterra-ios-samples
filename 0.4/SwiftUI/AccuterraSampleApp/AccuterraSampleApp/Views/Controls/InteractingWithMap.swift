//
//  InteractingWithMap.swift
//  AccuterraSampleApp
//
//  Created by Brian Elliott on 4/17/20.
//  Copyright © 2020 NeoTreks, Inc. All rights reserved.
//

import SwiftUI
import AccuTerraSDK
import Mapbox
import Combine

struct InteractingWithMap: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var featureToggles = FeatureToggles(displayTrails: true, allowTrailTaps: true, allowPOITaps: true)
    @State var mapInteractions = MapInteractions()
    
    var body: some View {
        VStack() {
            MapView(mapInteractions:$mapInteractions, features: featureToggles)
            Spacer()
            HStack(spacing: 30) {
                if mapInteractions.selectedTrailId == 0 {
                    Text("Picked Trail ID: N/A")
                }
                else {
                    Text("Picked Trail ID: \(mapInteractions.selectedTrailId)")
                }
                NavigationLink(destination: DetailView(trailId:mapInteractions.selectedTrailId)) {
                    Text("Trail Details")
                }
                .disabled(mapInteractions.selectedTrailId == 0)
//                .alert(isPresented: $showingAlert) {
//                    Alert(title: Text("Trail Info"), message: Text("POI: \(selectedTrailId)"), dismissButton: .default(Text("OK")))
//                }
            }
            .padding()
        }
        .navigationBarTitle(Text("Map Interactions"), displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action : {
                self.mode.wrappedValue.dismiss()
            }){
                Image(systemName: "arrow.left")
            })
    }
    
}

struct InteractingWithMap_Previews: PreviewProvider {
    static var previews: some View {
        return CreateMap()
    }
}
