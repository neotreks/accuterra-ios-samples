//
//  ControllingTheMap.swift
//  AccuterraSampleApp
//
//  Created by Brian Elliott on 4/17/20.
//  Copyright © 2020 NeoTreks, Inc. All rights reserved.
//

import SwiftUI
import AccuTerraSDK
import Mapbox
import Combine

struct ControllingTheMap: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var env: AppEnvironment
    @State var alertMessages = MapAlertMessages()
    var mapVm = MapViewModel()
    var featureToggles = FeatureToggles(displayTrails: true, allowTrailTaps: true, allowPOITaps: true)
    let initialMapDefaults:MapInteractions = MapInteractions()

    init() {
        initialMapDefaults.defaults.mapBounds = mapVm.getColoradoBounds()
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            MapView(initialState: initialMapDefaults, features: featureToggles, mapAlerts:$alertMessages)
            .edgesIgnoringSafeArea(.vertical)
            VStack(spacing: 20) {
                Text("Go to Location:")
                HStack {
                    Button(action: {
                        self.env.mapIntEnv = MapInteractionsEnvironment(mapBounds: self.mapVm.getColoradoBounds())
                    }, label: {
                        Text("CO")
                        .padding()
                        .background(Color.white)
                    })
                    Button(action: {
                        self.env.mapIntEnv = MapInteractionsEnvironment(mapCenter: self.mapVm.getDenverLocation())
                    }, label: {
                        Text("Denver")
                        .padding()
                        .background(Color.white)
                    })
                    Button(action: {
                        self.env.mapIntEnv = MapInteractionsEnvironment(mapCenter: self.mapVm.getCastleRockLocation(), zoomAnimation: true)
                    }, label: {
                        Text("Castle Rock")
                        .padding()
                        .background(Color.white)
                    })
                }.shadow(radius: 3)
                .alert(isPresented:$alertMessages.displayAlert) {
                    Alert(title: Text(alertMessages.title), message: Text(alertMessages.message), dismissButton: .default(Text("OK")))
                }
            }
            .frame(height: 100.0)
        }
        .navigationBarTitle(Text("Controlling the Map"), displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action : {
                self.env.mapIntEnv.resetEnv()
                self.mode.wrappedValue.dismiss()
            }){
                Image(systemName: "arrow.left")
            })
    }
}

struct ControllingTheMap_Previews: PreviewProvider {
    static var previews: some View {
        return CreateMap()
    }
}
