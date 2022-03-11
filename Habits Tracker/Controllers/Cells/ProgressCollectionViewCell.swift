import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    static let id = "ProgressCollectionViewCell"
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = .lightGray
        contentView.addSubview(habitsProgressBackView)
        habitsProgressBackView.addSubview(habitsProgressTitle)
        habitsProgressBackView.addSubview(habitsProgressPercent)
        habitsProgressBackView.addSubview(habitsProgressView)
        setupConstraints()
    }
    
    // MARK: - UI elements
    
    private lazy var habitsProgressBackView: UIView = {
        let habitsProgressBackView = UIView()
        habitsProgressBackView.layer.cornerRadius = 2
        habitsProgressBackView.backgroundColor = .white
        
        habitsProgressBackView.translatesAutoresizingMaskIntoConstraints = false
        return habitsProgressBackView
    }()
    
    private lazy var habitsProgressTitle: UILabel = {
        let habitsProgressTitle = UILabel()
        
        habitsProgressTitle.textColor = .systemGray
        habitsProgressTitle.text = "Все получится!"
        habitsProgressTitle.font = UIFont(name: "SFProText-Semibold", size: 13)
       
        habitsProgressTitle.translatesAutoresizingMaskIntoConstraints = false
        return habitsProgressTitle
    }()
    
    private lazy var habitsProgressPercent: UILabel = {
        let habitsProgressPercent = UILabel()
        habitsProgressPercent.text = "75%"
        habitsProgressPercent.textColor = .systemGray
        habitsProgressPercent.font = UIFont(name: "SFProText-Semibold", size: 13)
        
        habitsProgressPercent.translatesAutoresizingMaskIntoConstraints = false
        return habitsProgressPercent
    }()
    
    lazy var habitsProgressView: UIProgressView = {
        let habitsProgressView = UIProgressView()
        habitsProgressView.progressViewStyle = .bar
        habitsProgressView.trackTintColor = UIColor(red: 0.847, green: 0.847, blue: 0.847, alpha: 1)
//        habitsProgressView.trackTintColor = .purple
        habitsProgressView.progressTintColor = .purple
        habitsProgressView.layer.cornerRadius = 5
        habitsProgressView.clipsToBounds = true
//        habitsProgressView.progress = HabitsStore.shared.todayProgress
        habitsProgressView.progress = HabitsStore.shared.todayProgress
        
        habitsProgressView.translatesAutoresizingMaskIntoConstraints = false
        return habitsProgressView
    }()
    
    public func updateProgress() {
        habitsProgressView.setProgress(HabitsStore.shared.todayProgress, animated: true)
        habitsProgressPercent.text = "\(Int(HabitsStore.shared.todayProgress * 100))%"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Actions
extension ProgressCollectionViewCell {
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            habitsProgressBackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            habitsProgressBackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            habitsProgressBackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            habitsProgressBackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            habitsProgressTitle.topAnchor.constraint(equalTo: habitsProgressBackView.topAnchor, constant: 10),
            habitsProgressTitle.leadingAnchor.constraint(equalTo: habitsProgressBackView.leadingAnchor, constant: 10),
            
            habitsProgressPercent.topAnchor.constraint(equalTo: habitsProgressBackView.topAnchor, constant: 10),
            habitsProgressPercent.trailingAnchor.constraint(equalTo: habitsProgressBackView.trailingAnchor, constant: -10),
            
            habitsProgressView.leadingAnchor.constraint(equalTo: habitsProgressBackView.leadingAnchor, constant: 10),
            habitsProgressView.trailingAnchor.constraint(equalTo: habitsProgressBackView.trailingAnchor, constant: -10),
            habitsProgressView.bottomAnchor.constraint(equalTo: habitsProgressBackView.bottomAnchor, constant: -15),
            habitsProgressView.heightAnchor.constraint(equalToConstant: 7)
        ])
    }
}
