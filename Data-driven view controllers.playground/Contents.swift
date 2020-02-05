
import UIKit
import PlaygroundSupport
import Foundation

class MyViewController: UIViewController {
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white
    }
}

let vc = MyViewController()

PlaygroundPage.current.liveView = vc

extension UIView {
    func makeButton(title: String, centerXAnchorConstant: CGFloat = 0, target: Any, selector: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: centerXAnchor, constant: centerXAnchorConstant).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 50).isActive = true
        button.addTarget(target, action: selector, for: .touchUpInside)
        return button
    }
    
    func makeTextView(delegate: UITextViewDelegate, centerYAnchorConstant: CGFloat) -> UITextView {
         let textView = UITextView()
         textView.translatesAutoresizingMaskIntoConstraints = false
         textView.font = UIFont.systemFont(ofSize: 35)
         addSubview(textView)
         textView.delegate = delegate
         textView.widthAnchor.constraint(equalTo: widthAnchor, constant: -50).isActive = true
         textView.heightAnchor.constraint(equalToConstant: 50).isActive = true
         textView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
         textView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: centerYAnchorConstant).isActive = true
         textView.layer.borderColor = UIColor.red.cgColor
         textView.layer.borderWidth = 1
         return textView
     }
}
