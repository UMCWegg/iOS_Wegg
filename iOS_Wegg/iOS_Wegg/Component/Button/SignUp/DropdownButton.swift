//
//  DropdownButton.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.31.
//

import UIKit

import Then
import SnapKit

class DropdownButton: UIButton {
    
    // MARK: - Design Component
    
    private let buttonHeight = 44
    var didSelectOption: ((String) -> Void)?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    private var options: [String] = []
    private var selectedOption: String?
    private var dropdownTableView: UITableView?
    private var isDropdownVisible = false
    
    private let arrowImage = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.down")
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFill
    }
    
    private let occupationLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.LoginFont.textField
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.LoginColor.labelColor?.cgColor
        layer.cornerRadius = 22
        
        addSubview(occupationLabel)
        addSubview(arrowImage)
        
        occupationLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalTo(arrowImage.snp.leading).offset(-10)
        }
        
        arrowImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
            make.width.height.equalTo(16)
        }
        
        snp.makeConstraints { make in
            make.height.equalTo(buttonHeight)
        }
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func setupDropdownTableView() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else { return }
        
        let tableView = UITableView().then {
            $0.delegate = self
            $0.dataSource = self
            $0.register(UITableViewCell.self, forCellReuseIdentifier: "DropdownCell")
            $0.layer.cornerRadius = 22
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.LoginColor.labelColor?.cgColor
            $0.backgroundColor = backgroundColor
            $0.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            $0.separatorColor = .black
            $0.layoutMargins.left = 15
            $0.showsVerticalScrollIndicator = false
        }
        
        window.addSubview(tableView)
        
        let globalPoint = convert(bounds, to: window)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(globalPoint.minY)
            make.leading.equalTo(globalPoint.minX)
            make.width.equalTo(bounds.width)
            make.height.equalTo(CGFloat(options.count * buttonHeight))
        }
        
        self.dropdownTableView = tableView
    }
    
    // MARK: - Functions
    
    func configure(options: [String], placeholder: String) {
        self.options = options
        occupationLabel.text = placeholder
    }
    
    @objc private func buttonTapped() {
        if isDropdownVisible {
            hideDropdown()
        } else {
            showDropdown()
        }
    }
    
    private func showDropdown() {
        setupDropdownTableView()
        isDropdownVisible = true
        arrowImage.image = UIImage(systemName: "chevron.up")
    }
    
    private func hideDropdown() {
        dropdownTableView?.removeFromSuperview()
        dropdownTableView = nil
        isDropdownVisible = false
        arrowImage.image = UIImage(systemName: "chevron.down")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension DropdownButton: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownCell", for: indexPath)
        
        cell.textLabel?.text = options[indexPath.row]
        cell.textLabel?.font = UIFont.LoginFont.textField
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = options[indexPath.row]
        occupationLabel.text = selectedOption
        hideDropdown()
        didSelectOption?(selectedOption)
    }
}
