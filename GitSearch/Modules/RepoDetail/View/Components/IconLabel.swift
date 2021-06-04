//
//  IconLabel.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 03/06/2021.
//

import UIKit

class IconLabel: UILabel {
    
    var icon: UIImage? {
        didSet { updateLabel() }
    }
    
    override var text: String? {
        didSet { updateLabel() }
    }
    
    private func updateLabel() {
        let completeString = NSMutableAttributedString(string: "")
        
        if let image = icon {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = image
            imageAttachment.bounds = CGRect(x: 0, y: -4, width: image.size.width, height: image.size.height)

            let attachmentString = NSAttributedString(attachment: imageAttachment)
            completeString.append(attachmentString)
            completeString.append(NSAttributedString(string: "  "))
        }

        if let text = text {
            let attributedString = NSAttributedString(string: text)
            completeString.append(attributedString)
        }
            
        attributedText = completeString
    }
}
