//
//  ViewController.swift
//  ROTimer
//
//  Created by Miles on 2020/12/2.
//

import UIKit
import ESTabBarController_swift
import GoogleMobileAds

class TabbarVC: ESTabBarController {

    var bannerView: GADBannerView!
    var timerVC: TimerVC!
    var moreVC: MoreVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        addBannerViewToView()
        setTabBar()
    }

    func addBannerViewToView() {
        
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        
        #if DEBUG
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        #else
        bannerView.adUnitID = "ca-app-pub-1223027370530841/2157805612"
        #endif

        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bannerView)
        bannerView.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: 0).isActive = true
        bannerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        bannerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        view.bringSubviewToFront(tabBar)
    }
    
    func setTabBar() {
        
        timerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idTimerVC") as? TimerVC
        let timerNC = UINavigationController(rootViewController: timerVC)
        
        moreVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idMoreVC") as? MoreVC
        let moreNC = UINavigationController(rootViewController: moreVC)
        
        viewControllers = [timerNC, moreNC]
        
        setTabBarItem()
    }
    
    func setTabBarItem() {
        
        let basicContentView1 = ExampleIrregularityBasicContentView()
        let basicContentView2 = ExampleIrregularityBasicContentView()
        if #available(iOS 13.0, *) {
            let currentMode = UITraitCollection.current.userInterfaceStyle
            if currentMode == .dark {
                
                basicContentView1.textColor = .white
                basicContentView1.highlightTextColor = .white
                basicContentView1.iconColor = .white
                basicContentView1.highlightIconColor = .white
                basicContentView2.textColor = .white
                basicContentView2.highlightTextColor = .white
                basicContentView2.iconColor = .white
                basicContentView2.highlightIconColor = .white
            } else {
                
                basicContentView1.textColor = .black
                basicContentView1.highlightTextColor = .black
                basicContentView1.iconColor = .black
                basicContentView1.highlightIconColor = .black
                basicContentView2.textColor = .black
                basicContentView2.highlightTextColor = .black
                basicContentView2.iconColor = .black
                basicContentView2.highlightIconColor = .black
            }
        }
        
        timerVC.tabBarItem = ESTabBarItem(basicContentView1, title: "計時器", image: UIImage(named: "timer"), selectedImage: UIImage(named: "timer"))
        moreVC.tabBarItem = ESTabBarItem(basicContentView2, title: "更多", image: UIImage(named: "more"), selectedImage: UIImage(named: "more"))
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setTabBarItem()
    }
}

extension TabbarVC: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("adViewDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
    }
}
