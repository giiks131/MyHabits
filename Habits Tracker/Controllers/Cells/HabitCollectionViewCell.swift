import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    static let id = "HabitCollectionViewCell"
    var habitTrackCircleAction : (()->())?
    private lazy var habitCollectionBackView: UIView = {
        let habitCollectionBackView = UIView()
        habitCollectionBackView.layer.cornerRadius = 8
        habitCollectionBackView.backgroundColor = .white
        
        habitCollectionBackView.translatesAutoresizingMaskIntoConstraints = false
        return habitCollectionBackView
    }()
    
    private lazy var habitCollectionTitle: UILabel = {
        let habitCollectionTitle = UILabel()
        
        habitCollectionTitle.textColor = UIColor(red: 0.114, green: 0.702, blue: 0.133, alpha: 1)
        habitCollectionTitle.text = "Задача"
        habitCollectionTitle.font = UIFont(name: "SFProText-Semibold", size: 17)
        habitCollectionTitle.numberOfLines = 2
       
        habitCollectionTitle.translatesAutoresizingMaskIntoConstraints = false
        return habitCollectionTitle
    }()
    
    private lazy var habitCollectionTimeTitle: UILabel = {
        let habitCollectionTimeTitle = UILabel()
        
        habitCollectionTimeTitle.textColor = UIColor(red: 0.682, green: 0.682, blue: 0.698, alpha: 1)
        habitCollectionTimeTitle.text = "Каждый день в 7:00"
        habitCollectionTimeTitle.font = UIFont(name: "SFProText-Regular", size: 12)
        habitCollectionTimeTitle.numberOfLines = 1
       
        habitCollectionTimeTitle.translatesAutoresizingMaskIntoConstraints = false
        return habitCollectionTimeTitle
    }()
    
    private lazy var habitCollectionCountTitle: UILabel = {
        let habitCollectionCountTitle = UILabel()
        
        habitCollectionCountTitle.textColor = UIColor(red: 0.557, green: 0.557, blue: 0.576, alpha: 1)
        habitCollectionCountTitle.text = "Счетчик: 5"
        habitCollectionCountTitle.font = UIFont(name: "SFProText-Regular", size: 13)
        habitCollectionCountTitle.numberOfLines = 1
       
        habitCollectionCountTitle.translatesAutoresizingMaskIntoConstraints = false
        return habitCollectionCountTitle
    }()
    
    lazy var habitTrackButton: UIButton = {
        let habitTrackButton = UIButton()
        habitTrackButton.layer.cornerRadius = 18
        habitTrackButton.clipsToBounds = true
        habitTrackButton.layer.borderColor = UIColor.purple.cgColor
        habitTrackButton.layer.borderWidth = 1
        habitTrackButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        habitTrackButton.translatesAutoresizingMaskIntoConstraints = false
        return habitTrackButton
    }()
    
    private lazy var habitCheckMarkImageView: UIImageView = {
        let habitCheckMarkImageView = UIImageView(image: UIImage.init(systemName: "checkmark"))
        habitCheckMarkImageView.tintColor = .white
        
        habitCheckMarkImageView.translatesAutoresizingMaskIntoConstraints = false
        return habitCheckMarkImageView
    }()
    
//    @objc func habitTrackCirclePressed() {
//        habitTrackCircleAction?()
//    }
    
//    private lazy var colorLabel: UILabel = {
//        let colorLabel = UILabel()
//        colorLabel.text = "ЦВЕТ"
////        colorLabel.frame = CGRect(x: 50, y: 50, width: 50, height: 50)
//        colorLabel.backgroundColor = .systemRed
//        colorLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
//        colorLabel.textColor = .black
//        colorLabel.numberOfLines = 1
//        colorLabel.sizeToFit()
//        colorLabel.clipsToBounds = true
//        colorLabel.translatesAutoresizingMaskIntoConstraints = false
//        return colorLabel
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    public func updateProgress() {
//        habitsProgressView.setProgress(HabitsStore.shared.todayProgress, animated: true)
//        habitsProgressPercent.text = "\(Int(HabitsStore.shared.todayProgress * 100))%"
//    }
    
    func setupViews() {
        contentView.addSubview(habitCollectionBackView)
//        habitCollectionBackView.addSubview(colorLabel)
        habitCollectionBackView.addSubview(habitCollectionTitle)
        habitCollectionBackView.addSubview(habitCollectionTimeTitle)
        habitCollectionBackView.addSubview(habitCollectionCountTitle)
        habitCollectionBackView.addSubview(habitTrackButton)
        habitCollectionBackView.addSubview(habitCheckMarkImageView)
        contentView.layer.masksToBounds = true
        
        let constraints = [
            habitCollectionBackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            habitCollectionBackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            habitCollectionBackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            habitCollectionBackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            habitCollectionTitle.heightAnchor.constraint(lessThanOrEqualToConstant: 44),
            habitCollectionTitle.widthAnchor.constraint(lessThanOrEqualToConstant: 220),
            habitCollectionTitle.topAnchor.constraint(equalTo: habitCollectionBackView.topAnchor, constant: 20),
            habitCollectionTitle.leadingAnchor.constraint(equalTo: habitCollectionBackView.leadingAnchor, constant: 20),
            
//            habitCollectionTimeTitle.heightAnchor.constraint(lessThanOrEqualToConstant: 44),
            habitCollectionTimeTitle.topAnchor.constraint(equalTo: habitCollectionTitle.bottomAnchor, constant: 4),
            habitCollectionTimeTitle.leadingAnchor.constraint(equalTo: habitCollectionBackView.leadingAnchor, constant: 20),
            
            habitCollectionCountTitle.topAnchor.constraint(equalTo: habitCollectionBackView.topAnchor, constant: 92),
            habitCollectionCountTitle.leadingAnchor.constraint(equalTo: habitCollectionBackView.leadingAnchor, constant: 20),
            
            habitTrackButton.widthAnchor.constraint(equalToConstant: 38),
            habitTrackButton.heightAnchor.constraint(equalToConstant: 38),
            habitTrackButton.trailingAnchor.constraint(equalTo: habitCollectionBackView.trailingAnchor, constant: -26),
            habitTrackButton.centerYAnchor.constraint(equalTo: habitCollectionBackView.centerYAnchor),
            
            habitCheckMarkImageView.centerXAnchor.constraint(equalTo: habitTrackButton.centerXAnchor),
            habitCheckMarkImageView.centerYAnchor.constraint(equalTo: habitTrackButton.centerYAnchor),
            
//            colorLabel.leadingAnchor.constraint(equalTo: habitCollectionBackView.leadingAnchor),
//            colorLabel.topAnchor.constraint(equalTo: habitCollectionBackView.topAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
    }

}


extension HabitCollectionViewCell {

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(habit: Habit) {
        habitCollectionTitle.text = habit.name
        habitCollectionTitle.textColor = habit.color
        habitCollectionTimeTitle.text = habit.dateString
        habitCollectionCountTitle.text = "Счетчик: \(habit.trackDates.count)"
        
        if habit.isAlreadyTakenToday {
            habitTrackButton.backgroundColor = habit.color
            habitTrackButton.layer.borderWidth = 0
        } else {
            habitTrackButton.backgroundColor = .white
            habitTrackButton.layer.borderWidth = 2
            habitTrackButton.layer.borderColor = habit.color.cgColor
        }

    }
    
   @objc func buttonPressed() {
        habitTrackCircleAction?()
    }
}
