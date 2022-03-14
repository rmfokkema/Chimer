	  //
	  //  ViewController.swift
	  //  Chimer
	  //
	  //  Created by René Fokkema on 22/02/2022.
	  //

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
	  
	  @IBOutlet weak var glowView: UIImageView!
	  @IBOutlet weak var picker: UIDatePicker!
	  @IBOutlet weak var goButton: UIButton!
	  
	  private var tap: UITapGestureRecognizer!
	  var player:AVAudioPlayer?
	  
	  var statusBarHidden = false
	  
	  override var prefersStatusBarHidden: Bool { return statusBarHidden }
	  override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .fade }
	  override var prefersHomeIndicatorAutoHidden: Bool { return true }
	  
			 //	  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
			 //			 return [.portrait, .portraitUpsideDown]
			 //	  }
	  
	  override func viewDidLoad() {
			 super.viewDidLoad()
			 
			 glowView.alpha = 0.05

			 picker.setValue(UIColor(named: "blaat"), forKey: "textColor")
			 //let white = UIColor(white: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
			 //picker.textc

			 tap = UITapGestureRecognizer(target: self, action: #selector(runChimer))
			 tap.isEnabled = false
			 view.addGestureRecognizer(tap)
			 
					//			 gradientLayer.type = .radial
					//
					//			 let blueColor = CGColor(red: 0, green: 0, blue: 0.08235294118, alpha: 1.0)
					//			 gradientLayer.colors = [UIColor.white.cgColor, blueColor]
					//
					//			 gradientLayer.frame = gradientView.frame
					//
					//			 gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
					//			 gradientLayer.endPoint = CGPoint(x: 2.0, y: 1)
					//
					//			 gradientView.layer.addSublayer(gradientLayer)
			 
	  }
	  
	  @IBAction func go() {
			 
			 picker.isEnabled = false
			 goButton.isEnabled = false
			 
			 UIView.animate(withDuration: 0.4, animations: {
					self.picker.alpha = 0
					self.goButton.alpha = 0
			 }, completion: { _ in
					self.setStatusBarHidden()
					self.tap.isEnabled = true
					self.runChimer()
			 })
			 
	  }
	  
	  @objc private func runChimer() {
			 
			 setStatusBarHidden()

			 self.glowView.alpha = 0.05
			 
			 UIView.animate(withDuration: picker.countDownDuration, animations: {
					self.glowView.alpha = 1
			 }, completion: { completed in
					if completed {
						  self.playSound("Done")
						  self.setStatusBarHidden(false)

						  UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut, .repeat, .autoreverse], animations: { self.glowView.alpha = 0.05 }, completion: nil)
					} else {
						  print("Chimer aborted / reset!")
					}
			 })
			 
			 print("Running Chimer with:", picker.countDownDuration, "seconds...")
	  }
	  
	  func setStatusBarHidden(_ hidden: Bool = true) {
			 statusBarHidden = hidden
			 setNeedsStatusBarAppearanceUpdate()
	  }
	  
	  override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
			 if motion == .motionShake {
					
					glowView.alpha = 0.05
					tap.isEnabled = false
					
					picker.isEnabled = true
					goButton.isEnabled = true
					
					setStatusBarHidden(false)
					
					UIView.animate(withDuration: 0.4, animations: {
						  self.picker.alpha = 1.0
						  self.goButton.alpha = 1.0
					})
			 }
	  }
	  
			 // MARK: Audio Player
	  
	  public func playSound(_ name: String) {
			 
			 let audioSession = AVAudioSession.sharedInstance()
			 
			 do {
					try audioSession.setCategory(.playback, options: [.duckOthers])
					try audioSession.setActive(true)
					let url = Bundle.main.url(forResource: name, withExtension: "m4a")!
					player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue)
					if let player = player {
						  player.delegate = self
						  player.prepareToPlay()
						  player.play()
					}
			 } catch { print(error.localizedDescription) }
	  }
	  
	  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
			 do { try AVAudioSession.sharedInstance().setActive(false) }
			 catch { print("Failed to set audio session to inactive:", error.localizedDescription) }
	  }
	  
}

