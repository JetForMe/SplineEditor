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
        WindowGroup("Curve Editor") {
            CurveEditor(curve: Curve())
//            	.frame(minWidth: 400, minHeight: 400)
        }
    }
}



func
debugLog<T>(_ inMsg: T, file inFile : String = #file, line inLine : Int = #line)
{
	let file = (inFile as NSString).lastPathComponent
	let s = "\(file):\(inLine)    \(inMsg)"
	print(s)
}

func
debugLog(format inFormat: String, file inFile : String = #file, line inLine : Int = #line, _ inArgs: CVarArg...)
{
	let s = String(format: inFormat, arguments: inArgs)
	debugLog(s, file: inFile, line: inLine)
}

func
debugLogView<T>(_ inMsg: T, file inFile : String = #file, line inLine : Int = #line)
	-> EmptyView
{
	debugLog(inMsg, file: inFile, line: inLine)
	return EmptyView()
}
