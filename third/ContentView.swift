import SwiftUI
import AVFoundation

extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

//  Override the default behavior of shake gestures to send our notification instead.
extension UIWindow {
     open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
     }
}

// A view modifier that detects shaking and calls a function of our choosing.
struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

// A View extension to make the modifier easier to use.
extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}


var player:AVAudioPlayer!

func getRandom() -> Int{
    return Int.random(in: 1..<21)
}

struct ContentView: View {
    @State var count = 1
    
    @State var stateText = ""

    var body: some View {
        VStack {
            Spacer()
            Text("Rolled: "+String(count)).font(.system(size:50)).fontWeight(.heavy)
            Spacer()
            Image( "d"+String(count)).resizable().frame(width: 200, height: 200)
            Spacer()
            Text(stateText).font(.system(size:40)).bold()
            Spacer()
            
        }.onTapGesture {
            rollDice()
        }.onShake{
            rollDice()
        }
        .padding()
    }
    
    func playSound(count:Int){
        
        var url = Bundle.main.url(forResource: "rolldice", withExtension: ".mp3")
        var url2 = Bundle.main.url(forResource: "zfanfare", withExtension: ".mp3")
        var url3 = Bundle.main.url(forResource: "failwah", withExtension: ".mp3")
        
        if(count==1){
            self.stateText="Critical Miss!"
            url = url3
        } else if (count==20){
            self.stateText="Critical Miss!"
            url = url2
        } else{
            self.stateText=""
        }
        guard url != nil else {
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url!)
            player?.play()
        } catch {
            print(("error"))
        }
    }
        func rollDice(){
            count=getRandom()
            
            playSound(count:count)
        }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
