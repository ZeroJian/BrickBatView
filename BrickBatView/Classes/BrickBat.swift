//
//  BrickBat.swift
//  BrickView
//
//  Created by ZeroJianMBP on 2018/6/3.
//

import Foundation

public protocol BrickBat {
	
	/// 组件高度
	var itemHeight: CGFloat { get set }
	
	/// 组件底部布局是否增加了 margin 高度
	var isLastBottomMargin: Bool { get set }
	
	/// 创建 ItemView
	func markItemView() -> UIView?
	
	/// 创建 ItemControl
	func markItemControl() -> [UIControl]?
	
}



open class BrickItem: BrickBat {
    
    // set custom ui color for default BrickItem
    static var itemUI: UI = UI()
    
    public struct UI {
        /// Button Item
        public var buttonBackgroundColor: UIColor = UIColor(red:51/255, green:51/255, blue:51/255, alpha: 1.0)
        public var buttonCancelBorderColor: UIColor = UIColor(red:230/255, green:230/255, blue:230/255, alpha: 1.0)
        public var buttonFontColor = UIColor.white
        public var buttonFont: UIFont = UIFont.systemFont(ofSize: 16)
        
        /// Title Item
        public var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 18)
        public var titleTextColor: UIColor = UIColor(red:51/255, green:51/255,blue:51/255, alpha: 1.0)
        public var titleItemBackgroundColor: UIColor = .clear
        
        /// Message Item
        public var messageFont = UIFont.systemFont(ofSize: 15)
        public var messageTextColor = UIColor(red:51/255, green:51/255, blue:51/255, alpha: 1.0)
        public var messageItemBackgroundColor: UIColor = .clear
    }
	
    public init(contentViewWidth: CGFloat, margin: CGFloat) {
		self.contentViewWidth = contentViewWidth
		self.margin = margin
		backgroundView.backgroundColor = .white
	}
	
	public var itemHeight: CGFloat = 0
	
	public var isLastBottomMargin: Bool = false
	
	public var margin: CGFloat = 0
	
	public func markItemView() -> UIView? {
		return itemView
	}
	
	public func markItemControl() -> [UIControl]? {
		return controls
	}
	
	var contentViewWidth: CGFloat = 0
	
	public var controls: [UIControl] = []
	
	public var itemView: UIView?
	
	public var backgroundView = UIView()
	
	public var labelElement = UILabel()
	
	/// 按钮样式
	public enum ButtonStyle {
		/// 填充 和 边框
		case fill, indie
	}
	
	/// TitleIcon
	public enum ICoN {
		case custom(name: String)
		
		public var image: UIImage? {
			switch self {
			case .custom(let str):
				return UIImage(named: str)
			}
		}
	}
}

extension BrickItem {
	
	public func markTitleIconItem(icon: ICoN, width: CGFloat, backgroundColor: UIColor = .white) -> UIView? {
		guard let image = icon.image, width > 0 else {
			return nil
		}
		
		backgroundView.backgroundColor = backgroundColor
		
		let iconImageView = UIImageView()
		iconImageView.image = image
		
		backgroundView.addSubview(iconImageView)
		iconImageView.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.top.equalToSuperview().offset(margin)
			make.width.height.equalTo(width)
		}
		
		let height = margin + width + margin
		
		itemHeight += height
		isLastBottomMargin = true
		
		return backgroundView
	}
	
	public func markTitleItem(title: String, infoicon: String?) -> UIView? {
		
		if title.isEmpty, infoicon == nil {
			return nil
		}
		
		labelElement.font = BrickItem.itemUI.titleFont
		labelElement.textColor = BrickItem.itemUI.titleTextColor
        backgroundView.backgroundColor = BrickItem.itemUI.titleItemBackgroundColor
		
		labelElement.text = title
		labelElement.numberOfLines = 0
		labelElement.textAlignment = .center
		backgroundView.addSubview(labelElement)
		
		let width = contentViewWidth - (margin * 2)
		let maxmumLableSize = CGSize(width: width, height: 9999)
		let expectSize = labelElement.sizeThatFits(maxmumLableSize)
		
		let height = expectSize.height
		
		let titleLabelOffsetX: CGFloat = infoicon == nil ? 0 : labelElement.bounds.size.height / 2
		
		labelElement.snp.makeConstraints({ (maker) in
			maker.centerX.equalToSuperview().offset(titleLabelOffsetX)
			maker.top.equalToSuperview().inset(margin)
			maker.width.equalTo(expectSize.width)
			maker.height.equalTo(height)
		})
		
		if let infoicon = infoicon, !title.isEmpty {
			let image = UIImage(named: infoicon)
			let infoImageView = UIImageView(image: image)
			let infowidth = height
			backgroundView.addSubview(infoImageView)
			infoImageView.snp.makeConstraints({ (maker) in
				maker.width.height.equalTo(infowidth)
				maker.right.equalTo(labelElement.snp.left).offset(-8)
				maker.centerY.equalTo(labelElement.snp.centerY)
			})
		}
		
		itemHeight += margin + height + margin
		isLastBottomMargin = true
		return backgroundView
	}
	
	public func markMessageItem(message:String? = nil, attributed: NSMutableAttributedString? = nil, alignment: NSTextAlignment = .center) -> UIView? {
		
		let attributedString: NSMutableAttributedString
		let range: NSRange
		
		if let messageAttributed = attributed {
			attributedString = messageAttributed
			range = NSMakeRange(0, attributedString.length)
		} else if let message = message {
			attributedString = NSMutableAttributedString(string: message)
			range = NSMakeRange(0, message.count)
		} else {
			return nil
		}
		
		labelElement = UILabel()
		labelElement.numberOfLines = 0
		labelElement.font = BrickItem.itemUI.messageFont
		labelElement.textColor = BrickItem.itemUI.messageTextColor
        backgroundView.backgroundColor = BrickItem.itemUI.messageItemBackgroundColor
		
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = 10
        attributedString.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range:range)
		
		labelElement.attributedText = attributedString
		labelElement.textAlignment = alignment
		
		let width = contentViewWidth - (margin * 2)
		let maxmumLableSize = CGSize(width: width, height: 9999)
		let expectSize = labelElement.sizeThatFits(maxmumLableSize)
		
		let height = expectSize.height
		
		backgroundView.addSubview(labelElement)
		
		labelElement.snp.makeConstraints { (maker) in
			maker.top.equalToSuperview().inset(margin)
			maker.left.right.equalToSuperview().inset(margin)
			maker.height.equalTo(height)
		}
		
		itemHeight += margin + height + margin
		isLastBottomMargin = true
		
		return backgroundView
	}
	
	public func markButtonItem(titleArray: [String], style: ButtonStyle, height buttonHeight: CGFloat = 45) -> UIView? {
		
		guard titleArray.count > 1 else {
			return nil
		}
		
		var buttonMargin: CGFloat
		
		switch style {
		case .indie:
			buttonMargin = 15
		case .fill:
			buttonMargin = 7.4
		}
		
		for index in 0 ..< titleArray.count {
			let button = UIButton(type: .custom)
			button.backgroundColor = BrickItem.itemUI.buttonBackgroundColor
			
			switch style {
			case .indie:
				button.layer.cornerRadius = 3
				
			case .fill:
				break
			}
			
			button.setTitleColor(BrickItem.itemUI.buttonFontColor, for: .normal)
			button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
			let title: String = titleArray[index]
			button.setTitle(title, for: .normal)
			
			controls.append(button)
			backgroundView.addSubview(button)
			
			var buttonWidth: CGFloat
			var buttonTop: CGFloat
			var buttonLeft: CGFloat
			if titleArray.count == 2 {
				let halfWidth = contentViewWidth / 2
				buttonTop = 0
				
				switch style {
				case .indie:
					buttonWidth = min(halfWidth - (buttonMargin * 2), 120)
					let left = (halfWidth - buttonWidth) / 2
					buttonLeft = left + (CGFloat(index) * halfWidth)
					
				case .fill:
					buttonWidth = halfWidth
					buttonLeft = (CGFloat(index)) * buttonWidth
				}
				
				if index == 0 {
					button.backgroundColor = .white
					button.setTitleColor(BrickItem.itemUI.buttonBackgroundColor, for: .normal)
					
					switch style {
					case .indie:
						button.layer.borderWidth = 1
						button.layer.borderColor = BrickItem.itemUI.buttonCancelBorderColor.cgColor
						
					case .fill:
						let lineView = UIView()
						lineView.backgroundColor = BrickItem.itemUI.buttonCancelBorderColor
						button.addSubview(lineView)
						lineView.snp.makeConstraints({ (maker) in
							maker.top.equalToSuperview()
							maker.left.right.equalToSuperview()
							maker.height.equalTo(0.5)
						})
					}
				}
			} else {
				switch style {
				case .indie:
					let singleMargin = contentViewWidth * 0.1
					buttonWidth = contentViewWidth - (singleMargin * 2)
					buttonLeft = singleMargin
					buttonTop = 0 + (CGFloat(index) * buttonHeight) + (CGFloat(index) * buttonMargin)
					
				case .fill:
					buttonWidth = contentViewWidth
					buttonLeft = 0
					buttonTop = 0 + (CGFloat(index) * buttonHeight) + (CGFloat(index) * buttonMargin)
				}
			}
			
			button.snp.makeConstraints({ (make) in
				make.top.equalToSuperview().offset(buttonTop)
				make.left.equalToSuperview().offset(buttonLeft)
				make.width.equalTo(buttonWidth)
				make.height.equalTo(buttonHeight)
			})
		}
		
		var bottomInset: CGFloat
		
		switch style {
		case .indie:
			bottomInset = margin
		case .fill:
			bottomInset = 0.0
		}
		
		if titleArray.count == 2 {
			itemHeight += buttonHeight + bottomInset
		} else {
			let count = CGFloat(titleArray.count)
			itemHeight += (count * buttonHeight) + ((count - 1) * buttonMargin) + bottomInset
		}
		isLastBottomMargin = false
		
		return backgroundView
	}
	
}


