//
//  FrientdsListView.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/23.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import Kingfisher

struct FriendsListView: View {
    let store: StoreOf<FriendsListStore>
    @Namespace private var underLine

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ScrollView {
                LazyVStack(pinnedViews: .sectionHeaders) {
                    Section {
                        friendsList(viewStore)
                    } header: {
                        if viewStore.friendsList.count > 0 {
                            VStack {
                                CustomNavigationBar(title: viewStore.selectedFriendsList.nickName)
                                header(viewStore)
                            }

                        }
                    }
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    func friendsList(_ store: ViewStore<FriendsListStore.State, FriendsListStore.Action>) -> some View {
        LazyVStack {
            ForEach(store.selectedFriendsList.friends, id: \.self) { friend in
                friendCell(store, friend: friend)
            }
        }
        .padding(.horizontal, 20)
    }

    func friendCell(_ store: ViewStore<FriendsListStore.State, FriendsListStore.Action>, friend: Friend) -> some View {
        HStack(alignment: .center) {
            KFImage(URL(string: friend.profileImageURL))
                .retry(maxCount: 3, interval: .seconds(5))
                .cacheOriginalImage()
                .resizable()
                .placeholder({
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 40))
                })
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .mask {
                    Circle()
                }

            VStack(alignment: .leading, spacing: 5) {
                Text(friend.name)
                    .font(.system(size: 16, weight: .semibold))
                Text(friend.archiveName)
                    .font(.system(size: 14))
                    .foregroundColor(Color(PIMOAsset.Assets.grayText.color))
            }
            .padding(.leading, 15)

            Spacer()

            Text("글사진 \(friend.count)개")
                .foregroundColor(Color(PIMOAsset.Assets.grayText.color))
                .font(.system(size: 12))

            if friend.isMyRelationship {
                Button {
                    store.send(.tappedRequestFriendButton(friend.friendType))
                } label: {
                    friend.friendType.image
                        .padding(.leading, 19)
                }
            } else {
                friend.friendType.noRelationshipImage
                    .padding(.leading, 19)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 40)
        .padding(.top, 25)
    }

    func header(_ store: ViewStore<FriendsListStore.State, FriendsListStore.Action>) -> some View {
        VStack {
            HStack {
                Spacer(minLength: 30)

                ForEach(FriendType.allCases, id: \.self) { type in
                    tabBarItem(store, title: type.title, count: store.selectedFriendsList.count, index: type.index)
                }

                Spacer(minLength: 30)
            }
            .frame(maxWidth: .infinity, minHeight: 70)
            .background(Color(uiColor: PIMOAsset.Assets.gray0.color))
            .padding(.top, 23)

            HStack {
                HStack(spacing: 4) {
                    Text("친구")
                        .bold()

                    Text("\(store.selectedFriendsList.count)명")
                }
                .font(.system(size: 14))

                Spacer()

                HStack {
                    Button {
                        store.send(.tappedNewestButton)
                    } label: {
                        Text("친구추가순")
                            .foregroundColor(
                                store.selectedSort == .newest
                                ? Color(PIMOAsset.Assets.red1.color)
                                : .black
                            )
                    }

                    Divider()

                    Button {
                        store.send(.tappedCharactorOrderButton)
                    } label: {
                        Text("가나다순")
                            .foregroundColor(
                                store.selectedSort == .characterOrder
                                ? Color(PIMOAsset.Assets.red1.color)
                                : .black
                            )
                    }
                }
                .font(.system(size: 12))

            }
            .padding(.top, 37)
            .padding(.bottom, 20)

            CustomDivider()
        }
        .padding(.horizontal, 20)
    }

    func tabBarItem(_ store: ViewStore<FriendsListStore.State, FriendsListStore.Action>, title: String, count: Int, index: Int) -> some View {
        Button {
            store.send(.tappedTab(index))
        } label: {
            VStack {
                VStack(spacing: 6) {
                    Text("\(count)")
                        .foregroundColor(.black)
                        .font(.system(size: 18, weight: .medium))
                    Text(title)
                        .foregroundColor(
                            store.currentTab.index == index
                            ? .black
                            : Color(PIMOAsset.Assets.grayText.color)
                        )
                        .font(.system(size: 12, weight: .medium))
                }
                .padding(.top, 17)

                Spacer()

                if store.currentTab.index == index {
                    Color.black
                        .frame(width: 77, height: 1)
                        .matchedGeometryEffect(id: "underLine", in: underLine)
                } else {
                    Color.clear
                        .frame(height: 1)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.spring(), value: store.currentTab)
    }
}

struct FrientdsListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsListView(
            store: Store(
                initialState: FriendsListStore.State(),
                reducer: FriendsListStore()
            )
        )
    }
}
