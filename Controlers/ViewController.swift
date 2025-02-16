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
    var selectedPetType: String = "dog"
    var selectedTranslatorType: String = "human"
    
    var lottieAnimationView: LottieAnimationView!
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

        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setupUI()

        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func stopRecordingButtonPressed(_ sender: Any) {
        print("Selected Translator Type: \(selectedTranslatorType)")
           print("Selected Pet Type: \(selectedPetType)")
        
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
    @IBAction func recordButtonPressed(_ sender: Any) {
        requestMicrophonePermission()
        recordButton.isHidden = true
           
           // Показываем кнопку остановки записи
           stopRecordingButton.isHidden = false
           
           // Создаём анимацию и показываем её
           
           lottieAnimationView.isHidden = false
           lottieAnimationView.play()
    }
    
    @IBAction func catButtonPressed(_ sender: Any) {
        catButton.isHighlighted = false
        dogButton.isHighlighted = true
        animalsImageView.image = UIImage(named: "Cat")
        selectedPetType = "cat"
      
    }
    @IBAction func dogButtonPressed(_ sender: Any) {
        dogButton.isHighlighted = false
        catButton.isHighlighted = true
        animalsImageView.image = UIImage(named: "Dog")
        selectedPetType = "dog"
    }
    @IBAction func arrowSwapButtonPressed(_ sender: Any) {
        if selectedTranslatorType == "human" {
              selectedTranslatorType = "pet"
          } else {
              selectedTranslatorType = "human"
          }

          // Обновляем текстовые метки
          humanLabel.text = selectedTranslatorType.uppercased()
          petLabel.text = selectedTranslatorType == "human" ? "PET" : "HUMAN"
      }
   
    func setupUI(){
        
        recordButton.isHidden = false
        stopRecordingButton.isHidden = true
        procesLabel.isHidden = true
        animalsView.layer.cornerRadius = 10
        catButton.isHighlighted = true
        dogButton.isHighlighted = false
        animalsView.isHidden = false
        dogButton.isHidden = false
        catButton.isHidden = false
//        recordButton.layer.shadowRadius = 10
//        recordButton.layer.shadowPath
     
        recordButton.layer.shadowColor = UIColor.black.cgColor
        recordButton.layer.shadowOpacity = 0.5 // Увеличиваем opacity для более явной тени
        recordButton.layer.shadowOffset = CGSize(width: 1, height: 4)
        recordButton.layer.shadowRadius = 10
        
        stopRecordingButton.layer.shadowColor = UIColor.black.cgColor
        stopRecordingButton.layer.shadowOpacity = 0.5 // Увеличиваем opacity для более явной тени
        stopRecordingButton.layer.shadowOffset = CGSize(width: 1, height: 4)
        stopRecordingButton.layer.shadowRadius = 10
        
        animalsView.layer.shadowColor = UIColor.black.cgColor
        animalsView.layer.shadowOpacity = 0.5 // Увеличиваем opacity для более явной тени
        animalsView.layer.shadowOffset = CGSize(width: 1, height: 4)
        animalsView.layer.shadowRadius = 10
    }
    
//    func setupAnimationView(){
////        lottieImage = .init(name: "Animation - 1739536959711")
//////        self.lottieImage.frame = view.frame
//////        self.lottieImage.contentMode = .scaleAspectFit
//////        self.lottieImage.loopMode = .loop
//////        self.lottieImage.animationSpeed = 1.0
//////        view.addSubview(lottieImage)
//////        self.lottieImage.play()
//        
//       
//        self.lottieImage.loopMode = .loop
//        self.lottieImage.animationSpeed = 1.0
//        self.lottieImage.play()
//        self.lottieImage.isHidden = true
//
//    }
    func setupAnimationView() {
        lottieAnimationView = LottieAnimationView(name: "Animation - 1739536959711")
           lottieAnimationView.translatesAutoresizingMaskIntoConstraints = false
           lottieAnimationView.loopMode = .loop
           lottieAnimationView.animationSpeed = 1.0
           lottieAnimationView.play()
        lottieAnimationView.isHidden = true
           // Добавляем анимацию на экран
           view.addSubview(lottieAnimationView)

           // Устанавливаем ограничения для анимации
           NSLayoutConstraint.activate([
               lottieAnimationView.centerXAnchor.constraint(equalTo: recordButton.centerXAnchor),
               lottieAnimationView.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor),
               lottieAnimationView.widthAnchor.constraint(equalTo: recordButton.widthAnchor),
               lottieAnimationView.heightAnchor.constraint(equalTo: recordButton.heightAnchor)
           ])
           
           // Разрешаем взаимодействие с кнопкой через анимацию
           lottieAnimationView.isUserInteractionEnabled = false
         }
    func requestMicrophonePermission(){
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async{
                if granted {
                    print("Yes")
                }else{
                    print("No")
                    self.showSettingsAlert()
                }
            }
        }
    }
    func showSettingsAlert(){
        let alert = UIAlertController(
            title: "Enable Microphone Access",
            message: "Please allow acces to your microphone to use the app's features",
            preferredStyle: .alert
            )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Settings", style: .default){_ in
            if let url = URL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(url)
            }
        })
        DispatchQueue.main.async{
            if let topController = UIApplication.shared.windows.first?.rootViewController{
                topController.present(alert, animated: true)
            }
        }
    }
}

