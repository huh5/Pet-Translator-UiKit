//
//  ResultViewController.swift
//  Pet Translator
//
//  Created by Богдан Ткачивський on 14/02/2025.
//

import UIKit

class ResultViewController: UIViewController {
    
    let sentences = Sentences() // Create an instance of the class
    
    
    var selectedTranslatorType: String?
    var selectedPetType: String?
    var selectedImageName: String?
    
    
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var petImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Received in ResultViewController -> Translator Type: \(selectedTranslatorType ?? "nil"), Pet Type: \(selectedPetType ?? "nil")")
        
        // Set the pet image based on the selected image name or use a default image
        if let imageName = selectedImageName {
            petImageView.image = UIImage(named: imageName)
        } else {
            let defaultImageName = selectedPetType == "dog" ? "Dog" : "Cat"
            petImageView.image = UIImage(named: defaultImageName)
        }
        
        // Display a random sentence based on selected types
        displayRandomSentence()
        
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Hide custom tab bar when this view appears
        if let tabBarVC = tabBarController as? CustomTabBarController {
            tabBarVC.tabbarView.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Show custom tab bar when leaving this view
        if let tabBarVC = tabBarController as? CustomTabBarController {
            tabBarVC.tabbarView.isHidden = false
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        // Navigate back to the previous view controller
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func repeatButtonPressed(_ sender: Any) {
        setupUI()
        
    }
    
    private func setupUI(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){
            self.repeatButton.isHidden = false
            self.repeatButton.layer.shadowColor = UIColor.black.cgColor
            self.repeatButton.layer.shadowOpacity = 0.5 // Увеличиваем opacity для более явной тени
            self.repeatButton.layer.shadowOffset = CGSize(width: 1, height: 4)
            self.repeatButton.layer.shadowRadius = 5
            
            self.messageLabel.isHidden = true
            self.messageImageView.isHidden = true
            
        }
        messageLabel.isHidden = false
        messageImageView.isHidden = false
        repeatButton.isHidden = true
        messageImageView.layer.shadowColor = UIColor.black.cgColor
        messageImageView.layer.shadowOpacity = 0.5 // Увеличиваем opacity для более явной тени
        messageImageView.layer.shadowOffset = CGSize(width: 1, height: 4)
        messageImageView.layer.shadowRadius = 5
        
        navigationItem.hidesBackButton = true
    }
    private func displayRandomSentence() {
        var selectedSentences: [String] = []
        
        // Determine the sentences to display based on translator and pet type
        if selectedTranslatorType == "pet" {
            if selectedPetType == "dog" {
                selectedSentences = sentences.dogSentences
            } else if selectedPetType == "cat" {
                selectedSentences = sentences.catSentences
            }
        } else { 
            if selectedPetType == "dog" {
                selectedSentences = sentences.forDogSentences
            } else if selectedPetType == "cat" {
                selectedSentences = sentences.forCatSentences
            }
        }
        
        if let randomSentence = selectedSentences.randomElement() {
            messageLabel.text = randomSentence
        }
    }
    
}
