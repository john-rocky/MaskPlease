//
//  Views.swift
//  MaskPlease
//
//  Created by 間嶋大輔 on 2020/05/12.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    
    func viewsSetting(){
        
        thankYouMaskingView.frame = view.frame
        pleaseMaskingView.frame = view.frame
        pleaseMaskingView2.frame = view.frame

        maskingLabel.frame = view.frame
        nomaskingLabel.frame = view.frame
    }
    
    func initialViewsSettings(){
        view.addSubview(thankYouMaskingView)
        view.addSubview(pleaseMaskingView)
        view.addSubview(pleaseMaskingView2)
        view.addSubview(maskingLabel)
        view.addSubview(nomaskingLabel)
        
        thankYouMaskingView.image = UIImage(named: "masking")
        pleaseMaskingView.image = UIImage(named: "face")
        pleaseMaskingView2.image = UIImage(named: "maskon")

        thankYouMaskingView.contentMode = .scaleAspectFit
        pleaseMaskingView.contentMode = .scaleAspectFit
        pleaseMaskingView2.contentMode = .scaleAspectFit

        maskingLabel.textAlignment = .center
        nomaskingLabel.textAlignment = .center
        maskingLabel.adjustsFontSizeToFitWidth = true
        nomaskingLabel.adjustsFontSizeToFitWidth = true
        maskingLabel.text = NSLocalizedString("マスクの着用\n ありがとうございます", comment: "")
        nomaskingLabel.text = NSLocalizedString("マスクの着用を\n お願いします", comment: "")
        maskingLabel.font = .systemFont(ofSize: 120, weight: .black)
        nomaskingLabel.font = .systemFont(ofSize: 120, weight: .black)
        maskingLabel.numberOfLines = 2
        nomaskingLabel.numberOfLines = 2


        pleaseMaskingView.isHidden = true
        pleaseMaskingView2.isHidden = true

        nomaskingLabel.isHidden = true
    }
}
