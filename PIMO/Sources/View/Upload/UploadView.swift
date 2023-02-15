//
//  UploadView.swift
//  PIMOTests
//
//  Created by 김영인 on 2023/02/14.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct UploadView: View {
    let store: StoreOf<UploadStore>
    
    var body: some View {
        Text("Upload")
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView(
            store: Store(
                initialState: UploadStore.State(),
                reducer: UploadStore()))
    }
}

