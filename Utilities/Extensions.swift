// Extensions.swift
import SwiftUI

extension Color {
    static func fromInterpretation(_ interpretation: ScoreInterpretation) -> Color {
        switch interpretation {
        case .favorable:
            return Color("FavorableGreen")
        case .moderatelyFavorable:
            return Color("ModerateOrange")
        case .unfavorable:
            return Color("UnfavorableRed")
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
