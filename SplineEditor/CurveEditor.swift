//
//	CurveEditor.swift
//	TerrainFun
//
//	Created by Rick Mann on 2021-05-02.
//	Copyright © 2021 Latency: Zero, LLC. All rights reserved.
//

import SwiftUI
import simd


struct CurveEditor: View {
	var			curve			:	Curve
	
	var body: some View
	{
		//	Draw the axes…
		
		GeometryReader { geom in
			let width = geom.size.width					//	Make the rest of the code a bit cleaner
			let height = geom.size.height
			let chartWidth = width - 2 * kAxisMargin
			let chartHeight = height - 2 * kAxisMargin
			let scale = simd_double2(x: Double(chartWidth), y: Double(chartHeight))
			
			//	Draw the axesæ
			
			Path { path in
				path.move(to: .zero)
				path.addLine(to: CGPoint(x: chartWidth, y: 0.0))
				path.move(to: .zero)
				path.addLine(to: CGPoint(x: 0.0, y: chartHeight))
				
				for p: CGFloat in stride(from: CGFloat(0.0), through: CGFloat(1.0), by: kTickInterval)
				{
					path.move(to: CGPoint(x: p * chartWidth, y: 0.0))
					path.addLine(to: CGPoint(x: p * chartWidth, y: -6.0))
					path.move(to: CGPoint(x: 0.0, y: p * chartHeight))
					path.addLine(to: CGPoint(x: -6.0, y: p * chartHeight))
				}
			}
			.offset(x: kAxisMargin, y: kAxisMargin)
			.scale(x: 1.0, y: -1.0)
			.stroke(style: StrokeStyle(lineWidth: 2.0, lineCap: .square))
			.foregroundColor(.gray)
			
			//	Draw the control points…
			
			Path { path in
				
				for p in self.curve.points
				{
					let pp = p * scale
					path.move(to: CGPoint(pp))
					path.addArc(center: CGPoint(pp),
								radius: 4.0,
								startAngle: .zero, endAngle: .init(radians: Double.pi * 2),
								clockwise: false)
				}
			}
			.offset(x: kAxisMargin, y: kAxisMargin)
			.scale(x: 1.0, y: -1.0)
			.fill()
			.foregroundColor(.red)
			
			//	Draw the curve…
			
			Path { path in
				path.move(to: CGPoint(self.curve.points[0] * scale))
				path.addCurve(to: CGPoint(self.curve.points[3] * scale),
								control1: CGPoint(self.curve.points[1] * scale),
								control2: CGPoint(self.curve.points[2] * scale))
			}
			.offset(x: kAxisMargin, y: kAxisMargin)
			.scale(x: 1.0, y: -1.0)
			.stroke(style: StrokeStyle(lineWidth: 2.0, lineCap: .square))
			.foregroundColor(.black)
		}
	}
	
	let		kAxisMargin			:	CGFloat					=	30.0
	let		kTickInterval		:	CGFloat					=	0.25
}

struct CurveEditor_Previews: PreviewProvider {
	static var previews: some View {
		let curve = Curve()
		CurveEditor(curve: curve)
	}
}
