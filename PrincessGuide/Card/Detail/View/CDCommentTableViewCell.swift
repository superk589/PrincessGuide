//
//  CDCommentTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

protocol CDCommentTableViewCellDelegate: class {
    func doubleClick(on cdCommentTableViewCell: CDCommentTableViewCell)
}

class CDCommentTableViewCell: UITableViewCell {

    let commentLabel = UILabel()
    
    let loadingIndicator = UIActivityIndicatorView()
        
    weak var delegate: CDCommentTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectedBackgroundView = UIView()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themeable.backgroundColor = theme.color.tableViewCell.background
            themeable.commentLabel.textColor = theme.color.body
            themeable.loadingIndicator.color = theme.color.indicator
        }
        
        commentLabel.font = UIFont.scaledFont(forTextStyle: .body, ofSize: 14)
        contentView.addSubview(commentLabel)
        commentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.right.lessThanOrEqualTo(readableContentGuide)
        }
        commentLabel.numberOfLines = 0
        
        contentView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(doubleTap)
    }
    
    @objc private func handleDoubleTap(_ tap: UITapGestureRecognizer) {
        delegate?.doubleClick(on: self)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for text: String) {
        commentLabel.text = text
    }
    
}

extension CDCommentTableViewCell: CardDetailConfigurable {
    func configure(for item: CardDetailItem) {
        if case .comment(let comment) = item {
            configure(for: comment.description.replacingOccurrences(of: "\\n", with: "\n"))
        } else if case .commentText(let text) = item {
            configure(for: text)
        }
    }
}
