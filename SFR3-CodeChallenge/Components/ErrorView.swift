//
//  ErrorView.swift
//  SFR3-CodeChallenge
//
//  Created by Frank Martin on 8/26/24.
//

import SwiftUI

struct ErrorView: View {
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 36) {
            image
            message
            button
        }
        .padding()
    }
    
    private var image: some View {
        Image.named(.exclamationmarkCircleFill)
            .resizable()
            .frame(width: 60, height: 60)
            .foregroundStyle(Color.red)
    }
    
    private var message: some View {
        Text(NSLocalizedString("Uh oh! Looks like something went wrong. Please try again.", comment: ""))
            .font(.title3)
    }
    
    private var button: some View {
        Button {
            retryAction()
        } label: {
            Text(NSLocalizedString("Try again", comment: ""))
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(25)
                .font(.title3)
        }

    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView() {}
    }
}
