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
        uiView.updatePoseOverlays(poseOverlays)
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
                x: dot.x - 5,
                y: dot.y - 5,
                width: 10,
                height: 10
            )
            let path = UIBezierPath(ovalIn: dotRect)
            UIColor.red.setFill()
            path.fill()
        }
    }

    private func drawLines(_ lines: [Line]) {
        let path = UIBezierPath()
        for line in lines {
            path.move(to: line.from)
            path.addLine(to: line.to)
        }
        path.lineWidth = 2
        UIColor.green.setStroke()
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
