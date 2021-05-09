//
//	Curve.swift
//	SplineEditor
//
//	Created by Rick Mann on 2021-05-05.
//

import Foundation
import simd



struct
Curve
{
	var			points				=	[simd_double2]()
	
	init()
	{
		self.points.append(simd_double2(0.0, 0.0))
		self.points.append(simd_double2(0.25, 0.0))
		self.points.append(simd_double2(0.75, 1.0))
		self.points.append(simd_double2(1.0, 1.0))
	}
	
	/**
		Returns the value of the curve at the given position. inX
		should be in the range [0, 1]. Values outside this range
		produce result equal to the values at 0 or 1.
	*/
	
	func
	value(at inX: Double)
		-> Double
	{
		let x = inX.clamped(to: 0.0 ... 1.0)
		
		let y0 = self.points[0].y
		let y1 = self.points[1].y
		let y2 = self.points[2].y
		let y3 = self.points[3].y
		
		let y = pow(1.0 - x, 3.0) * y0
			+ 3.0 * x * pow(1.0 - x, 2.0) * y1
			+ 3.0 * pow(x, 2.0) * (1.0 - x) * y2
			+ pow(x, 3.0) * y3;
            
		return y
	}
}


extension
Comparable
{
	func
	clamped(to limits: ClosedRange<Self>)
		-> Self
	{
		return min(max(self, limits.lowerBound), limits.upperBound)
	}
}
