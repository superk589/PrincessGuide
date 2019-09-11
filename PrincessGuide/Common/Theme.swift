//
//  Theme.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/5.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

struct ThemeColors {
    let tint: UIColor
    let title: UIColor
    let body: UIColor
    let lightText: UIColor
    let highlightedText: UIColor
    let background: UIColor
    let indicator: UIColor
    let caption: UIColor
    let loadingHUD: ThemeLoadingHUD
    let foregroundColor: UIColor
    let upValue: UIColor
    let downValue: UIColor
}

struct ThemeLoadingHUD {
    let background: UIColor
    let text: UIColor
    let foreground: UIColor
}

struct Theme {

    let color: ThemeColors
    
    static let dynamic = Theme(
        color: ThemeColors(
            tint: UIColor {
                switch $0.userInterfaceStyle {
                case .dark: return .hatsuneYellow
                default: return .hatsunePurple
                }
            },
            title: .label,
            body: UIColor {
                switch $0.userInterfaceStyle {
                case .dark: return .nearWhite
                default: return .nearBlack
                }
            },
            lightText: .tertiaryLabel,
            highlightedText: UIColor {
                switch $0.userInterfaceStyle {
                case .dark: return .darkHighlighted
                default: return .red
                }
            },
            background: .systemBackground,
            indicator: UIColor {
                switch $0.userInterfaceStyle {
                case .dark: return .hatsunePurple
                default: return .gray
                }
            },
            caption: UIColor {
                switch $0.userInterfaceStyle {
                case .dark: return .nearWhite
                default: return .darkGray
                }
            },
            loadingHUD: ThemeLoadingHUD(
                background: UIColor {
                    switch $0.userInterfaceStyle {
                    case .dark: return UIColor.black.withAlphaComponent(0.45)
                    default: return UIColor.white.withAlphaComponent(0.45)
                    }
                },
                text: UIColor {
                    switch $0.userInterfaceStyle {
                    case .dark: return .hatsuneYellow
                    default: return .white
                    }
                },
                foreground: UIColor {
                    switch $0.userInterfaceStyle {
                    case .dark: return UIColor.darkGray.withAlphaComponent(0.55)
                    default: return UIColor.lightGray.withAlphaComponent(0.55)
                    }
                }
            ),
            foregroundColor: .label,
            upValue: UIColor {
                switch $0.userInterfaceStyle {
                case .dark: return UIColor(hexString: "E59053")
                default: return UIColor(hexString: "DC5A5A")
                }
            },
            downValue: UIColor {
                switch $0.userInterfaceStyle {
                case .dark: return UIColor(hexString: "27A79B")
                default: return UIColor(hexString: "528FCC")
                }
            }
        )
    )
}
