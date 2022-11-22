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

func getRandom(count:Int) -> Int{
    var x = Int.random(in: 1..<21)
    while(x==count){
        x = Int.random(in: 1..<21)
    }
    return x
}

struct ContentView: View {
    @State var count = 1
    
    @State var stateText = " "

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
        var filePath: String?
        
        if(count==1){
            self.stateText="Critical Miss!"
            filePath = Bundle.main.path(forResource: "failwah", ofType: "mp3")

        } else if (count==20){
            self.stateText="Critical Miss!"
            filePath = Bundle.main.path(forResource: "zfanfare", ofType: "mp3")
        } else{
            self.stateText=" "
            filePath = Bundle.main.path(forResource: "rolldice", ofType: "mp3")
        }
        guard (filePath != nil) else {
            print("not working")
            return
        }
        let url = URL(fileURLWithPath: filePath!)
        
        var soundID:SystemSoundID = 0
        AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    func rollDice(){
        count=getRandom(count:count)
            
        playSound(count:count)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
