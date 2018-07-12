//
//  ViewController.swift
//  TestApp
//
//  Created by ZeroJianMBP on 2017/12/19.
//  Copyright © 2017年 ZeroJian. All rights reserved.
//

import UIKit
import BrickBatView

class PopViewViewController: UIViewController {
	
	var isShowTitle: Bool = false
	var isShowTitleIcon: Bool = false
	var isShowTitleInfo: Bool = false
	
	var isShowMessage: Bool = false
	var isShowButton: Bool = false

	var buttonStyle: Int = 0
	var buttonCount: Int = 2
	
	var positionDirection: BrickBatView.Direction = .center(.center)
	
	var showDirection: BrickBatView.AnimationDirection = .center
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	var showTitleNumber: Int = 1
	var showMessageNumber: Int = 2
	var showButtonNumber: Int = 3
	
	var popViewContent: [Int] = []
	
	@IBAction func switchChanged(sender: UISwitch) {
		
		let isShow = sender.isOn
		switch sender.tag {
		case 100:
			if isShow{
				popViewContent.append(showTitleNumber)
			}
		case 101:
			isShowTitleIcon = isShow
		case 102:
			isShowTitleInfo = isShow
		case 200:
			if isShow {
				popViewContent.append(showMessageNumber)
			}

		case 300:
			if isShow {
				popViewContent.append(showButtonNumber)
			}
		default:
			break
		}
	}
	
	@IBAction func SegmentedChanged(sender: UISegmentedControl) {
		
		let index = sender.selectedSegmentIndex
		
		switch sender.tag {
		case 301:
			buttonStyle = index
		case 302:
			buttonCount = index + 1
		case 303:
			switch index {
			case 0:
				showDirection = .center
			case 1:
				showDirection = .bottom
			case 2:
				showDirection = .top
			default: break
			}
			
		case 304:
			switch index {
			case 0:
				positionDirection = .center(showDirection)
			case 1:
				positionDirection = .bottom
			case 2:
				positionDirection = .top
			default: break
			}
			
		default:
			break
		}
		
	}
	
	@IBAction func showAction() {
		
		let brickView = BrickBatView(inView: self.view)
		brickView?.setup()
		
//		brickView?.addImageView(addAction: { (imageView, contentView) in
////			contentView.backgroundColor = .clear
//			imageView.image = UIImage(named: "icon_big")
//		}, ratio: 1.0, gesture: true)
		
//		brickView.
		
		for content in popViewContent {
			if content == showTitleNumber {
				
				let info = isShowTitleInfo ? "icon_info" : nil
				
				_ = brickView?
					.addTitleItem(title: "BrickBatView", infoicon: info)
				
				
				if isShowTitleIcon {
					_ = brickView?.addTitleIconItem(.done, width: 45)
				}
				
			}
			
			if content == showMessageNumber {
				brickView?.addMessageItem(text: "This is BrickBatView message, This is BrickView message")
			}
			
			if content == showButtonNumber {
				
				var titles: [String] = ["Cancel", "Done"]
				if buttonCount == 1 {
					titles = ["Done"]
				} else if buttonCount == 3 {
					titles = ["Done", "Other", "Cancel"]
				}
				
				let style: BrickItem.ButtonStyle = buttonStyle == 0 ? .fill : .indie
				
				isShowButton = true
				brickView?.addButtonItem(title: titles, style: style)
			}
		}
	
		
//		if popViewContent.isEmpty {
//			brickView?.addImageView(addAction: { (imageView, contentView) in
//				contentView.backgroundColor = .clear
//				imageView.image = UIImage(named: "icon_big")
//			}, ratio: 0.6, gesture: true)
//		}
		
//		brickView?.setupContentView(action: { (view) in
//			view.backgroundColor = .red
//		})
		
//		brickView?.addMaskViewBottonCloseButton(imageName: "icon_info")
		
		brickView?
//			.addExtensionTextField()
			.position(positionDirection, edgeInster: 10)
		
		brickView?
			.handle(action: { (i) in
				print("sender action index: \(i)")
			}, tapHidden: true)
		
		brickView?
			.identifier("12345")
			.show(tapMaskHidden: !isShowButton)
		
		let isShow = BrickBatView.isShowing(to: view, identifier: "12345")
		
		popViewContent.removeAll()
	}
}

extension BrickItem.ICoN {
	
	static let done = BrickItem.ICoN.custom(name: "icon_icon")
}

extension BrickBatView {

	func addExtensionTextField() -> Self {

		let textField = UITextField()
		textField.bounds.size.height = 50
		textField.placeholder = "BrickBatView addTextField Extension"
		textField.borderStyle = .roundedRect

		return addContentView(textField)
	}


}

