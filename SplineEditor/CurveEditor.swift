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
	@State				var		curve					:	Curve
	@State		private	var		local					:	CGPoint			=	.zero
	@State		private	var		cursorPosition			:	CGPoint			=	.zero
	
	@State		private	var		drawCustomHandles							=	true
	
	var body: some View
	{
		VStack {
			CurveEditorDetail(curve: self.$curve,
								local: self.$local,
								cursorPosition: self.$cursorPosition,
								drawCustomHandles: self.$drawCustomHandles)
			HStack {
				InfoBar(local: self.local, cursorPosition: self.cursorPosition)
				Spacer()
				Toggle(isOn: self.$drawCustomHandles) {
					Text("Draw Custom")
				}
			}
		}
	}
}

struct
CurveEditorDetail: View
{
	@Binding			var		curve					:	Curve
	@Binding			var		local					:	CGPoint		//	TODO: I don't really like this binding shit here, but tracking is super broken anyway. I think we can handle tracking outside of these detail views
	@Binding			var		cursorPosition			:	CGPoint
	
	@Binding			var		drawCustomHandles		:	Bool
	
	@State		private	var		offset										=	CGSize.zero
	@State		private	var		dragPointIdx			:	Int?
    
    @State var isDragging = false
    var drag: some Gesture {
        DragGesture()
            .onChanged { _ in self.isDragging = true }
            .onEnded { _ in self.isDragging = false }
    }
	
	
	var body: some View
	{
		//	Draw the axes…
		
		GeometryReader { geom in
			let width = geom.size.width					//	Make the rest of the code a bit cleaner
			let height = geom.size.height
			let chartWidth = width - 2 * kAxisMargin
			let chartHeight = height - 2 * kAxisMargin
			let scale = simd_double2(x: Double(chartWidth), y: Double(chartHeight))
			let localFrame = geom.frame(in: .local)
			let globalFrame = geom.frame(in: .global)
//			debugLogView("localFrame: \(localFrame)")
//			debugLogView("globalFrame: \(globalFrame)")
			
			//	Draw the axes…
			
			ZStack {
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
				
				if drawCustomHandles
					{
					Path
					{ path in
						
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
				}
				else
				{
					EnumeratedForEach(self.curve.points)
					{ idx, point in
						let pp = point * scale
						Handle(index: idx, offset: CGSize(pp))
							.gesture(self.drag)
					}
				}
				
				//	Draw the x==t -> y curve…
				
				Path { path in
	//				path.move(to: CGPoint(self.curve.points[0] * scale))
	//				path.addCurve(to: CGPoint(self.curve.points[3] * scale),
	//								control1: CGPoint(self.curve.points[1] * scale),
	//								control2: CGPoint(self.curve.points[2] * scale))

					let y0 = self.curve.value(at: 0.0)
					path.move(to: CGPoint(x: 0.0, y: y0))
					
					for x: CGFloat in stride(from: CGFloat(0.0), through: CGFloat(1.0), by: 1 / 30.0)
					{
						let y = CGFloat(self.curve.value(at: Double(x)))
						path.addLine(to: CGPoint(x: x * chartWidth, y: y * chartHeight))
					}
				}
				.offset(x: kAxisMargin, y: kAxisMargin)
				.scale(x: 1.0, y: -1.0)
				.stroke(style: StrokeStyle(lineWidth: 1.0, lineCap: .square))
				.foregroundColor(.black)
				
				//	Draw the “real” (t -> x,y) curve so we can see how distorted things are…
				
				Path { path in
					path.move(to: CGPoint(self.curve.points[0] * scale))
					path.addCurve(to: CGPoint(self.curve.points[3] * scale),
									control1: CGPoint(self.curve.points[1] * scale),
									control2: CGPoint(self.curve.points[2] * scale))
				}
				.offset(x: kAxisMargin, y: kAxisMargin)
				.scale(x: 1.0, y: -1.0)
				.stroke(style: StrokeStyle(lineWidth: 1.0, lineCap: .square))
				.foregroundColor(.green)
			}	//	Group/ZStack
			.gesture(DragGesture()
						.onChanged { self.offset = $0.translation }
			)
//			.trackingMouse(onMove: { inPoint in
//				self.local = inPoint
////				let scale = self.layer.sourceSize! / geom.size
////				self.cursorPosition = scale * inPoint
//			})
		}	//	GeometryReader
	}
	
	let		kAxisMargin			:	CGFloat					=	30.0
	let		kTickInterval		:	CGFloat					=	0.25
}




struct InfoBar: View {
	let		local					:	CGPoint
	let		cursorPosition			:	CGPoint
	
	var body: some View {
		HStack
		{
			Text("Xl: \(self.local.x, specifier: "%0.f")")
				.frame(minWidth: 100, alignment: .leading)
			Text("Yl: \(self.local.y, specifier: "%0.f")")
				.frame(minWidth: 100, alignment: .leading)
			Text("X: \(self.cursorPosition.x, specifier: "%0.f")")
				.frame(minWidth: 100, alignment: .leading)
			Text("Y: \(self.cursorPosition.y, specifier: "%0.f")")
				.frame(minWidth: 100, alignment: .leading)
			Spacer()
		}
		.frame(minWidth: 0.0, alignment: .leading)
		.background(Color("status-bar-background"))
	}
}

struct
Handle : View
{
	let			index				:	Int
	@State var	offset				:	CGSize
	
	var
	body : some View
	{
		Circle()
			.fill(Color.blue)
			.frame(width: 8.0, height: 8.0, alignment: .center)
			.offset(offset)
	}
}

struct CurveEditor_Previews: PreviewProvider {
	static var previews: some View {
		let curve = Curve()
		CurveEditor(curve: curve)
	}
}


struct EnumeratedForEach<ItemType, ContentView: View>: View {
    let data: [ItemType]
    let content: (Int, ItemType) -> ContentView
    
    init(_ data: [ItemType], @ViewBuilder content: @escaping (Int, ItemType) -> ContentView) {
        self.data = data
        self.content = content
    }
    
    var body: some View {
        ForEach(Array(self.data.enumerated()), id: \.offset) { idx, item in
            self.content(idx, item)
        }
    }
}
