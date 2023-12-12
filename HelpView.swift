//
//  HelpView.swift
//  FocusOnTodoList
//
//  Created by wenjian on 2023/12/11.
//

import SwiftUI

struct HelpView: View {
    @Binding var isShowHelpView: Bool

    var body: some View {
        VStack {
            Image("Image")
                .foregroundColor(Utils.color)

            Spacer()

            Text(Utils.appName + Utils.version)
                .foregroundColor(Utils.color)
            Spacer()

            Text("Contact: movetobe@outlook.com")
                .foregroundColor(Utils.color)

            Spacer()

            Button("OK") {
                isShowHelpView.toggle()
            }
            .foregroundColor(Utils.color)
        }
        .padding(.leading)
        .padding(.top)
        .padding(.trailing)
        .padding(Utils.paddingSize)
    }
}
