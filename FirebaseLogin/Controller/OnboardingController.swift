//
//  OnboardingController.swift
//  FirebaseLogin
//
//  Created by Tee Becker on 11/23/20.
//

import Foundation
import paper_onboarding

/// 1) create a protocol that takes in an onboarding controller
protocol OnboardingControllerDelegate: class {
    func controllerWantsToDismiss(_ controller: OnboardingController)
}

class OnboardingController: UIViewController{
    
    /// 2) create a delegate of this onboardingController
    /// prevent retain cycles
    weak var delegate: OnboardingControllerDelegate?
    
    // MARK: - Properties
    private var onboardingItems = [OnboardingItemInfo]()
    private var onboardingView = PaperOnboarding()
    
    private var getStartedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Started", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(onboardingGetStarted), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureOnboardingDatasource()
        configureButton()
    }
    
    
    // MARK: - Selector
    @objc func onboardingGetStarted(){
        /// 3) call delegate
        delegate?.controllerWantsToDismiss(self)
//        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Helper
    func animateGetStartedButton(_ shouldShow: Bool){
        let alpha: CGFloat = shouldShow ? 1 : 0
        
        UIView.animate(withDuration: 0.5) {
            self.getStartedButton.alpha = alpha
        }
    }
    
    
    // MARK: - Privates
    private func configureUI(){
        view.addSubview(onboardingView)
        onboardingView.fillSuperview() /// From the extension provided by instructor
        onboardingView.delegate = self
    }
    
    private func configureButton(){
        view.addSubview(getStartedButton)
        getStartedButton.centerX(inView: view)
        getStartedButton.anchor(
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            paddingBottom: 120
        )
        getStartedButton.alpha = 0
    }
    
    private func configureOnboardingDatasource(){
        /// create items
        let itemOne = OnboardingItemInfo(
            informationImage: #imageLiteral(resourceName: "baseline_insert_chart_white_48pt").withRenderingMode(.alwaysOriginal),
            title: messagesBody.msgMetrics,
            description: messagesBody.metricsDetail,
            pageIcon: UIImage(), /// blank ,
            color: #colorLiteral(red: 0.2745098039, green: 0.5058823529, blue: 0.537254902, alpha: 1),
            titleColor: .white,
            descriptionColor: .white,
            titleFont: UIFont.boldSystemFont(ofSize: 24),
            descriptionFont: UIFont.systemFont(ofSize: 16))
        
        let itemTwo = OnboardingItemInfo(
            informationImage: #imageLiteral(resourceName: "baseline_dashboard_white_48pt").withRenderingMode(.alwaysOriginal),
            title: messagesBody.msgDashboard,
            description: messagesBody.dashboardDetail,
            pageIcon: UIImage(), /// blank ,
            color: #colorLiteral(red: 0.4666666667, green: 0.6745098039, blue: 0.6352941176, alpha: 1),
            titleColor: .white,
            descriptionColor: .white,
            titleFont: UIFont.boldSystemFont(ofSize: 24),
            descriptionFont: UIFont.systemFont(ofSize: 16))
        
        let itemThree = OnboardingItemInfo(
            informationImage: #imageLiteral(resourceName: "baseline_notifications_active_white_48pt").withRenderingMode(.alwaysOriginal),
            title: messagesBody.msgNotification,
            description: messagesBody.notificationDetail,
            pageIcon: UIImage(), /// blank ,
            color: #colorLiteral(red: 0.6156862745, green: 0.7450980392, blue: 0.7333333333, alpha: 1),
            titleColor: .white,
            descriptionColor: .white,
            titleFont: UIFont.boldSystemFont(ofSize: 24),
            descriptionFont: UIFont.systemFont(ofSize: 16))
        
        
        /// Saved time , for actual project need to obviously have different onboarding pages.
        onboardingItems.append(itemOne)
        onboardingItems.append(itemTwo)
        onboardingItems.append(itemThree)
        
        /// Needs to be after we append the data, otherwise it will say index out of range as the array will be empty
        onboardingView.dataSource = self
        onboardingView.reloadInputViews()
    }
}


// MARK: extension
extension OnboardingController: PaperOnboardingDataSource{
    /// similar to tableviews.
    func onboardingItemsCount() -> Int {
        return onboardingItems.count
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return onboardingItems[index]
    }
}

/// This will enforce the "get started" button to ONLY show up in the last page, instead of all the pages
extension OnboardingController: PaperOnboardingDelegate{
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        print("Index is \(index)")
        /// using viewmodels instead.
        let viewmodel = OnboardingViewModel(itemcount: onboardingItems.count)
        let shouldshow = viewmodel.shouldShowGetStartedButton(for: index)
        animateGetStartedButton(shouldshow)
    }
    
}
