//
//  SplineEditorApp.swift
//  SplineEditor
//
//  Created by Rick Mann on 2021-05-02.
//

import SwiftUI

@main
struct SplineEditorApp: App {
    var body: some Scene {
        WindowGroup {
            CurveEditor(curve: Curve())
//            	.frame(minWidth: 400, minHeight: 400)
        }
    }
}
