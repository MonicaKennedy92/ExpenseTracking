import UIKit

open class Button: UIButton {
    
    public typealias Action = (Button) -> Swift.Void
    
    fileprivate var actionOnTouch: Action?
    
    init() {
        super.init(frame: .zero)
    }
  
    
  
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func action(_ closure: @escaping Action) {
        if actionOnTouch == nil {
            addTarget(self, action: #selector(Button.actionOnTouchUpInside), for: .touchUpInside)
        }
        self.actionOnTouch = closure
    }
    
    @objc internal func actionOnTouchUpInside() {
        actionOnTouch?(self)
    }
}
@IBDesignable class RoundImage: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        refreshCorners(value: cornerRadiuss)
        
        // Common logic goes here
    }
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    @IBInspectable var cornerRadiuss: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadiuss)
        }
    }
}
@IBDesignable class RoundButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateLayerProperties()

        sharedInit()
    }
    func updateLayerProperties() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10.0
        self.layer.masksToBounds = false
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        refreshCorners(value: cornerRadiuss)
        
        // Common logic goes here
    }
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    @IBInspectable var cornerRadiuss: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadiuss)
        }
    }
}
//@IBDesignable class RoundLabel: UILabel {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        sharedInit()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        sharedInit()
//    }
//    
//    override func prepareForInterfaceBuilder() {
//        sharedInit()
//    }
//    
//    func sharedInit() {
//        refreshCorners(value: cornerRadius)
//        
//        // Common logic goes here
//    }
//    func refreshCorners(value: CGFloat) {
//        layer.cornerRadius = value
//    }
//    @IBInspectable var cornerRadiuss: CGFloat = 15 {
//        didSet {
//            refreshCorners(value: cornerRadius)
//        }
//    }
//}
@IBDesignable class RoundView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        refreshCorners(value: cornerRadiuss)
        
        // Common logic goes here
    }
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    @IBInspectable var cornerRadiuss: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadiuss)
        }
    }
}
