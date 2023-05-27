//
//  ContentView.swift
//  Neko Wa Kawaii
//
//  Created by 斋木美纪子 on 2023/5/26.
//

import SwiftUI
import Cocoa
import AVFoundation

class DraggableImageView: NSImageView {
    var originalPosition: NSPoint?

    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        originalPosition = self.frame.origin
    }

    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        guard let originalPosition = originalPosition else { return }
        let location = event.locationInWindow
        let deltaX = location.x - originalPosition.x
        let deltaY = location.y - originalPosition.y
        self.frame.origin = NSPoint(x: originalPosition.x + deltaX, y: originalPosition.y + deltaY)
    }
}

struct BlurView: NSViewRepresentable {
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        
        let blurView = NSVisualEffectView(frame: NSRect(x: 0, y: 0, width: 179, height: 179))
        blurView.blendingMode = NSVisualEffectView.BlendingMode.behindWindow
        blurView.material = NSVisualEffectView.Material.hudWindow
        blurView.isEmphasized = true
        blurView.state = NSVisualEffectView.State.active
        
        return blurView;
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        NSLog("updateNSView")
    }
    
    func test() -> some View {
        NSLog("Test")
        return self
    }
}

struct ContentView: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying: Bool = false
    @State private var songTitle: String = ""
    @State private var imageName: String = "nano.png"

    var body: some View {
        GeometryReader { geometry in
            Image(nsImage: NSImage(named: NSImage.Name(imageName))!)
                .resizable()
                .scaledToFit()
                .frame(width: geometry.size.width, height: 179)
                .background(Color.clear)
                .clipped()
                .onTapGesture {
                    if isPlaying {
                        stopAudio()
                    } else {
                        playAudio()
                    }
                }
        }
        .frame(minWidth: 179, maxWidth: 179, minHeight: 179, maxHeight: 179)
        .background(BlurView().test())
        
        Text("Playing: " + "'" + songTitle + "'") // 添加曲名
                    .font(.headline)
                    .padding()
    }

    func playAudio() {
        guard let audioURLs = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil),
                      let randomAudioURL = audioURLs.randomElement() else {
                    print("Failed to find any audio files")
                    return
                }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: randomAudioURL)
            audioPlayer?.play()
            isPlaying = true
            
            
            // 获取曲名
            let songName = randomAudioURL.deletingPathExtension().lastPathComponent
            songTitle = songName
            imageName = "nano2.png"

        } catch {
            print("Failed to play the audio file")
        }
    }


    func stopAudio() {
        audioPlayer?.stop()
        isPlaying = false
        songTitle = ""
        imageName = "nano.png"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
