//
//  Font.swift
//  ReadIt
//
//  Created by Marc Nieto on 4/11/18.
//  Copyright © 2018 Marc Nieto. All rights reserved.
//

import UIKit

class Font {

    // MARK: - Convenience

    static var regular: UIFont {
        return UIFont(name: "HelveticaNeue", size: UIFont.systemFontSize)!
    }

    static var thin: UIFont {
        return UIFont(name: "HelveticaNeue-Thin", size: UIFont.systemFontSize)!
    }

    static var bold: UIFont {
        return UIFont(name: "HelveticaNeue-Bold", size: UIFont.systemFontSize)!
    }

}
