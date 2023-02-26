//
//  ArchiveClient.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/25.
//  Copyright © 2023 pimo. All rights reserved.
//

import Combine
import Foundation

import ComposableArchitecture

struct ArchiveClient {
    let fetchArchive: () -> Archive
}

extension DependencyValues {
    var archiveClient: ArchiveClient {
        get { self[ArchiveClient.self] }
        set { self[ArchiveClient.self] = newValue }
    }
}

extension ArchiveClient: DependencyKey {
    static let liveValue = Self.init (
        fetchArchive: {
            // TODO: 서버 통신
            return Archive(
                archiveInfo: ArchiveInfo(
                    friendType: .both,
                    archiveName: "밤에 쓰는 편지",
                    profile: Temp.profile,
                    feedCount: 3
                ),
                feeds: Temp.feeds
            )
        }
    )
}
