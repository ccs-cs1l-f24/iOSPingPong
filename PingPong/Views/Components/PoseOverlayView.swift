//
//  PoseOverlayView.swift
//  PingPong
//
//  Created by Dylan Lu on 10/16/24.
//

import SwiftUI
import AVFoundation
import UIKit

struct PoseOverlayView: UIViewRepresentable {
    @Binding var poseOverlays: [PoseOverlay]
    
    func makeUIView(context: Context) -> OverlayView {
        let view = OverlayView()
        view.backgroundColor = .clear
        return view
    }
    
    func updateUIView(_ uiView: OverlayView, context: Context) {
        DispatchQueue.main.async {
            uiView.updatePoseOverlays(poseOverlays)
        }
    }
}

class OverlayView: UIView {
    var poseOverlays: [PoseOverlay] = []
    
    override func draw(_ rect: CGRect) {
        for poseOverlay in poseOverlays {
            drawLines(poseOverlay.lines)
            drawDots(poseOverlay.dots)
        }
    }
    
    private func drawDots(_ dots: [CGPoint]) {
        for dot in dots {
            let dotRect = CGRect(
                x: dot.x * self.bounds.width - DefaultConstants.pointRadius / 2,
                y: (1 - dot.y) * self.bounds.height - DefaultConstants.pointRadius / 2, // Flip vertically
                width: DefaultConstants.pointRadius,
                height: DefaultConstants.pointRadius
            )
            let path = UIBezierPath(ovalIn: dotRect)
            DefaultConstants.pointFillColor.setFill()
            DefaultConstants.pointColor.setStroke()
            path.stroke()
            path.fill()
        }
    }
    
    private func drawLines(_ lines: [Line]) {
        let path = UIBezierPath()
        for line in lines {
            path.move(to: CGPoint(x: line.from.x * self.bounds.width, y: (1 - line.from.y) * self.bounds.height)) // Flip vertically
            path.addLine(to: CGPoint(x: line.to.x * self.bounds.width, y: (1 - line.to.y) * self.bounds.height)) // Flip vertically
        }
        path.lineWidth = DefaultConstants.lineWidth
        DefaultConstants.lineColor.setStroke()
        path.stroke()
    }
    
    func updatePoseOverlays(_ overlays: [PoseOverlay]) {
        self.poseOverlays = overlays
        setNeedsDisplay()
    }
}

struct PoseOverlay {
    let dots: [CGPoint]
    let lines: [Line]
}

struct Line {
    let from: CGPoint
    let to: CGPoint
}
