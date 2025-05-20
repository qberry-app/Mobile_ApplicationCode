import UIKit

@IBDesignable public class GMStepper: UIControl, UITextFieldDelegate {

    /// Current value of the stepper. Defaults to 0.
    @objc @IBInspectable public var value: Double = 0 {
        didSet {
            value = min(maximumValue, max(minimumValue, value))
            textField.text = formattedValue

            if oldValue != value {
                sendActions(for: .valueChanged)
            }
        }
    }

    private var formattedValue: String? {
        let isInteger = Decimal(value).exponent >= 0
        if isInteger && stepValue == 1.0 && items.count > 0 {
            return items[Int(value)]
        } else {
            return formatter.string(from: NSNumber(value: value))
        }
    }

    @objc @IBInspectable public var minimumValue: Double = 0 {
        didSet {
            value = min(maximumValue, max(minimumValue, value))
        }
    }

    @objc @IBInspectable public var maximumValue: Double = 100 {
        didSet {
            value = min(maximumValue, max(minimumValue, value))
        }
    }

    @objc @IBInspectable public var stepValue: Double = 1 {
        didSet {
            setupNumberFormatter()
        }
    }

    @objc @IBInspectable public var autorepeat: Bool = true
    @objc @IBInspectable public var showIntegerIfDoubleIsInteger: Bool = true {
        didSet {
            setupNumberFormatter()
        }
    }

    @objc @IBInspectable public var leftButtonText: String = "−" {
        didSet {
            leftButton.setTitle(leftButtonText, for: .normal)
        }
    }

    @objc @IBInspectable public var rightButtonText: String = "+" {
        didSet {
            rightButton.setTitle(rightButtonText, for: .normal)
        }
    }

    @objc @IBInspectable public var buttonsTextColor: UIColor = UIColor.white {
        didSet {
            for button in [leftButton, rightButton] {
                button.setTitleColor(buttonsTextColor, for: .normal)
            }
        }
    }

    @objc @IBInspectable public var buttonsBackgroundColor: UIColor = UIColor(red: 0.21, green: 0.5, blue: 0.74, alpha: 1) {
        didSet {
            for button in [leftButton, rightButton] {
                button.backgroundColor = buttonsBackgroundColor
            }
            backgroundColor = buttonsBackgroundColor
        }
    }

    @objc public var buttonsFont = UIFont(name: "AvenirNext-Bold", size: 20.0)! {
        didSet {
            for button in [leftButton, rightButton] {
                button.titleLabel?.font = buttonsFont
            }
        }
    }

    @objc @IBInspectable public var textFieldTextColor: UIColor = UIColor.white {
        didSet {
            textField.textColor = textFieldTextColor
        }
    }

    @objc @IBInspectable public var textFieldBackgroundColor: UIColor = UIColor(red: 0.26, green: 0.6, blue: 0.87, alpha: 1) {
        didSet {
            textField.backgroundColor = textFieldBackgroundColor
        }
    }

    @objc public var textFieldFont = UIFont(name: "AvenirNext-Bold", size: 25.0)! {
        didSet {
            textField.font = textFieldFont
        }
    }

    @objc @IBInspectable public var cornerRadius: CGFloat = 4.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
    }

    @objc @IBInspectable public var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
            textField.layer.borderWidth = borderWidth
        }
    }

    @objc @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
            textField.layer.borderColor = borderColor.cgColor
        }
    }

    @objc @IBInspectable public var labelWidthWeight: CGFloat = 0.5 {
        didSet {
            labelWidthWeight = min(1, max(0, labelWidthWeight))
            setNeedsLayout()
        }
    }

    let formatter = NumberFormatter()

    lazy public var leftButton: UIButton = {
        let button = UIButton()
        button.setTitle(self.leftButtonText, for: .normal)
        button.setTitleColor(self.buttonsTextColor, for: .normal)
        button.backgroundColor = self.buttonsBackgroundColor
        button.titleLabel?.font = self.buttonsFont
        button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy public var rightButton: UIButton = {
        let button = UIButton()
        button.setTitle(self.rightButtonText, for: .normal)
        button.setTitleColor(self.buttonsTextColor, for: .normal)
        button.backgroundColor = self.buttonsBackgroundColor
        button.titleLabel?.font = self.buttonsFont
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.text = formattedValue
        textField.textColor = self.textFieldTextColor
        textField.backgroundColor = self.textFieldBackgroundColor
        textField.font = self.textFieldFont
        textField.layer.cornerRadius = cornerRadius
        textField.layer.masksToBounds = true
        textField.keyboardType = .decimalPad
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        return textField
    }()

    @objc required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    fileprivate func setup() {
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(textField)

        backgroundColor = buttonsBackgroundColor
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        setupNumberFormatter()
    }

    func setupNumberFormatter() {
        let decValue = Decimal(stepValue)
        let digits = decValue.significantFractionalDecimalDigits
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = showIntegerIfDoubleIsInteger ? 0 : digits
        formatter.maximumFractionDigits = digits
    }

    public override func layoutSubviews() {
        let buttonWidth = bounds.size.width * ((1 - labelWidthWeight) / 2)
        let labelWidth = bounds.size.width * labelWidthWeight

        leftButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: bounds.size.height)
        textField.frame = CGRect(x: buttonWidth, y: 0, width: labelWidth, height: bounds.size.height)
        rightButton.frame = CGRect(x: labelWidth + buttonWidth, y: 0, width: buttonWidth, height: bounds.size.height)
    }

    @objc func leftButtonTapped() {
        value -= stepValue
    }

    @objc func rightButtonTapped() {
        value += stepValue
    }

    @objc func textFieldEditingChanged(_ textField: UITextField) {
        guard let text = textField.text, let newValue = Double(text) else {
            return
        }
        value = min(maximumValue, max(minimumValue, newValue))
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, let newValue = Double(text) else {
            textField.text = formattedValue
            return
        }
        value = min(maximumValue, max(minimumValue, newValue))
    }
    @objc public var items: [String] = [] {
        didSet {
            textField.text = formattedValue
        }
    }

}
extension Decimal {
    var significantFractionalDecimalDigits: Int {
        return max(-exponent, 0)
    }
}
