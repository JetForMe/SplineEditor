//
//  Curve.swift
//  SplineEditor
//
//  Created by Rick Mann on 2021-05-05.
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
}
