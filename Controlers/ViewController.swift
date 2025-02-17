//
//  ViewController.swift
//  Pet Translator
//
//  Created by Богдан Ткачивський on 13/02/2025.
//

import UIKit
import Lottie
import AVFoundation



class ViewController: UIViewController {
    // Selected pet and translator type
    var selectedPetType: String = "dog"
    var selectedTranslatorType: String = "human"
    
    var lottieAnimationView: LottieAnimationView!
    
    // UI Outlets
    @IBOutlet weak var animalsView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var animalsImageView: UIImageView!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var procesLabel: UILabel!
    @IBOutlet weak var arrowSwapButton: UIButton!
    @IBOutlet weak var dogButton: UIButton!
    @IBOutlet weak var humanLabel: UILabel!
    @IBOutlet weak var catButton: UIButton!
    @IBOutlet weak var petLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animalsImageView.image = UIImage(named: "Dog")
        
        setupUI()
        setupAnimationView()
        tabBarController?.tabBar.isHidden = true
        requestMicrophonePermission()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setupUI()
        
        tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkMicrophonePermission()
    }
    
    // Stops the recording and navigates to ResultViewController
    @IBAction func stopRecordingButtonPressed(_ sender: Any) {
        print("Selected Translator Type: \(selectedTranslatorType)")
        print("Selected Pet Type: \(selectedPetType)")
        
        // Hide UI elements
        recordButton.isHidden = true
        stopRecordingButton.isHidden = true
        lottieAnimationView.isHidden = true
        animalsView.isHidden = true
        dogButton.isHidden = true
        catButton.isHidden = true
        procesLabel.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let resultVC = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
                return
            }
            resultVC.selectedTranslatorType = self.selectedTranslatorType
            resultVC.selectedPetType = self.selectedPetType
            resultVC.selectedImageName = self.selectedPetType == "dog" ? "Dog" : "Cat"
            
            
            print("Passing to ResultViewController -> Translator Type: \(resultVC.selectedTranslatorType ?? "nil"), Pet Type: \(resultVC.selectedPetType ?? "nil")")
            
            self.navigationController?.pushViewController(resultVC, animated: true)
            
            self.lottieAnimationView.stop()
            
        }
    }
    
    // Starts recording animation
    @IBAction func recordButtonPressed(_ sender: Any) {
        recordButton.isHidden = true
        
        stopRecordingButton.isHidden = false
        
        // Create an animation and show it
        lottieAnimationView.isHidden = false
        lottieAnimationView.play()
    }
    // Selects a cat as the pet type
    @IBAction func catButtonPressed(_ sender: Any) {
        catButton.isHighlighted = false
        dogButton.isHighlighted = true
        animalsImageView.image = UIImage(named: "Cat")
        selectedPetType = "cat"
        
    }
    // Selects a dog as the pet type
    @IBAction func dogButtonPressed(_ sender: Any) {
        dogButton.isHighlighted = false
        catButton.isHighlighted = true
        animalsImageView.image = UIImage(named: "Dog")
        selectedPetType = "dog"
    }
    // Swaps translation direction (Human -> Pet or Pet -> Human)
    @IBAction func arrowSwapButtonPressed(_ sender: Any) {
        if selectedTranslatorType == "human" {
            selectedTranslatorType = "pet"
        } else {
            selectedTranslatorType = "human"
        }
        
        // Update text labels
        humanLabel.text = selectedTranslatorType.uppercased()
        petLabel.text = selectedTranslatorType == "human" ? "PET" : "HUMAN"
    }
    // Sets up the UI appearance
    func setupUI(){
        recordButton.isHidden = false
        stopRecordingButton.isHidden = true
        procesLabel.isHidden = true
        catButton.isHighlighted = true
        dogButton.isHighlighted = false
        animalsView.isHidden = false
        dogButton.isHidden = false
        catButton.isHidden = false
        
        animalsView.layer.cornerRadius = 10
        
        // Adding shadows to buttons and views
        applyShadow(to: recordButton)
        applyShadow(to: stopRecordingButton)
        applyShadow(to: animalsView)
    }
    
    // Adds shadow effect to UI elements
    func applyShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 1, height: 4)
        view.layer.shadowRadius = 10
    }
    // Sets up Lottie animation view
    func setupAnimationView() {
        lottieAnimationView = LottieAnimationView(name: "Animation - 1739536959711")
        lottieAnimationView.translatesAutoresizingMaskIntoConstraints = false
        lottieAnimationView.loopMode = .loop
        lottieAnimationView.animationSpeed = 1.0
        lottieAnimationView.play()
        lottieAnimationView.isHidden = true
        // Add animation on view
        view.addSubview(lottieAnimationView)
        
        // Set animation restrictions
        NSLayoutConstraint.activate([
            lottieAnimationView.centerXAnchor.constraint(equalTo: recordButton.centerXAnchor),
            lottieAnimationView.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor),
            lottieAnimationView.widthAnchor.constraint(equalTo: recordButton.widthAnchor),
            lottieAnimationView.heightAnchor.constraint(equalTo: recordButton.heightAnchor)
        ])
        
        // Allow interaction with the button through animation
        lottieAnimationView.isUserInteractionEnabled = false
    }
    // Requests microphone access from the user
    func requestMicrophonePermission(){
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                self.recordButton.isEnabled = granted
                self.recordButton.alpha = granted ? 1.0 : 0.5
                if !granted {
                    self.showSettingsAlert()
                }
            }
        }
    }
    
    // Checks microphone access and requests it if necessary
    func checkMicrophonePermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                self.recordButton.isEnabled = granted
                self.recordButton.alpha = granted ? 1.0 : 0.5

                if !granted {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.showSettingsAlert()
                    }
                }
            }
        }
    }
    
    // Shows an alert if microphone access is denied
    func showSettingsAlert(){
        let alert = UIAlertController(
            title: "Enable Microphone Access",
            message: "Please allow access to your microphone to use the app's features",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
            
            // After returning to the application, we check access again
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.checkMicrophonePermission()
            }
        })
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }

}

