//
//  ContentView.swift
//  HitTheClown
//
//  Created by Lori Rothermel on 5/29/23.
//

import SwiftUI
import AVFAudio
import PhotosUI

struct ContentView: View {
    @State private var audioPlayer: AVAudioPlayer!
    @State private var animateImage = true
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var bipImage = Image("clown")
    
    
    var body: some View {
        VStack {
            
            Spacer()
            
            bipImage
                .resizable()
                .scaledToFit()
                .scaleEffect(animateImage ? 1.0 : 0.9)
                .onTapGesture {
                    playSound(soundName: "punchSound")
                    animateImage = false   // Will immediately shrink using .scaleEffect to 90% of size
                    withAnimation (.spring(response: 0.3, dampingFraction: 0.3)) {
                        animateImage = true
                    }  // withAnimation
                }  // .onTapGesture
                            
            Spacer()
            
            PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                Label("Photo Library", systemImage: "photo.fill.on.rectangle.fill")
            }
            .onChange(of: selectedPhoto) { newValue in
                // Need to:
                //
                // - get the data inside the PhotosPickerItem selectPhoto
                // - use the data to create a UIImage
                // - use the UIImage to create an Image
                // - and assign that image to bipImage
                
                Task {
                    do {
                        if let data = try await newValue?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                bipImage = Image(uiImage: uiImage)
                            }
                        }  // if let data
                    } catch {
                        print("❗️ERROR: Loading failed - \(error.localizedDescription)")
                    }  // do...catch
                }  // Task
                               
            }
                        
            
        }  // VStack
        .padding()
        
    }  // some View
    
    
    func playSound(soundName: String) {
        
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("❗️ Could not read file named \(soundName)")
            return
        }  // guard let
        
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("❗️ ERROR: \(error.localizedDescription)")
        }  // do...catch
        
    }  // playSound
    
    
}  // ContentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
