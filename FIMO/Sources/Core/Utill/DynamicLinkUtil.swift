//
//  DynamicLinkUtil.swift
//  FIMO
//
//  Created by 김영인 on 2023/08/23.
//  Copyright © 2023 fimo. All rights reserved.
//

import Combine

import FirebaseDynamicLinks

enum DynamicLinkUtil {
    
    static func createDynamicLink(
        userId: String="",
        postId: String=""
    ) async throws -> String {
        guard let link = URL(string: "https://www.fimo.com/?userId=\(userId))&postId=\(postId))") else { return "" }
        
        let linkBuilder = DynamicLinkComponents(
            link: link,
            domainURIPrefix: "https://fimo.page.link"
        )
        
        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.nexters.ios.fimo")
        linkBuilder?.iOSParameters?.minimumAppVersion = "1.0.0"
        linkBuilder?.iOSParameters?.appStoreID = "123456789"
        
        linkBuilder?.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        linkBuilder?.socialMetaTagParameters?.title = "fimo"
        linkBuilder?.socialMetaTagParameters?.descriptionText = "친구의 아카이브를 구경해보세요"
        linkBuilder?.socialMetaTagParameters?.imageURL = URL(string: "https://ifh.cc/g/CMbjxJ.jpg")
        
        let shortURL = try await linkBuilder?.shorten()
        guard let linkURL = shortURL?.0 else { return "" }
        return "\(String(describing: linkURL))"
    }
}
