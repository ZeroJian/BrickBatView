//
//  BrickBatView.swift
//  BMKP
//
//  Created by ZeroJianMBP on 2017/12/13.
//  Copyright © 2017年 bmkp. All rights reserved.
//

import Foundation
import SnapKit


public typealias BrickAction = ((_ buttonindex: Int) -> Void)

open class BrickBatView: UIView {

	public init?(inView view: UIView? = nil) {
		super.init(frame: .zero)
		
		let rootView = view ?? UIApplication.shared.keyWindow
		guard let view = rootView else {
			return nil
		}
		self.rootView = view
		self.setupContentView()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public let contentView = UIView()
	private var rootView: UIView!
	
	private var contentViewHeight: CGFloat = 0.0
	public var contentViewWidth: CGFloat = 0.0
	
	public var maskViewBackgroundColor = UIColor.black.withAlphaComponent(0.7)
	
	// 组件间隔距离
	public var margin: CGFloat = 18
	// 上一个视图组件底部是否预留了 margin 距离, 上一个组件底部和当前组件顶部只保留一个 margin
	public var isLastBottomMargin: Bool = false
	
	// 添加的最后一个 tag index
	private var lastActionTag: Int = 0
	
	// PopView 显示的位置
	public enum Direction {
		case center(AnimationDirection)
		case bottom
		case top
		
		// 中间位置和中间显示动画
		var isCenter: Bool {
			switch self {
			case .center(let animation):
				return animation == .center
			default:
				return false
			}
		}
	}
	
	// PopView 显示时动画方向
	public enum AnimationDirection {
		case center, top, bottom
	}
	
	//MARK: - Event
	@objc private func popHidden(sender: Any) {
		var index: Int = 0
		if let button = sender as? UIButton {
			index = button.tag - 100
		}
		
		if let gestrue = sender as? UIGestureRecognizer, let tag = gestrue.view?.tag {
			index = tag
		}
		
		actionHandler?(index)
		
		if tapSenderHidden {
			popHiddenExit()
		}
	}
	
	@objc private func popHiddenExit() {
		actionHandler = nil
		
		var animationAction: () -> Void = {
			self.layoutIfNeeded()
		}
		
		switch positionDirection {
		case .center(let animation):
			switch animation {
			case .center:
				animationAction = {
					self.contentView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
				}
			case .top:
				layoutContentView(isOrigin: false)
			case .bottom:
				layoutContentView(isOrigin: false)
			}
			
		case .top:
			layoutContentView(isOrigin: false)

		case .bottom:
			layoutContentView(isOrigin: false)
		}
		
		UIView.animate(withDuration: 0.2, animations: {
			self.contentView.alpha = 0.2
			self.alpha = 0
			animationAction()
		}) { (finished) in
			self.removeSubViews()
			self.popHideAction?()
		}
	}
	
	/// ------------------------  fileprivate --------------------------
	///
	/// 点击背景是否关闭视图 (默认点击不关闭)
	fileprivate var	tapMaskViewHidden = false {
		didSet {
			if tapMaskViewHidden {
				maskViewGesture = UITapGestureRecognizer()
				maskViewGesture?.addTarget(self, action: #selector(popHiddenExit))
				maskViewGesture.flatMap{ self.addGestureRecognizer($0)}
			}
		}
	}
	
	// 点击按钮是否自动关闭视图 (默认点击关闭)
	fileprivate var tapSenderHidden = true
	// 当前 PopView 的唯一标识符, 可通过设置确定是否是要获取的 PopView
	fileprivate var identifier: String?
	// 视图位置
	fileprivate var positionDirection: Direction = .center(.center)
	// 视图位置为 bottom 或 top 时, 离边缘的距离
	fileprivate var edgeInster: CGFloat = 20
	// 按钮高度
	// 弹出动画结束之后
	fileprivate var showCompletedAction: ((Bool) -> Void)?
	/// 视图隐藏时调用
	fileprivate var popHideAction: (() -> Void)?
	// 背景视图点击手势
	fileprivate var maskViewGesture: UITapGestureRecognizer?
	// 点击事件 closer
	fileprivate var actionHandler: BrickAction?
	
	deinit {
//		print("******* PopView deinit *******")
	}
	
}


//MARK: - 链式调用
extension BrickBatView {
	
	/// 链式调用, 配置默认属性(可继承)
	///
	/// - Parameters:
	///   - margin: 各组件默认间隔
	///   - backgroundColor: 容器视图背景颜色
	///   - contentViewWidth: 容器视图宽度
	///   - maskViewColor: 遮罩颜色
	/// - Returns:  self
	open func setup(margin: CGFloat = 18,
					backgroundColor: UIColor = .white,
					contentViewWidth: CGFloat? = nil,
					maskViewColor: UIColor = UIColor.black.withAlphaComponent(0.7)) -> Self {
		self.margin = margin
		contentViewWidth.flatMap({ self.contentViewWidth = $0 })
		contentView.backgroundColor = backgroundColor
		maskViewBackgroundColor = maskViewColor
		setupMaskView()
		return self
	}
	
	/// 显示 BrickView, 配置好组件最后调用
	///
	/// - Parameters:
	///   - animateDirection: 显示的动画方向
	///   - tapMaskHidden: 点击背景是否隐藏 PopView
	/// - Returns: self
	@discardableResult
	public func show(tapMaskHidden: Bool = false) -> Self {
		setupMaskView()
		self.tapMaskViewHidden = tapMaskHidden
		showAnimate()
		return self
	}
	
	/// 点击事件,回调点击的 Index
	/// - tapHidden: 点击事件是否自动隐藏 PopView
	@discardableResult
	public func handle(action: @escaping BrickAction, tapHidden: Bool = true) -> Self {
		self.tapSenderHidden = tapHidden
		self.actionHandler = action
		return self
	}
	
	
	/// 视图生命周期
	///
	/// - Parameters:
	///   - showFinishedAction: 显示动画完成后调用
	///   - hiddenAction: 已经隐藏后调用
	/// - Returns: self
	@discardableResult
	public func lifeCyle(showFinishedAction: ((Bool) -> Void)?, hiddenAction: (() -> Void)?) -> Self {
		self.showCompletedAction = showFinishedAction
		self.popHideAction = hiddenAction
		return self
	}
	
	
	/// 隐藏视图
	@discardableResult
	public func hidden() -> Self {
		popHiddenExit()
		return self
	}
	
	/// 配置内部 contentView
	///
	/// - Parameter action: contentView closure
	/// - Returns: self
	public func setupContentView(action: (UIView) -> Void) -> Self {
		action(contentView)
		return self
	}
	
	
	/// 配置唯一标示符
	@discardableResult
	public func identifier(_ id: String) -> Self {
		identifier = id
		return self
	}
	
	/// 调整视图目前高度, 可用来调整组件之间的间距
	public func offset(_ offset: CGFloat) -> Self {
		contentViewHeight += offset
		return self
	}
	
	/// 调整视图目前高度(margin 个单位), 可用来调整组件之间的间距
	public func offsetMargin(count: Int = 1) -> Self {
		let set = margin * CGFloat(count)
		_ = offset(set)
		return self
	}
	
	// 视图显示的位置, 需要在 show() 方法调用前调用
	// - position: 视图显示的位置, 如果选择 center 可设置动画方向 (从顶部或底部显示到中间)
	// - edgeInster: 如果视图位置为 bottom 或 top, 离边缘的距离, 默认20
	public func position(_ position: Direction, edgeInster: CGFloat = 20) -> Self {
		positionDirection = position
		self.edgeInster = edgeInster
		return self
	}

	/// 添加自定义 view
	///
	/// - Parameters:
	///   - view: 自定义 view
	///   - controls: 事件响应对象(例如:可把自定义 view 里面增加的 button 传入进来, 由 BrickView,响应点击事件)
	/// - Returns: self
	public func addContentView(_ view: UIView, controls: [UIControl]? = nil) -> Self {
		setupMaskView()
		
		let viewWidth = view.bounds.width
		let viewHeight = view.bounds.height
		
		if viewWidth > contentViewWidth {
			contentViewWidth = viewWidth
		}
		
		self.contentView.addSubview(view)
		
		controls?.forEach {
			$0.addTarget(self, action: #selector(popHidden), for: .touchUpInside)
			$0.tag = lastActionTag + 100
			lastActionTag += 1
		}
		
		view.snp.makeConstraints { (maker) in
			maker.top.equalToSuperview().inset(contentViewHeight)
			maker.left.right.equalToSuperview()
			maker.height.equalTo(viewHeight)
		}
		
		contentViewHeight += viewHeight
		isLastBottomMargin = false
		return self
	}
	
	
	/// 添加 BrickBat 协议类型 Item
	///
	/// - Parameter item: 遵循 BrickBat 协议 Item
	/// - Returns: self
	public func addBrickItem<B: BrickBat>(_ item: B) -> Self {
		setupMaskView()
		
		guard let view = item.markItemView() else {
			return self
		}
		
		let viewHeight = item.itemHeight
		
		contentView.addSubview(view)
		
		item.markItemControl()?.forEach {
			$0.addTarget(self, action: #selector(popHidden), for: .touchUpInside)
			$0.tag = lastActionTag + 100
			lastActionTag += 1
		}
		
		view.snp.makeConstraints { (maker) in
			maker.top.equalToSuperview().inset(contentViewHeight)
			maker.left.right.equalToSuperview()
			maker.height.equalTo(viewHeight)
		}
		contentViewHeight += item.itemHeight
		isLastBottomMargin = item.isLastBottomMargin
		return self
	}
	
	
	/// 添加手势
	///
	/// - Parameter views: 响应手势的 views
	/// - Returns: self
	public func addGesture(_ views: [UIView]) -> Self {
		views.forEach{
			let gesture = UITapGestureRecognizer(target: self, action: #selector(popHidden))
			$0.isUserInteractionEnabled = true
			$0.addGestureRecognizer(gesture)
			$0.tag = lastActionTag + 100
			lastActionTag += 1
		}
		return self
	}
	
	
	/// 添加本地或网络图片
	///
	/// - Parameters:
	///   - addAction: ImageView 添加后调用 (创建的 UIimageView, contentView), 可用来处理网络加载或设置本地imageName
	///   - gesture: 图片是否有点击手势(可通过 handle 方法处理)
	///   - ratio: 图片高度相对宽度比例
	/// - Returns: self
	public func addImageView(addAction: ((UIImageView, UIView) -> Void)?,
							 ratio: CGFloat = 1.33,
							 gesture: Bool = false) -> Self {
		setupMaskView()
		let height = contentViewWidth * ratio
		let imageView = setupImageView(height: height)
		
		if gesture {
			_ = addGesture([imageView])
		}
		
		addAction?(imageView, contentView)
		return self
	}
	
	/// 添加到背景视图的自定义视图(只添加, 布局可在外部完成)
	///
	/// - Parameter view: 自定义视图
	/// - Returns: self
	public func addMaskViewContent(_ view: UIView) -> Self {
		setupMaskView()
		addSubview(view)
		return self
	}
	
	/// 添加到背景视图的关闭按钮(点击后只处理视图隐藏,点击事件外部没有暴露)
	///
	/// - Parameter imageName:  按钮图片
	/// - Returns: self
	public func addMaskViewBottonCloseButton(imageName: String) -> Self {
		setupMaskView()
		setupBottomCloseButton(imageName: imageName)
		return self
	}
}

extension BrickBatView {
	/// 是否正在某个 view 显示
	///
	/// - Parameter view: 正在显示的 view, PopView 的唯一标示符
	/// - Returns:  是否正在显示
	public static func isShowing(to view: UIView?, identifier: String?) -> BrickBatView? {
		
		guard let toView = view ?? UIApplication.shared.keyWindow else { return nil }
		
		for subView in toView.subviews.reversed() {
			if let PopView = subView as? BrickBatView {
				
				if let id = identifier {
					if PopView.identifier == id {
						return PopView
					}
					
				} else {
					return PopView
				}
			}
		}
		return nil
	}
	
}

//MARK: Setup UI
extension BrickBatView {
	
	fileprivate func setupImageView(height: CGFloat) -> UIImageView {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		
		contentView.addSubview(imageView)
		imageView.snp.makeConstraints { (maker) in
			maker.top.equalToSuperview().inset(contentViewHeight)
			maker.height.equalTo(height)
			maker.left.right.equalToSuperview()
		}
		contentViewHeight += height
		isLastBottomMargin = false
		return imageView
	}
	
	fileprivate func setupBottomCloseButton(imageName: String) {
		let button = UIButton(type: .custom)
		let image = UIImage(named: imageName)
		button.setImage(image, for: .normal)
		button.tintColor = .white
		button.addTarget(self, action: #selector(popHiddenExit), for: .touchUpInside)
		addSubview(button)
		
		button.snp.makeConstraints { (maker) in
			maker.width.height.equalTo(50)
			maker.centerX.equalToSuperview()
			maker.top.equalTo(contentView.snp.bottom).offset(30)
		}
	}
	
	
	fileprivate func setupContentView() {
		contentView.layer.cornerRadius = 4
		contentView.layer.masksToBounds = true
		
		contentViewWidth = UIScreen.main.bounds.size.width * 0.8
		contentView.backgroundColor = UIColor.white
		
		backgroundColor = UIColor.black.withAlphaComponent(0.0)
	}
	
	fileprivate func setupMaskView() {

		if contentView.superview != nil { return }
		
		rootView.addSubview(self)
		self.addSubview(contentView)
		
		self.snp.makeConstraints { (maker) in
			maker.center.equalToSuperview()
			maker.width.equalTo(UIScreen.main.bounds.size.width)
			maker.height.equalTo(UIScreen.main.bounds.size.height)
		}
	}
	
	fileprivate func removeSubViews() {
		removeSubviews(with: self)
		removeFromSuperview()
		removeSubviews(with: contentView)
		contentView.removeFromSuperview()
	}
	
	/// 视图显示动画
	fileprivate func showAnimate() {
		
		var animationSpring: Bool = false
		
		switch positionDirection {
		case .center(let animationDirection):
			switch animationDirection {
			case .center:
				layoutContentView(isOrigin: true)
				contentView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
				
			case .top:
				layoutContentView(isOrigin: false)
				layoutIfNeeded()
				layoutContentView(isOrigin: true)
				
			case .bottom:
				layoutContentView(isOrigin: false)
				layoutIfNeeded()
				layoutContentView(isOrigin: true)
			}
			animationSpring = true
			
		case .top:
			layoutContentView(isOrigin: false)
			self.layoutIfNeeded()
			layoutContentView(isOrigin: true)
		
		case .bottom:
			layoutContentView(isOrigin: false)
			self.layoutIfNeeded()
			layoutContentView(isOrigin: true)
		}
		
		
		if animationSpring {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: UIView.AnimationOptions(), animations: { () -> Void in
				self.backgroundColor = self.maskViewBackgroundColor
				if self.positionDirection.isCenter {
					self.contentView.transform = CGAffineTransform.identity
				} else {
					self.layoutIfNeeded()
				}
			}) { [weak self] finished in
				self?.showCompletedAction?(finished)
			}
		} else {
			UIView.animate(withDuration: 0.4, animations: {
				self.backgroundColor = self.maskViewBackgroundColor
				self.layoutIfNeeded()
			}) {  [weak self] finished in
				self?.showCompletedAction?(finished)
			}
		}
	}
	
	fileprivate func layoutContentView(isOrigin: Bool) {
		
		contentView.snp.remakeConstraints { (maker) in
			maker.height.equalTo(contentViewHeight)
			maker.centerX.equalToSuperview()
			maker.width.equalTo(contentViewWidth)
			
			switch positionDirection {
			case .center(let animation):
				switch animation {
				case .center:
					maker.centerY.equalToSuperview()
					
				case .top:
					if isOrigin {
						maker.centerY.equalToSuperview()
					} else {
						maker.top.equalToSuperview().offset(-contentViewHeight)
					}
					
				case .bottom:
					if isOrigin {
						maker.centerY.equalToSuperview()
					} else {
						maker.bottom.equalToSuperview().offset(contentViewHeight)
					}
				}
				
			case .top:
				if isOrigin {
					maker.top.equalToSuperview().inset(edgeInster)
				} else {
					maker.top.equalToSuperview().offset(-contentViewHeight)
				}
				
			case .bottom:
				if isOrigin {
					maker.bottom.equalToSuperview().inset(edgeInster)
				} else {
					maker.bottom.equalToSuperview().offset(contentViewHeight)
				}
			}
		}
	}
}

extension BrickBatView {
	
	fileprivate func removeSubviews(with superview: UIView) {
		for subview in superview.subviews {
			subview.removeFromSuperview()
		}
	}
}

