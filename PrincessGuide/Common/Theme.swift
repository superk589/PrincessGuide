//
//  Theme.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/5.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

struct ThemeColors {
    let textfield: ThemeTextfieldColors
    let tint: UIColor
    let title: UIColor
    let body: UIColor
    let lightText: UIColor
    let highlightedText: UIColor
    let background: UIColor
    let indicator: UIColor
    let caption: UIColor
    let tableViewCell: ThemeTableViewCell
    let loadingHUD: ThemeLoadingHUD
    let foregroundColor: UIColor
    let upValue: UIColor
    let downValue: UIColor
}

struct ThemeTextfieldColors {
    let text: UIColor
    let background: UIColor
}

struct ThemeTableViewCell {
    let selectedBackground: UIColor
    let background: UIColor
}

struct ThemeLoadingHUD {
    let background: UIColor
    let text: UIColor
    let foreground: UIColor
}

struct Theme: ThemeProtocol {

    let color: ThemeColors
    
    let barStyle: UIBarStyle
    let lightOpacity: Float
    let shadowOpacity: Float
    let backgroundImage: UIImage
    let indicatorStyle: UIScrollView.IndicatorStyle
    let blurEffectStyle: UIBlurEffect.Style
    let keyboardAppearance: UIKeyboardAppearance
    
    static let light = Theme(
        color: ThemeColors(
            textfield: ThemeTextfieldColors(
                text: .nearBlack,
                background: .nearWhite
            ),
            tint: .hatsunePurple,
            title: .nearBlack,
            body: .darkGray,
            lightText: .lightGray,
            highlightedText: .red,
            background: .white,
            indicator: .gray,
            caption: .darkGray,
            tableViewCell: ThemeTableViewCell(
                selectedBackground: UIColor(hexString: "D9D9D9"),
                background: .white
            ),
            loadingHUD: ThemeLoadingHUD(
                background: UIColor.white.withAlphaComponent(0.45),
                text: .white,
                foreground: UIColor.lightGray.withAlphaComponent(0.55)
            ),
            foregroundColor: .white,
            upValue: UIColor(hexString: "DC5A5A"),
            downValue: UIColor(hexString: "528FCC")
        ),
        barStyle: .default,
        lightOpacity: 1.0,
        shadowOpacity: 0.0,
        backgroundImage: UIImage(),
        indicatorStyle: .black,
        blurEffectStyle: .extraLight,
        keyboardAppearance: .light
    )
    
    static let dark = Theme(
        color: ThemeColors(
            textfield: ThemeTextfieldColors(
                text: .nearWhite,
                background: .gray
            ),
            tint: .hatsuneYellow,
            title: .white,
            body: .nearWhite,
            lightText: .gray,
            highlightedText: .darkHighlighted,
            background: UIColor(hexString: "1A1A32"),
            indicator: .hatsunePurple,
            caption: .nearWhite,
            tableViewCell: ThemeTableViewCell(
                selectedBackground: .darkGray,
                background: .clear
            ),
            loadingHUD: ThemeLoadingHUD(
                background: UIColor.black.withAlphaComponent(0.45),
                text: .hatsuneYellow,
                foreground: UIColor.darkGray.withAlphaComponent(0.55)
            ),
            foregroundColor: .black,
            upValue: UIColor(hexString: "E59053"),
            downValue: UIColor(hexString: "27A79B")
        ),
        barStyle: .black,
        lightOpacity: 0.0,
        shadowOpacity: 1.0,
        backgroundImage: #imageLiteral(resourceName: "sky_background"),
        indicatorStyle: .white,
        blurEffectStyle: .dark,
        keyboardAppearance: .dark
    )
}
