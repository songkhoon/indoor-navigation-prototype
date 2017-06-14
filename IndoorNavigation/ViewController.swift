//
//  ViewController.swift
//  IndoorNavigation
//
//  Created by jeff on 08/06/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let landingView: UIView = {
        let view = UIView()
        return view
    }()
    
    let signInView: UIView = {
        let view = UIView()
        return view
    }()
    
    let signUpView: UIView = {
        let view = UIView()
        return view
    }()
    
    let signUpNameField: UITextField = {
        let view = UITextField()
        view.placeholder = "Name"
        return view
    }()
    
    let signUpEmailField: UITextField = {
        let view = UITextField()
        view.placeholder = "Email"
        view.keyboardType = .emailAddress
        return view
    }()
    
    let signUpPasswordField: UITextField = {
        let view = UITextField()
        view.placeholder = "Password"
        view.isSecureTextEntry = true
        return view
    }()
    
    let signInEmailField:UITextField = {
        let view = UITextField()
        view.placeholder = "Email"
        view.keyboardType = .emailAddress
        return view
    }()
    
    let signInPasswordField:UITextField = {
        let view = UITextField()
        view.placeholder = "Password"
        view.isSecureTextEntry = true
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupLandingView()
        setupSignUpView()
        setupSignInView()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    private func setupBackground() {
        let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "background"))
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
        view.addSubview(backgroundImage)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true
        view.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.centerXAnchor.constraint(equalTo: backgroundImage.centerXAnchor).isActive = true
        blurView.centerYAnchor.constraint(equalTo: backgroundImage.centerYAnchor).isActive = true
        blurView.widthAnchor.constraint(equalTo: backgroundImage.widthAnchor, multiplier: 1).isActive = true
        blurView.heightAnchor.constraint(equalTo: backgroundImage.heightAnchor, multiplier: 1).isActive = true
    }
    
    private func setupLandingView() {
        view.addSubview(landingView)
        landingView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        let signupButton = ZFRippleButton()
        signupButton.backgroundColor = .blue
        signupButton.layer.cornerRadius = 5
        signupButton.layer.borderColor = UIColor.white.cgColor
        signupButton.setTitle("Create Free Account", for: .normal)
        signupButton.addTarget(self, action: #selector(handleSignUpFromLanding), for: .touchUpInside)
        landingView.addSubview(signupButton)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.topAnchor.constraint(equalTo: landingView.topAnchor, constant: 30).isActive = true
        signupButton.centerXAnchor.constraint(equalTo: landingView.centerXAnchor, constant: 0).isActive = true
        signupButton.widthAnchor.constraint(equalTo: landingView.widthAnchor, multiplier: 0.8).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let signinButton = ZFRippleButton()
        signinButton.setTitle("Sign In", for: .normal)
        signinButton.setTitleColor(.black, for: .normal)
        signinButton.backgroundColor = .white
        signinButton.layer.cornerRadius = 5
        signinButton.layer.borderWidth = 1
        signinButton.layer.borderColor = UIColor.blue.cgColor
        signinButton.addTarget(self, action: #selector(handleSignInFromLanding), for: .touchUpInside)
        landingView.addSubview(signinButton)
        signinButton.translatesAutoresizingMaskIntoConstraints = false
        signinButton.topAnchor.constraint(equalTo: signupButton.bottomAnchor, constant: 20).isActive = true
        signinButton.centerXAnchor.constraint(equalTo: signupButton.centerXAnchor, constant: 0).isActive = true
        signinButton.widthAnchor.constraint(equalTo: signupButton.widthAnchor, multiplier: 1).isActive =  true
        signinButton.heightAnchor.constraint(equalTo: signupButton.heightAnchor, multiplier: 1).isActive = true
        
        let layoutGuideLeft = UILayoutGuide()
        landingView.addLayoutGuide(layoutGuideLeft)
        layoutGuideLeft.leadingAnchor.constraint(equalTo: signinButton.leadingAnchor, constant: 0).isActive = true
        layoutGuideLeft.widthAnchor.constraint(equalTo: signinButton.widthAnchor, multiplier: 0.5).isActive = true
        layoutGuideLeft.topAnchor.constraint(equalTo: signinButton.bottomAnchor, constant: 20).isActive = true
        layoutGuideLeft.heightAnchor.constraint(equalToConstant: 50).isActive = true
        let layoutGuideRight = UILayoutGuide()
        landingView.addLayoutGuide(layoutGuideRight)
        layoutGuideRight.leadingAnchor.constraint(equalTo: layoutGuideLeft.trailingAnchor, constant: 0).isActive = true
        layoutGuideRight.topAnchor.constraint(equalTo: layoutGuideLeft.topAnchor, constant: 0).isActive = true
        layoutGuideRight.widthAnchor.constraint(equalTo: layoutGuideLeft.widthAnchor, multiplier: 1).isActive = true
        layoutGuideRight.heightAnchor.constraint(equalTo: layoutGuideLeft.heightAnchor, multiplier: 1).isActive = true
        
        let facebookConnect = UIButton()
        facebookConnect.setImage(#imageLiteral(resourceName: "facebook"), for: .normal)
        facebookConnect.imageView?.contentMode = .scaleAspectFit
        landingView.addSubview(facebookConnect)
        facebookConnect.translatesAutoresizingMaskIntoConstraints = false
        facebookConnect.centerXAnchor.constraint(equalTo: layoutGuideLeft.centerXAnchor, constant: 0).isActive = true
        facebookConnect.centerYAnchor.constraint(equalTo: layoutGuideLeft.centerYAnchor, constant: 0).isActive = true
        facebookConnect.heightAnchor.constraint(equalTo: layoutGuideLeft.heightAnchor, multiplier: 1).isActive = true
        
        let googlePlus = UIButton()
        googlePlus.setImage(#imageLiteral(resourceName: "google-plus"), for: .normal)
        googlePlus.imageView?.contentMode = .scaleAspectFit
        landingView.addSubview(googlePlus)
        googlePlus.translatesAutoresizingMaskIntoConstraints = false
        googlePlus.centerXAnchor.constraint(equalTo: layoutGuideRight.centerXAnchor, constant: 0).isActive = true
        googlePlus.centerYAnchor.constraint(equalTo: layoutGuideRight.centerYAnchor, constant: 0).isActive = true
        googlePlus.heightAnchor.constraint(equalTo: layoutGuideRight.heightAnchor, multiplier: 1).isActive = true
        
        landingView.translatesAutoresizingMaskIntoConstraints = false
        landingView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        landingView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        landingView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        landingView.bottomAnchor.constraint(equalTo: googlePlus.bottomAnchor, constant: 20).isActive = true

    }
    
    private func setupSignUpView() {
        signUpView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        view.addSubview(signUpView)
        signUpView.isHidden = true
        
        let backButton = UIButton()
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.blue, for: .normal)
        backButton.addTarget(self, action: #selector(handleBackFromSignUp), for: .touchUpInside)
        signUpView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leadingAnchor.constraint(equalTo: signUpView.leadingAnchor, constant: 0).isActive = true
        backButton.topAnchor.constraint(equalTo: signUpView.topAnchor, constant: 10).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let createLabel = UILabel()
        createLabel.text = "Create Free Account"
        createLabel.font = UIFont.boldSystemFont(ofSize: 16)
        createLabel.textColor = .black
        createLabel.textAlignment = .center
        signUpView.addSubview(createLabel)
        createLabel.translatesAutoresizingMaskIntoConstraints = false
        createLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 0).isActive = true
        createLabel.centerXAnchor.constraint(equalTo: signUpView.centerXAnchor, constant: 0).isActive = true
        createLabel.widthAnchor.constraint(equalTo: signUpView.widthAnchor, constant: 0).isActive = true
        createLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let signupForm = UIView()
        signupForm.backgroundColor = .white
        signupForm.translatesAutoresizingMaskIntoConstraints = false
        signUpView.addSubview(signupForm)
        
        let nameSperator = UIView()
        nameSperator.backgroundColor = UIColor.gray
        nameSperator.translatesAutoresizingMaskIntoConstraints = false
        let emailSperator = UIView()
        emailSperator.backgroundColor = UIColor.gray
        emailSperator.translatesAutoresizingMaskIntoConstraints = false
        
        let stackForm = UIStackView(arrangedSubviews: [signUpNameField, nameSperator, signUpEmailField, emailSperator, signUpPasswordField])
        stackForm.axis = .vertical
        stackForm.alignment = .fill
        stackForm.distribution = .fill
        stackForm.spacing = 10
        signupForm.addSubview(stackForm)
        
        nameSperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        emailSperator.heightAnchor.constraint(equalToConstant: 1).isActive = true

        signupForm.centerXAnchor.constraint(equalTo: signUpView.centerXAnchor, constant: 0).isActive = true
        signupForm.widthAnchor.constraint(equalTo: signUpView.widthAnchor, multiplier: 0.9).isActive = true
        signupForm.topAnchor.constraint(equalTo: createLabel.bottomAnchor, constant: 30).isActive = true
        signupForm.bottomAnchor.constraint(equalTo: stackForm.bottomAnchor, constant: 10).isActive = true

        stackForm.translatesAutoresizingMaskIntoConstraints = false
        stackForm.centerXAnchor.constraint(equalTo: signupForm.centerXAnchor, constant: 0).isActive = true
        stackForm.centerYAnchor.constraint(equalTo: signupForm.centerYAnchor, constant: 0).isActive = true
        stackForm.widthAnchor.constraint(equalTo: signupForm.widthAnchor, multiplier: 0.9).isActive = true
        
        let signupButton = ZFRippleButton()
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.setTitleColor(UIColor.white, for: .normal)
        signupButton.backgroundColor = UIColor.blue
        signupButton.layer.cornerRadius = 5;
        signupButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        signUpView.addSubview(signupButton)
        
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.centerXAnchor.constraint(equalTo: signUpView.centerXAnchor, constant: 0).isActive = true
        signupButton.topAnchor.constraint(equalTo: signupForm.bottomAnchor, constant: 20).isActive = true
        signupButton.widthAnchor.constraint(equalTo: signupForm.widthAnchor, constant: 0).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        signUpView.translatesAutoresizingMaskIntoConstraints = false
        signUpView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        signUpView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        signUpView.bottomAnchor.constraint(equalTo: signupButton.bottomAnchor, constant: 20).isActive = true
    }
    
    private func setupSignInView() {
        signInView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        view.addSubview(signInView)
        signInView.isHidden = true
        
        let backButton = UIButton()
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.blue, for: .normal)
        backButton.addTarget(self, action: #selector(handleBackFromSignIn), for: .touchUpInside)
        signInView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leadingAnchor.constraint(equalTo: signInView.leadingAnchor, constant: 0).isActive = true
        backButton.topAnchor.constraint(equalTo: signInView.topAnchor, constant: 10).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

        let signInLabel = UILabel()
        signInLabel.text = "Sign In"
        signInLabel.font = UIFont.boldSystemFont(ofSize: 16)
        signInLabel.textAlignment = .center
        signInView.addSubview(signInLabel)
        
        let signInForm = UIView()
        signInForm.backgroundColor = UIColor.white
        signInView.addSubview(signInForm)
        
        let emailSperator = UIView()
        emailSperator.backgroundColor = UIColor.gray
        
        let stackForm = UIStackView(arrangedSubviews: [signInEmailField, emailSperator, signInPasswordField])
        stackForm.axis = .vertical
        stackForm.distribution = .fill
        stackForm.alignment = .fill
        stackForm.spacing = 10
        signInForm.addSubview(stackForm)
        
        emailSperator.translatesAutoresizingMaskIntoConstraints = false
        emailSperator.widthAnchor.constraint(equalTo: stackForm.widthAnchor, multiplier: 1).isActive = true
        emailSperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let signInButton = ZFRippleButton()
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.backgroundColor = UIColor.blue
        signInButton.layer.cornerRadius = 5
        signInButton.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        signInView.addSubview(signInButton)
        
        signInLabel.translatesAutoresizingMaskIntoConstraints = false
        signInLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 0).isActive = true
        signInLabel.centerXAnchor.constraint(equalTo: signInView.centerXAnchor, constant: 0).isActive = true
        signInLabel.widthAnchor.constraint(equalTo: signInView.widthAnchor, multiplier: 0.9).isActive = true
        signInLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        signInForm.translatesAutoresizingMaskIntoConstraints = false
        signInForm.centerXAnchor.constraint(equalTo: signInView.centerXAnchor).isActive = true
        signInForm.topAnchor.constraint(equalTo: signInLabel.bottomAnchor, constant: 10).isActive = true
        signInForm.widthAnchor.constraint(equalTo: signInView.widthAnchor, multiplier: 0.8).isActive = true
        signInForm.bottomAnchor.constraint(equalTo: stackForm.bottomAnchor, constant: 10).isActive = true
        
        stackForm.translatesAutoresizingMaskIntoConstraints = false
        stackForm.centerXAnchor.constraint(equalTo: signInForm.centerXAnchor, constant: 0).isActive = true
        stackForm.centerYAnchor.constraint(equalTo: signInForm.centerYAnchor, constant: 0).isActive = true
        stackForm.widthAnchor.constraint(equalTo: signInForm.widthAnchor, multiplier: 0.9).isActive = true
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.centerXAnchor.constraint(equalTo: signInForm.centerXAnchor, constant: 0).isActive = true
        signInButton.topAnchor.constraint(equalTo: signInForm.bottomAnchor, constant: 20).isActive = true
        signInButton.widthAnchor.constraint(equalTo: signInForm.widthAnchor, multiplier: 1).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        signInView.translatesAutoresizingMaskIntoConstraints = false
        signInView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        signInView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        signInView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        signInView.bottomAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20).isActive = true
    }
    
    @objc
    private func handleSignUpFromLanding() {
        showSignUpFromLanding()
    }
    
    @objc
    private func handleSignInFromLanding() {
        showSignInFromLanding()
    }
    
    @objc
    private func handleBackFromSignUp() {
        showLandingFromSignup()
    }
    
    @objc
    private func handleBackFromSignIn() {
        showLandingFromSignIn()
    }
    
    @objc
    private func handleSignIn() {
        showHomeViewController()
    }
    
    @objc
    private func handleSignUp() {
        showHomeViewController()
    }
    
    private func showSignUpFromLanding() {
        signUpView.isHidden = false
        let originX = landingView.center.x
        signUpView.center.x = view.frame.width * 2
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: UIViewKeyframeAnimationOptions.calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.landingView.center.x = -self.view.bounds.width
            })
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.signUpView.center.x = originX
                self.signUpNameField.becomeFirstResponder()
            })
        }) { (complete) in
            self.landingView.isHidden = true
        }
    }
    
    private func showLandingFromSignup() {
        let originX = signUpView.center.x
        landingView.isHidden = false
        landingView.center.x = -view.frame.width
        UIView.animate(withDuration: 0.5, animations: { 
            self.landingView.center.x = originX
            self.signUpView.center.x = self.view.frame.width * 2
        }) { (complete) in
            self.signUpView.isHidden = true
            self.view.endEditing(true)
        }
    }
    
    private func showSignInFromLanding() {
        signInView.isHidden = false
        signInView.center.x = view.frame.width * 2
        let originX = landingView.center.x
        UIView.animate(withDuration: 0.5, animations: {
            self.landingView.center.x = -self.view.bounds.width
            self.signInView.center.x = originX
        }) {(complete) in
            self.landingView.isHidden = true
            self.signInEmailField.becomeFirstResponder()
        }
    }
    
    private func showLandingFromSignIn() {
        let originX = signInView.center.x
        landingView.isHidden = false
        landingView.center.x = -view.frame.width
        UIView.animate(withDuration: 0.5, animations: {
            self.landingView.center.x = originX
            self.signInView.center.x = self.view.frame.width * 2
        }) { (complete) in
            self.signInView.isHidden = true
            self.view.endEditing(true)
        }

    }

    private func showHomeViewController() {
        let homeViewController = HomeViewController()
        let navigator = UINavigationController(rootViewController: homeViewController)
        present(navigator, animated: true) { 
            
        }
    }
    
}

