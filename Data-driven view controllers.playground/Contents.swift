
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
PlaygroundPage.current.liveView = prepareFor
