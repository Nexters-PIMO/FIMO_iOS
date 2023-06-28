//
//  OnboardingCollectionView.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/28.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct OnboardingCollectionView: UIViewRepresentable {
    static let cellIdentifier = "OnboardingViewCollectionViewCell"
    var viewStore: ViewStore<OnboardingStore.State, OnboardingStore.Action>
    let onboardingTypes: [OnboardingPageType] = OnboardingPageType.allCases
    var currentPage = 0

    func makeUIView(context: Context) -> UICollectionView {
        let screenSize = UIScreen.main.bounds.size
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let size = CGSize(width: screenWidth, height: screenHeight)
        let rect = CGRect(origin: .zero, size: size)
        let layout = UICollectionViewFlowLayout()
        layout.collectionView?.frame = rect
        layout.scrollDirection = .horizontal
        layout.itemSize = size
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }

    func updateUIView(_ uiView: UICollectionView, context: Context) {
        uiView.dataSource = context.coordinator
        uiView.delegate = context.coordinator
        uiView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionView.cellIdentifier)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
        var parent: OnboardingCollectionView

        init(_ parent: OnboardingCollectionView) {
            self.parent = parent
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return parent.onboardingTypes.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionView.cellIdentifier, for: indexPath)
            cell.backgroundColor = .orange

            guard let pageType: OnboardingPageType = .init(rawValue: indexPath.row) else {
                return cell
            }

            cell.contentConfiguration = UIHostingConfiguration {
                if pageType == .one {
                    FirstOnboardingView(viewStore: parent.viewStore, type: pageType)
                } else {
                    OtherOnboardingView(viewStore: parent.viewStore, type: pageType)
                }
            }.margins(.all, 0)

            return cell
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let currentPageIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            guard currentPageIndex != parent.viewStore.pageType.index,
                  let pageType = OnboardingPageType(rawValue: currentPageIndex) else {
                return
            }

            parent.viewStore.send(.changePage(pageType))
        }
    }
}
