//
//  CustomCollectionViewIconCell.swift
//  BoxOffice
//
//  Created by Jinah Park on 2023/04/07.
//

import UIKit

final class CustomCollectionViewIconCell: UICollectionViewCell {
    static let identifier = "CustomCollectionViewIconCell"
    var dailyBoxOffice: DailyBoxOffice?
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let rankLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    let movieNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    let rankIntensityLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    let audienceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    func configureCell(dailyBoxOffice: DailyBoxOffice?) {
        configureUI()
        configureLayout()
        configureContext(dailyBoxOffice: dailyBoxOffice)
    }
    
    private func configureUI() {
        self.addSubview(mainStackView)
        mainStackView.addArrangedSubview(rankLabel)
        mainStackView.addArrangedSubview(movieNameLabel)
        mainStackView.addArrangedSubview(rankIntensityLabel)
        mainStackView.addArrangedSubview(audienceLabel)
    }
    
    private func configureContext(dailyBoxOffice: DailyBoxOffice?) {
        rankLabel.text = dailyBoxOffice?.rank
        movieNameLabel.text = dailyBoxOffice?.movieName
        rankIntensityLabel.attributedText = configureRankIntensityText(dailyBoxOffice: dailyBoxOffice)
        if let count = dailyBoxOffice?.audienceCount.formatNumberString(),
           let accumulation = dailyBoxOffice?.audienceAccumulation.formatNumberString() {
            audienceLabel.text = "오늘 \(count) / 총 \(accumulation)"
        }
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    private func configureRankIntensityText(dailyBoxOffice: DailyBoxOffice?) -> NSMutableAttributedString? {
        var attributedString: NSMutableAttributedString
        guard var rankIntensity = dailyBoxOffice?.rankIntensity else { return nil }
        
        if dailyBoxOffice?.rankOldAndNew == "NEW" {
            attributedString = NSMutableAttributedString(string: "신작")
            let range = ("신작" as NSString).range(of: "신작")
            attributedString.addAttribute(.foregroundColor,
                                          value: UIColor.systemRed,
                                          range: range)
            return attributedString
        }
        
        if rankIntensity == "0" {
            return NSMutableAttributedString(string: "-")
        }
        
        if rankIntensity.contains("-") {
            rankIntensity.removeFirst()
            let rankIntensityText = "▼" + rankIntensity
            attributedString = NSMutableAttributedString(string: rankIntensityText)
            let range = (rankIntensityText as NSString).range(of: "▼")
            attributedString.addAttribute(.foregroundColor,
                                          value: UIColor.blue,
                                          range: range)
        } else {
            let rankIntensityText = "▲" + rankIntensity
            attributedString = NSMutableAttributedString(string: rankIntensityText)
            let range = (rankIntensityText as NSString).range(of: "▲")
            attributedString.addAttribute(.foregroundColor,
                                          value: UIColor.red,
                                          range: range)
        }
        
        return attributedString
    }
}
