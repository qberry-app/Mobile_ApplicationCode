import UIKit

@IBDesignable
public class LinearProgressView: UIView {
    
    public enum FillAxis: Int {
        case horizontal = 0
        case vertical = 1
    }
    
    /// Progress value between 0 - 100
    @IBInspectable public var progress: CGFloat = 0.0 {
        didSet {
            updateProgressLayer()
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 8 {
        didSet {
            setupLayers()
        }
    }
    
    @IBInspectable public var backgroundColorLayer: UIColor = .clear {
        didSet {
            backgroundLayer.backgroundColor = backgroundColorLayer.cgColor
        }
    }
    
    @IBInspectable public var foregroundColor: UIColor = .blue {
        didSet {
            progressLayer.backgroundColor = foregroundColor.cgColor
        }
    }
    
    @IBInspectable public var fillAxisRawValue: Int = 0 {
        didSet {
            fillAxis = FillAxis(rawValue: fillAxisRawValue) ?? .horizontal
        }
    }
    
    private var fillAxis: FillAxis = .horizontal
    
    private let progressLayer = CALayer()
    private let backgroundLayer = CALayer()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        // Remove existing layers to avoid duplicates
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        // Background layer setup
        backgroundLayer.backgroundColor = backgroundColorLayer.cgColor
        backgroundLayer.cornerRadius = cornerRadius
        backgroundLayer.masksToBounds = true
        layer.addSublayer(backgroundLayer)
        
        // Progress layer setup
        progressLayer.backgroundColor = foregroundColor.cgColor
        progressLayer.cornerRadius = cornerRadius
        progressLayer.masksToBounds = true
        layer.addSublayer(progressLayer)
    }
    
    public func setProgress(_ progress: CGFloat, animated: Bool = false, duration: TimeInterval = 0.25) {
        self.progress = min(max(progress, 0), 100) // Clamp progress between 0 and 100
        
        if animated {
            CATransaction.begin()
            CATransaction.setAnimationDuration(duration)
            CATransaction.setDisableActions(false)
            updateProgressLayer()
            CATransaction.commit()
        } else {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            updateProgressLayer()
            CATransaction.commit()
        }
    }
    
    private func updateProgressLayer() {
        let totalWidth = bounds.width
        let totalHeight = bounds.height
        if fillAxis == .horizontal {
            progressLayer.frame = CGRect(
                x: 0,
                y: 0,
                width: totalWidth * (progress / 100),
                height: totalHeight
            )
        } else {
            progressLayer.frame = CGRect(
                x: 0,
                y: totalHeight - (totalHeight * (progress / 100)),
                width: totalWidth,
                height: totalHeight * (progress / 100)
            )
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = bounds
        updateProgressLayer()
    }
}
