//
//  RadioList.swift
//  TuneInRadio
//
//  Created by Vijay Thota on 9/8/21.
//

import Foundation
import UIKit
import AVFoundation

class StationViewController : UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    var itemDetail: [String: Any]
    var player: AVPlayer?

    init?(coder: NSCoder, item: [String: Any]) {
        self.itemDetail = item
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use `init(coder:image:)` to initialize an `ImageViewController` instance.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Station"
        if let urlString = self.itemDetail["image"] as? String, let url = URL(string: urlString) {
            self.imageView.load(url: url)
        }
        if let urlString = self.itemDetail["URL"] as? String, let url = URL(string: urlString) {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
                try AVAudioSession.sharedInstance().setActive(true)
                /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
                let playerItem:AVPlayerItem = AVPlayerItem(url: url)
                self.player = AVPlayer(playerItem: playerItem)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func play(_ sender: UIButton) {
        guard let player:AVPlayer = self.player else { return }
        if player.rate == 0 {
            player.play()
            //playButton!.setImage(UIImage(named: "player_control_pause_50px.png"), forState: UIControlState.Normal)
            playButton!.setTitle("Pause", for: UIControl.State.normal)
        } else {
            player.pause()
            //playButton!.setImage(UIImage(named: "player_control_play_50px.png"), forState: UIControlState.Normal)
            playButton!.setTitle("Play", for: UIControl.State.normal)
        }

    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
