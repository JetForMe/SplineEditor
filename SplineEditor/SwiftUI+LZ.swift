//
//  SwiftUI+LZ.swift
//  SplineEditor
//
//  Created by Rick Mann on 2021-05-06.
//

import SwiftUI
import simd


extension
Path
{
	@inline(__always)
	public
	mutating
	func
	move(to inTo: simd_float2)
	{
		move(to: CGPoint(inTo))
	}
}

extension
CGPoint
{
	@inline(__always)
	public
	init(_ inPt: simd_float2)
	{
		self.init(x: CGFloat(inPt.x), y: CGFloat(inPt.y))
	}
	
	@inline(__always)
	public
	init(_ inPt: simd_double2)
	{
		self.init(x: CGFloat(inPt.x), y: CGFloat(inPt.y))
	}
}
