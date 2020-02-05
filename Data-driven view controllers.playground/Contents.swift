import UIKit
import PlaygroundSupport
import Foundation

public class Ring: UIView {
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let halfSize = min(bounds.size.width/2, bounds.size.height/2)
        let desiredLineWidth: CGFloat = 1
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: halfSize, y: halfSize),
            radius: halfSize - (desiredLineWidth / 2),
            startAngle: 0,
            endAngle: CGFloat(Double.pi * 2),
            clockwise: true
        )
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = desiredLineWidth
        
        layer.addSublayer(shapeLayer)
    }
}

class MyViewController : UIViewController {
    struct Props {
        let title: String
        let onLeft: (() -> ())?
        let onCenter: (() -> ())?
        let onRight: (() -> ())?
        
        static let initial = Props(title: String(), onLeft: nil, onCenter: nil, onRight: nil)
    }
    
    var props: Props = Props.initial {
        didSet {
            view.setNeedsLayout()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        label.text = props.title
        leftButton.isEnabled = props.onLeft != nil
        centerButton.isEnabled = props.onCenter != nil
        rightButton.isEnabled = props.onRight != nil
    }
    
    lazy var label = view.makeLabel()
    lazy var leftButton = view.makeButton(
        title: "Police",
        centerXAnchorConstant: -75,
        target: self,
        selector: #selector(onLeftButtonDidTap)
    )
    
    lazy var centerButton = view.makeButton(
        title: "Teacher",
        centerXAnchorConstant: 0,
        target: self,
        selector: #selector(onCenterButtonDidTap)
    )
    
    lazy var rightButton = view.makeButton(
        title: "Doctor",
        centerXAnchorConstant: 75,
        target: self,
        selector: #selector(onRightButtonDidTap)
    )

    @objc func onLeftButtonDidTap() {
        props.onLeft?()
    }
    
    @objc func onCenterButtonDidTap() {
        props.onCenter?()
    }
    
    @objc func onRightButtonDidTap() {
        props.onRight?()
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white
    }
}

public extension UIView {
    
    func makeTableView(delegateAndDatasource: UITableViewDataSource & UITableViewDelegate) -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = delegateAndDatasource
        tableView.delegate = delegateAndDatasource
        addSubview(tableView)
        tableView.bindFrameToSuperviewBounds()
        return tableView
    }
    
    func makeActivityIndicatorView() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        return activityIndicator
    }
    
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
    
    func makePasswordTextView(_ delegate: UITextViewDelegate) -> UITextView {
        return makeTextView(delegate: delegate, centerYAnchorConstant: -50)
    }
    
    func makeConfirmPasswordTextView(_ delegate: UITextViewDelegate) -> UITextView {
        return makeTextView(delegate: delegate, centerYAnchorConstant: 70)
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
    
    func makePasswordLabel() -> UILabel {
        return makeLabel(centerYAnchorConstant: -120, text: "password:")
    }
    
    func makeConfirmPasswordLabel() -> UILabel {
        return makeLabel(centerYAnchorConstant: 10 ,text: "confirm:")
    }
    
    func makeLabel(centerXAnchorConstant: CGFloat = 0, centerYAnchorConstant: CGFloat = 0, text: String = "") -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 55)
        addSubview(label)
        label.centerXAnchor.constraint(equalTo: centerXAnchor, constant: centerXAnchorConstant).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: centerYAnchorConstant).isActive = true
        return label
    }
    
    func makeRingView() -> Ring {
        let ring = Ring(frame: CGRect(x: 60, y: 60, width: 200, height: 200))
        addSubview(ring)
        return ring
    }
    
    /// Adds constraints to this `UIView` instances `superview` object to make sure this always has the same size as the superview.
    /// Please note that this has no effect if its `superview` is `nil` – add this `UIView` instance as a subview before calling this.
    public func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-0@999-[subview]-0@999-|",
                options: [],
                metrics: nil,
                views: ["subview": self]
            )
        )
        superview.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0@999-[subview]-0@999-|",
                options: [],
                metrics: nil,
                views: ["subview": self]
            )
        )
    }
}

let vc = MyViewController()
PlaygroundPage.current.liveView = vc

let police = "👮‍♂️"
let teacher = "👨‍🏫"
let doctor = "👨🏼‍⚕️"
var profession = teacher

func update(with newProfession: String) {
    profession = newProfession
    
    print(profession)
    
    vc.props = MyViewController.Props(
        title: profession,
        onLeft: police == profession ? nil : { update(with: police) },
        onCenter: teacher == profession ? nil : { update(with: teacher) },
        onRight: doctor == profession ? nil : { update(with: doctor) }
    )
}

update(with: police)
