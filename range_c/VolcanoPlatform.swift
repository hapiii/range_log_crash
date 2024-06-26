//
//  VolcanoPlatform.swift
//  range_c
//
//  Created by wq on 2024/6/26.
//

import Foundation
import RangersAppLog

enum RangeProfileKey: String {
    /// 推送是否开启
    case is_push_on
    /// 用户code 尾号
    case user_code_tail
}

extension String {
    struct Volcano {
#if DEBUG
        static let appID = "10000001"
        static let appName = "Sereal"
#else
        static let appID = "10000005"
        static let appName = "Sereal_online"
#endif
        static let channel = "App Store"
        static let host = "https://collect.9em.cn"
    }
}

class VolcanoPlatform {
    
    class func start(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        
        let config = BDAutoTrackConfig(appID:.Volcano.appID, launchOptions: launchOptions)
        config.channel = .Volcano.channel
        config.appName = .Volcano.appName
        config.serviceVendor = .private
        
        BDAutoTrack.setRequestHostBlock {(vendor: BDAutoTrackServiceVendor, requestURLType:BDAutoTrackRequestURLType) -> String? in
            return .Volcano.host
        }
        BDAutoTrack.setCustomHeaderBlock {
            return [:]
        }
        config.autoTrackEnabled = true
        config.autoTrackEventType = .all
        config.logNeedEncrypt = true
        config.abEnable = true
        config.enableH5Bridge = false
        config.h5AutoTrackEnabled = false
        /// 曝光
        /*
         config.exposureEnabled = true
         config.exposureConfig.areaRatio(0.5)
         config.exposureConfig.enableVisualDiagnosis(true)
         
         let opt = BDViewExposureData()
         opt.eventName = "view_did_exposure"
         opt.properties = [:]
         opt.config = BDViewExposureConfig.default().areaRatio(0.5)
         BDAutoTrack.shared().observeViewExposure(self, with: opt)
         //BDAutoTrack.shared().disposeViewExposure(self)
         */
        
#if DEBUG
        config.devToolsEnabled = true
        config.showDebugLog = true
        
        
#else
        config.devToolsEnabled = false
        config.showDebugLog = false
#endif
        BDAutoTrack.sharedTrack(with: config)
//        // 如果需要设置当前登陆态 since 6.13.0+
//        UserStatusChangeBus.EventBus.register(type: .login, obj: self) { _ in
//            BDAutoTrack.clearUserUniqueID()
//            BDAutoTrack.setCurrentUserUniqueID(AppManager.default.user?.memberId)
//            profileUserCodeTail()
//            
//        }
//        BDAutoTrack.setCurrentUserUniqueID(AppManager.default.user?.memberId)
//        profileUserCodeTail()
        // 授权后
        BDAutoTrack.shared().start()
    }
    
    /// 设置用户属性
    class func profile(key: RangeProfileKey, value: Any) {
        let profileDict: [AnyHashable: Any] = [
            key.rawValue : value
        ]
        BDAutoTrack.profileSet(profileDict)
    }

    class func stat(event: String, params: [String : Any?]? = nil) {
        let dic: [String : Any?] = params ?? [:]
        BDAutoTrack.eventV3(event, params: dic as [AnyHashable : Any])
    }
    
    class func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        for context in URLContexts {
            let url = context.url
            if BDAutoTrackSchemeHandler.shared().handle(url, appID: .Volcano.appID, scene: scene) {
                
            }
        }
    }
}
