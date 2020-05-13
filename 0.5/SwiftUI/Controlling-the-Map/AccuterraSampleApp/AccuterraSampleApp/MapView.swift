//
//  MapView.swift
//  Creating-a-Map
//
//  Created by Brian Elliott on 5/3/20.
//  Copyright © 2020 NeoTreks, Inc. All rights reserved.
//

import SwiftUI
import AccuTerraSDK
import Mapbox

struct MapView: UIViewRepresentable {
    
    var mapCenter: CLLocationCoordinate2D?
    var mapBounds: MGLCoordinateBounds?
    var zoomAnimation: Bool = false
    
    var styles: [URL] = [MGLStyle.outdoorsStyleURL, MGLStyle.satelliteStreetsStyleURL, MGLStyle.streetsStyleURL, AccuTerraStyle.vectorStyleURL]
    var styleId = 0
    let mapView: AccuTerraMapView = AccuTerraMapView(frame: .zero, styleURL: MGLStyle.streetsStyleURL)
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> AccuTerraMapView {
        // Initialize map
        self.mapView.initialize(styleURL: styles[styleId])
        self.mapView.setUserTrackingMode(.follow, animated: true, completionHandler: {
        })
        self.mapView.isRotateEnabled = false //makes map interaction easier
        self.mapView.isPitchEnabled = false //makes map interaction easier
        
        mapView.accuTerraDelegate = context.coordinator
        mapView.delegate = context.coordinator
        mapView.trailLayersManager.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ uiView: AccuTerraMapView, context: UIViewRepresentableContext<MapView>) {
        
        if let bounds = mapBounds {
            uiView.zoomToExtent(bounds: bounds, animated: true)
        }
        else if let location = mapCenter {
            if zoomAnimation {
                let camera = MGLMapCamera(lookingAtCenter: location, altitude: 4500, pitch: 0, heading: 0)

                // Animate the camera movement over 5 seconds.
                uiView.setCamera(camera, withDuration: 5, animationTimingFunction: CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
            }
            else {
                uiView.zoomLevel = 10
                uiView.setCenter(location, animated: true)
            }
        }
    }
    
    func makeCoordinator() -> MapView.Coordinator {
        Coordinator(self)
    }
    
    func centerCoordinate(_ centerCoordinate: CLLocationCoordinate2D) -> MapView {
        mapView.centerCoordinate = centerCoordinate
        return self
    }
    
}

extension MapView {
    class Coordinator: NSObject, AccuTerraMapViewDelegate, TrailLayersManagerDelegate, MGLMapViewDelegate {
                
        var controlView: MapView
        var isBaseMapLayerManagersLoaded = false
        var mapWasLoaded : Bool = false
        var isTrailsLayerManagersLoaded = false
        var trailService: ITrailService?

        init(_ mapView: MapView) {
            self.controlView = mapView
        }
        
        func didTapOnMap(coordinate: CLLocationCoordinate2D) {}
        
        func onMapLoaded() {
            self.mapWasLoaded = true
            self.zoomToDefaultExtent()
        }
        
        private func zoomToDefaultExtent() {
            // Colorado’s bounds
            let northeast = CLLocationCoordinate2D(latitude: 40.989329, longitude: -102.062592)
            let southwest = CLLocationCoordinate2D(latitude: 36.986207, longitude: -109.049896)
            let colorado = MGLCoordinateBounds(sw: southwest, ne: northeast)
            
            controlView.mapView.zoomToExtent(bounds: colorado, animated: true)
        }
        
        func onStyleChanged() {}
        
        func onSignificantMapBoundsChange() {}
        
        func onLayersAdded(trailLayers: Array<TrailLayerType>) {}
        
    }
}