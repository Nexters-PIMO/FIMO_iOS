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
            VStack(spacing: 0) {
                CustomNavigationBar(title: viewStore.userName)

                header(viewStore)

                ScrollView {
                    LazyVStack(pinnedViews: .sectionHeaders) {
                        friendsList(viewStore)
                    }
                }
                .refreshable {
                    viewStore.send(.refreshFriendList)
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
            ForEach(store.selectedFriendsList, id: \.self) { friend in
                friendCell(store, friend: friend)
            }
        }
        .padding(.horizontal, 20)
    }

    func friendCell(_ store: ViewStore<FriendsListStore.State, FriendsListStore.Action>, friend: FMFriend) -> some View {
        HStack {
            KFImage(URL(string: friend.profileImageUrl))
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
                Text(friend.nickname)
                    .font(.system(size: 16, weight: .semibold))
                Text(friend.archiveName)
                    .font(.system(size: 14))
                    .foregroundColor(Color(FIMOAsset.Assets.grayText.color))
            }
            .padding(.leading, 15)

            Spacer()

            Text("글사진 \(friend.postCount)개")
                .foregroundColor(Color(FIMOAsset.Assets.grayText.color))
                .font(.system(size: 12))

            Button {
                store.send(.tappedRequestFriendButton)
            } label: {
                friend.friendType.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28)
                    .padding(.leading, 19)
            }
        }
        .frame(minHeight: 40)
        .padding(.top, 25)
    }

    func header(_ store: ViewStore<FriendsListStore.State, FriendsListStore.Action>) -> some View {
        VStack(spacing: 0) {
            HStack {
                Spacer(minLength: 30)

                ForEach(FriendType.allCases, id: \.self) { type in
                    tabBarItem(store, title: type.title, count: store.friendsList[type.index].count, type: type)
                }

                Spacer(minLength: 30)
            }
            .frame(maxWidth: .infinity, minHeight: 70)
            .background(Color(uiColor: FIMOAsset.Assets.gray0.color))
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
                                ? Color(FIMOAsset.Assets.red1.color)
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
                                ? Color(FIMOAsset.Assets.red1.color)
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
        .frame(height: 164)
    }

    func tabBarItem(_ store: ViewStore<FriendsListStore.State, FriendsListStore.Action>, title: String, count: Int, type: FriendType) -> some View {
        Button {
            store.send(.tappedTab(type.description))
        } label: {
            VStack {
                VStack(spacing: 6) {
                    Text("\(count)")
                        .foregroundColor(.black)
                        .font(.system(size: 18, weight: .medium))
                    Text(title)
                        .foregroundColor(
                            store.currentTab.index == type.index
                            ? .black
                            : Color(FIMOAsset.Assets.grayText.color)
                        )
                        .font(.system(size: 12, weight: .medium))
                }
                .padding(.top, 17)

                if store.currentTab.index == type.index {
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
