//
//  EventDetailTableViewFooterView.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/9/12.
//

import UIKit

protocol EventDetailTableViewFooterViewDelegate {
    func tappedFooterViewAddDetailButton(_ view: EventDetailTableViewFooterView, section: Int)
}

class EventDetailTableViewFooterView: UITableViewHeaderFooterView {
    
    var delegate: EventDetailTableViewFooterViewDelegate?
    let addDetailButton = UIButton()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
        contentView.backgroundColor = .systemBackground
        addDetailButton.addTarget(self, action: #selector(tappedAddDetailButton(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        
        addDetailButton.translatesAutoresizingMaskIntoConstraints = false
        addDetailButton.layer.cornerRadius = 12
        addDetailButton.layer.masksToBounds = true
        addDetailButton.setTitle("Add Detail", for: .normal)
        addDetailButton.backgroundColor = .systemIndigo
        contentView.addSubview(addDetailButton)
        
        let guide = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            addDetailButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: 0.0),
//            addDetailButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20.0),
//            addDetailButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20.0),
            addDetailButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor, constant: 0.0),
            // 警告太多晚點再處理
            addDetailButton.widthAnchor.constraint(equalToConstant: 300),
            addDetailButton.heightAnchor.constraint(equalToConstant: 34.0)
        ])
        
    }
    
    @objc func tappedAddDetailButton(_ sender: UIButton) {
        delegate?.tappedFooterViewAddDetailButton(self, section: sender.tag)
    }
    
}
