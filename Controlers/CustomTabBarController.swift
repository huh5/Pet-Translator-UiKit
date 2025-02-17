//
//  CustomTabBarController.swift
//  Pet Translator
//
//  Created by Богдан Ткачивський on 13/02/2025.
//

import UIKit

class CustomTabBarController: UITabBarController {
    var buttons: [UIButton] = []
    var labels: [UILabel] = []
    let tabbarView = UIView()
    let tabbarItemBackgroundView = UIView()
    var centerConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true // Hide the default tab bar
        
        setView()
        generateControllers() // Initialize view controllers
        setupButtons()
    }
    
    private func generateControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let translatorVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let clickerVC = storyboard.instantiateViewController(withIdentifier: "ClickerViewController") as! ClickerViewController
        
        // Create view controllers with images and labels
        let home = generateViewController(image: UIImage(systemName: "message")!, vc: UINavigationController(rootViewController: translatorVC), tag: 0, label: "Translator")
        let settings = generateViewController(image: UIImage(systemName: "gearshape")!, vc: UINavigationController(rootViewController: clickerVC), tag: 1, label: "Clicker")
        
        
        viewControllers = [home, settings] // Set the view controllers
    }
    
    private func generateViewController(image: UIImage, vc: UIViewController, tag: Int, label: String) -> UIViewController {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .gray // Устанавливаем изначально серый цвет
        button.setImage(image.resize(targetSize: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysTemplate), for: .normal)
        button.tag = tag
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        let labelView = UILabel()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.text = label
        labelView.textColor = .black
        labelView.font = UIFont.systemFont(ofSize: 12)
        labelView.textAlignment = .center
        
        buttons.append(button)
        labels.append(labelView)
        
        return vc
    }
    
    private func setView() {
        view.addSubview(tabbarView)
        tabbarView.backgroundColor = .white
        tabbarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabbarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            tabbarView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -160),
            tabbarView.heightAnchor.constraint(equalToConstant: 80),
            tabbarView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        tabbarView.layer.cornerRadius = 15
    }
    
    private func setupButtons() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 10
        
        for (index, button) in buttons.enumerated() {
            let buttonStackView = UIStackView()
            buttonStackView.axis = .vertical
            buttonStackView.alignment = .center
            buttonStackView.spacing = 5
            buttonStackView.addArrangedSubview(button)
            buttonStackView.addArrangedSubview(labels[index])
            stackView.addArrangedSubview(buttonStackView)
        }
        
        tabbarView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: tabbarView.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: tabbarView.trailingAnchor, constant: -50),
            stackView.topAnchor.constraint(equalTo: tabbarView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: tabbarView.bottomAnchor)
        ])
        
        // Set the first button as active
        buttons.first?.tintColor = .black
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        selectedIndex = sender.tag
        
        // Reset all button colors to gray
        for button in buttons {
            button.tintColor = .gray
        }
        
        // Highlight the selected button
        sender.tintColor = .black
    }
}

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
