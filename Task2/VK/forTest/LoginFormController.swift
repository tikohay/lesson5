//
//  LoginFormController.swift
//  VK
//
//  Created by Karahanyan Levon on 04.01.2021.
//

import UIKit

class LoginFormController: UIViewController {

    @IBOutlet weak var logoVKImage: UIImageView?
    @IBOutlet weak var loginButton: UIButton?
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var loginVKTextField: UITextField?
    @IBOutlet weak var passwordVKTextField: UITextField?
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var hidePasswordButton: UIButton?
    @IBOutlet weak var loadingView: UIView? {
        didSet {
            loadingView?.layer.cornerRadius = (loadingView?.frame.width)! / 2
            loadingView?.layer.opacity = 0
            loadingView?.layer.borderWidth = 1
            loadingView?.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    private var isPasswordHidden = true
    private var keyboardShown = false
    
    @IBAction func tappedLogin(_ sender: UIButton) {
        guard let loginButton = loginButton else { return }
        animateView(loginButton)
        
        let group = CAAnimationGroup()
        group.animations = changeOpacityAndSlideRightAnimation()
        group.duration = 3
        group.setValue("loadingCircles", forKey: "loginFormAnimation")
        group.delegate = self
    
        loadingView?.layer.add(group, forKey: nil)
        group.isRemovedOnCompletion = true
    }
    
    @IBAction func onHidePasswordButtonClick(_ sender: UIButton) {
        
        let imageEye = UIImage(systemName: "eye")
        let imageEyeSlash = UIImage(systemName: "eye.slash")
        
        if isPasswordHidden {
            passwordVKTextField?.isSecureTextEntry = false
            sender.setImage(imageEyeSlash, for: .normal)
        } else {
            passwordVKTextField?.isSecureTextEntry = true
            sender.setImage(imageEye, for: .normal)
        }
        
        isPasswordHidden.toggle()
    }
    
    @IBAction func logOutSegue(unwindSegue: UIStoryboardSegue) {
        
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        if shouldPerformSegue(withIdentifier: identifier, sender: sender) {
            super.performSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareElementsToView()
        addTapGestureRecognizer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        logoVKImage?.layer.removeAllAnimations()
        loadingView?.layer.removeAllAnimations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObservers()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        let checkResult = checkUserData()
        
        if !checkResult {
            showLoginError()
        }
        return checkResult
    }
    
    private func animateView(_ viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.15,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseIn,
                       animations: {
                        viewToAnimate.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
                       }) { (_) in
            UIView.animate(withDuration: 0.15,
                           delay: 0,
                           usingSpringWithDamping: 0.4,
                           initialSpringVelocity: 2,
                           options: .curveEaseIn,
                           animations: {
                            viewToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)
                           }, completion: nil)
        }
    }
    
    private func prepareElementsToView() {
        logoVKImage?.layer.cornerRadius = 20
        logoVKImage?.clipsToBounds = true
        
        loginButton?.layer.cornerRadius = 10
        loginButton?.clipsToBounds = true
        
        stackView.spacing = 0.2
        
        loginVKTextField?.layer.cornerRadius = 10
        loginVKTextField?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        passwordVKTextField?.layer.cornerRadius = 10
        passwordVKTextField?.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWasShown),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillBeHidden),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardDidHideNotification,
                                                  object: nil)
    }
    
    private func addTapGestureRecognizer() {
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    private func checkUserData() -> Bool {
        
        guard let login = loginVKTextField?.text, let password = passwordVKTextField?.text else {
            return false
        }
        return login == "admin" && password == "1234567"
    }
    
    private func showLoginError() {
        let alert = UIAlertController(title: "Ошибка", message: "вы ввели неправильные данные", preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func keyboardWasShown(notification: Notification) {
        guard !keyboardShown else { return }
        let info = notification.userInfo! as NSDictionary
        let kbsize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbsize.height, right: 0.0)
        
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
        keyboardShown = true
        
        hidePasswordButton?.isHidden = false
    }
    
    @objc private func keyboardWillBeHidden() {
        guard keyboardShown else { return }
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
        keyboardShown = false
        
        hidePasswordButton?.isHidden = true
    }
    
    @objc private func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    
    func changeOpacityAndSlideRightAnimation() -> [CABasicAnimation] {
        
        let animOpacity1 = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        animOpacity1.toValue = 1
        animOpacity1.duration = 0.2
        
        let animOpacity2 = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        animOpacity2.fromValue = 1
        animOpacity2.toValue = 0
        animOpacity2.duration = 0.2
        animOpacity2.beginTime = 0.2
        
        let animPosition1 = CABasicAnimation(keyPath: "position.x")
        animPosition1.toValue = self.view.frame.width / 2
        animPosition1.duration = 0.2
        animPosition1.beginTime = 0.4
        animPosition1.fillMode = .forwards
        
        let animOpacity3 = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        animOpacity3.toValue = 1
        animOpacity3.duration = 0.2
        animOpacity3.beginTime = 0.6
        
        let animOpacity4 = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        animOpacity4.fromValue = 1
        animOpacity4.toValue = 0
        animOpacity4.duration = 0.2
        animOpacity4.beginTime = 0.8
        
        let animPosition2 = CABasicAnimation(keyPath: "position.x")
        animPosition2.toValue = logoVKImage!.layer.position.x + (logoVKImage!.frame.width / 2)
        animPosition2.duration = 0.2
        animPosition2.beginTime = 1
        animPosition2.fillMode = .forwards
        
        let animOpacity5 = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        animOpacity5.toValue = 1
        animOpacity5.duration = 0.4
        animOpacity5.beginTime = 1.2
        
        let animOpacity6 = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        animOpacity6.fromValue = 1
        animOpacity6.toValue = 0
        animOpacity6.duration = 0.4
        animOpacity6.beginTime = 1.6
        
        return [animOpacity1, animOpacity2, animPosition1, animOpacity3, animOpacity4, animPosition2, animOpacity5, animOpacity6]
    }
    
    func slideDownAndZoomIn() -> [CABasicAnimation] {
        
        let springAnimPosition = CASpringAnimation(keyPath: "position.y")
        springAnimPosition.toValue = self.logoVKImage!.layer.position.y + 200
        springAnimPosition.stiffness = 200
        springAnimPosition.mass = 1
        springAnimPosition.duration = 2
        springAnimPosition.fillMode = .forwards
        
        let animScale = CABasicAnimation(keyPath: "transform.scale")
        animScale.fromValue = 0
        animScale.toValue = 200
        animScale.duration = 3
        animScale.beginTime = 2
        animScale.fillMode = .forwards
        
        let animOpacity = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        animOpacity.toValue = 0
        animOpacity.duration = 3
        animOpacity.beginTime = 2
        
        return [springAnimPosition, animScale, animOpacity]
    }
}

extension LoginFormController: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        if let animationID = anim.value(forKey: "loginFormAnimation") {
            if animationID as! NSString == "loadingCircles" {
                checkUserDataForMakeAnimation()
            }
            
            if animationID as! NSString == "slideDownAndZoomIn" {
                 performSegue(withIdentifier: "toFriendsVC", sender: nil)
            }
        }
    }
    
    func checkUserDataForMakeAnimation() {
        if checkUserData() {
            let group = CAAnimationGroup()
            
            group.animations = slideDownAndZoomIn()
            group.duration = 3
            group.setValue("slideDownAndZoomIn", forKey: "loginFormAnimation")
            group.delegate = self
            
            logoVKImage?.layer.add(group, forKey: nil)
            group.isRemovedOnCompletion = true
        } else {
            showLoginError()
        }
    }
}
