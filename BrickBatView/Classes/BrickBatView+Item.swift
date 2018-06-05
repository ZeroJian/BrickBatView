//
//  BrickBatView+Item.swift
//  BrickView
//
//  Created by ZeroJianMBP on 2018/6/5.
//

import Foundation

extension BrickBatView {
	
	/// addTitleItem
	///
	/// - Parameters:
	///   - title: title
	///   - infoicon: title infoicon
	/// - Returns: self
	public func addTitleItem(title: String,
							 infoicon: String?) -> Self {
		
		let titleBrick = BrickItem.init(contentViewWidth: contentViewWidth, margin: margin)
		
		titleBrick.itemView = titleBrick.markTitleItem(title: title, infoicon: infoicon)
		
		if isLastBottomMargin, titleBrick.itemView != nil {
			_ = offsetMargin(count: -1)
		}
		
		return addBrickItem(titleBrick)
	}
	
	
	/// add TitleIconItem
	///
	/// - Parameters:
	///   - icon: icon
	///   - width: icon widht
	///   - backgroundColor: backgroundColor
	/// - Returns: self
	public func addTitleIconItem(_ icon: BrickItem.ICoN,
								 width: CGFloat,
								 backgroundColor: UIColor = .white) -> Self {
		
		let titleIconBrick = BrickItem.init(contentViewWidth: contentViewWidth, margin: margin)
		
		titleIconBrick.itemView = titleIconBrick.markTitleIconItem(icon: icon, width: width, backgroundColor: backgroundColor)
		
		if isLastBottomMargin, titleIconBrick.itemView != nil {
			_ = offsetMargin(count: -1)
		}
		
		return addBrickItem(titleIconBrick)
	}
	
	
	/// add MessageItem
	///
	/// - Parameters:
	///   - text: message
	///   - alignment: label alignment
	/// - Returns: self
	public func addMessageItem(text: String,
							   alignment: NSTextAlignment = .center) -> Self {
		
		let messageBrick = BrickItem.init(contentViewWidth: contentViewWidth, margin: margin)
		
		messageBrick.itemView = messageBrick.markMessageItem(message: text, attributed: nil, alignment: alignment)
		
		if isLastBottomMargin, messageBrick.itemView != nil {
			_ = offsetMargin(count: -1)
		}
		
		return addBrickItem(messageBrick)
	}
	
	
	/// add MessageItem
	///
	/// - Parameters:
	///   - attributed: attributedString message
	///   - alignment: label aligment
	/// - Returns: self
	public func addMessageItem(attributed: NSMutableAttributedString,
							   alignment: NSTextAlignment = .center) -> Self {
		
		let messageBrick = BrickItem.init(contentViewWidth: contentViewWidth, margin: margin)
		
		messageBrick.itemView = messageBrick.markMessageItem(message: nil, attributed: attributed, alignment: alignment)
		
		if isLastBottomMargin, messageBrick.itemView != nil {
			_ = offsetMargin(count: -1)
		}
		
		return addBrickItem(messageBrick)
	}
	
	
	/// add ButtonItem
	///
	/// - Parameters:
	///   - title: title
	///   - style: button style
	///   - height: button height
	/// - Returns: self
	public func addButtonItem(title: [String],
							  style: BrickItem.ButtonStyle,
							  height: CGFloat = 45) -> Self {
		
		let buttonBrick = BrickItem.init(contentViewWidth: contentViewWidth, margin: margin)
		
		buttonBrick.itemView = buttonBrick.markButtonItem(titleArray: title, style: style, height: height)
		
		return addBrickItem(buttonBrick)
		
	}
}
