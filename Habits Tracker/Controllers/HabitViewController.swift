import UIKit

protocol TransferViewController: AnyObject {
    func backToVCs()
}

class HabitViewController: UIViewController, UITextFieldDelegate {
    
    weak var backToVCDelegate: TransferViewController?
    
    private let scrollView = UIScrollView()
    private lazy var statusText: String = "Бегать по утрам, спать 8 часов и т.п."
    
    var habitIndex: Int? = nil
    var sortHabitArray = HabitsStore.shared.habits
    
    let currentData = Date()
    var habitNumber: Int? = nil
    var habitColor: UIColor = UIColor(red: 1, green: 0.624, blue: 0.31, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Создать"
        hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.shadowColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.29)
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.tintColor = .purple
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain,target: self, action: #selector(didTapButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain,target: self, action: #selector(saveHabit))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([.font : UIFont.systemFont(ofSize: 17, weight: .semibold), .foregroundColor : UIColor.purple], for: .normal)
        setTitle()
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    private lazy var nameUpperLabel: UILabel = {
        let nameUpperLabel = UILabel()
        nameUpperLabel.text = "НАЗВАНИЕ"
        nameUpperLabel.backgroundColor = .clear
        nameUpperLabel.font = UIFont(name: "SFProText-Semibold", size: 13)
        nameUpperLabel.textColor = .black
        nameUpperLabel.numberOfLines = 1
        nameUpperLabel.sizeToFit()
        nameUpperLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameUpperLabel
    }()
    
    // ВОЗМОЖНО УБРАТЬ
//    private lazy var nameLabel: UILabel = {
//        let nameLabel = UILabel()
//        nameLabel.text = "Waiting for something..."
//        nameLabel.backgroundColor = .clear
//        nameLabel.textColor = .gray
//        nameLabel.numberOfLines = 1
//        nameLabel.sizeToFit()
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        return nameLabel
//    }()
    
    private lazy var nameTextField: UITextField = {
        let nameTextField = UITextField()
       
        nameTextField.autocorrectionType = .no
        nameTextField.font = UIFont(name: "SFProText-Regular", size: 17)
        nameTextField.backgroundColor = .white
        //        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        nameTextField.leftViewMode = .always
        //        nameTextField.layer.cornerRadius = 12
        nameTextField.textColor = UIColor.blue
        nameTextField.layer.borderWidth = 0
//        nameTextField.addTarget(self, action: #selector(statusTextChanged(_:)), for: .editingChanged)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        if habitIndex == nil {
            nameTextField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        } else {
            sortHabitArray.sort(by: {stripTime(from: $0.date) < stripTime(from: $1.date)})
            nameTextField.placeholder = sortHabitArray[habitIndex!].name
            nameTextField.text = sortHabitArray[habitIndex!].name
        }
        return nameTextField
    }()
    
    private lazy var colorLabel: UILabel = {
        let colorLabel = UILabel()
        colorLabel.text = "ЦВЕТ"
        colorLabel.backgroundColor = .clear
        colorLabel.font = UIFont(name: "SFProText-Semibold", size: 13)
        colorLabel.textColor = .black
        colorLabel.numberOfLines = 1
        colorLabel.sizeToFit()
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        return colorLabel
    }()
    
    private lazy var colorPicker: UIButton = {
        let colorPicker = UIButton()
        colorPicker.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        colorPicker.backgroundColor = .red
    
//        colorPicker.backgroundColor = UIColor(red: 1, green: 0.624, blue: 0.31, alpha: 1)
        colorPicker.layer.cornerRadius = 15
        colorPicker.addTarget(self, action: #selector(didTapSelectColor), for: .touchUpInside)
        colorPicker.translatesAutoresizingMaskIntoConstraints = false
        
        if habitIndex == nil {
            colorPicker.backgroundColor = UIColor(red: 1, green: 0.624, blue: 0.31, alpha: 1)
        } else {
            sortHabitArray.sort(by: {stripTime(from: $0.date) < stripTime(from: $1.date)})
            colorPicker.backgroundColor = sortHabitArray[habitIndex!].color
        }

        return colorPicker
    }()
    
    private lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.text = "ВРЕМЯ"
        timeLabel.backgroundColor = .clear
        timeLabel.font = UIFont(name: "SFProText-Semibold", size: 13)
        timeLabel.textColor = .black
        timeLabel.numberOfLines = 1
        timeLabel.sizeToFit()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        return timeLabel
    }()
    
    private lazy var timeText: UILabel = {
        let timeText = UILabel()
//        timeText.text = "Каждый день в " +
        timeText.backgroundColor = .clear
        timeText.font = UIFont(name: "SFProText-Regular", size: 17)
        timeText.textColor = .black
        timeText.numberOfLines = 1
        timeText.sizeToFit()
        timeText.translatesAutoresizingMaskIntoConstraints = false
        return timeText
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
       
        if habitIndex == nil {
            datePicker.date = currentData
        } else {
                sortHabitArray.sort(by: {stripTime(from: $0.date) < stripTime(from: $1.date)})
            datePicker.date = sortHabitArray[habitIndex!].date
            }
        
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.addTarget(self, action: #selector(datePickerSet), for: .valueChanged)
       
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "ru_RU")

        let date = datePicker.date
        let currentTime = dateFormatter.string(from: date)
        let attributedStringColor = [NSAttributedString.Key.foregroundColor : UIColor(red: 0.631, green: 0.086, blue: 0.8, alpha: 1)]
        let attributedString1 = NSAttributedString(string: "Каждый день в ")
        let attributedString2 = NSAttributedString(string: currentTime, attributes: attributedStringColor)
        let comboText = NSMutableAttributedString(attributedString: attributedString1)
        comboText.append(attributedString2)
        timeText.attributedText = comboText
        
        
      
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    @objc private func datePickerSet() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeStyle = .short
        let date = datePicker.date
        let currentTime = dateFormatter.string(from: date)
        let attributedStringColor = [NSAttributedString.Key.foregroundColor : UIColor(red: 0.631, green: 0.086, blue: 0.8, alpha: 1)]
        let attributedString1 = NSAttributedString(string: "Каждый день в ")
        let attributedString2 = NSAttributedString(string: currentTime, attributes: attributedStringColor)
        let comboText = NSMutableAttributedString(attributedString: attributedString1)
        comboText.append(attributedString2)
        timeText.attributedText = comboText
//        timeText.text = "Каждый день в " + currentTime
    }
    
    private lazy var buttonDelete: UIButton = {
        let buttonDelete = UIButton()
        
        if habitIndex == nil {
            buttonDelete.isHidden = true
        } else {
            buttonDelete.isHidden = false
            }
        
        buttonDelete.setTitle("Удалить привычку", for: .normal)
        buttonDelete.backgroundColor = .white
        buttonDelete.setTitleColor(UIColor(red: 1, green: 0.231, blue: 0.188, alpha: 1), for: .normal)
        buttonDelete.layer.cornerRadius = 8
        buttonDelete.addTarget(self, action: #selector(deleteHabit), for: .touchUpInside)
        
        buttonDelete.translatesAutoresizingMaskIntoConstraints = false
        return buttonDelete
    }()
    
    func setTitle() {
        if habitIndex == nil {
            title = "Создать"
        } else {
            title = "Править"
        }
    }
    
    func setupViews() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(nameUpperLabel)
//        scrollView.addSubview(nameLabel)
        scrollView.addSubview(nameTextField)
        scrollView.addSubview(colorLabel)
        scrollView.addSubview(colorPicker)
        scrollView.addSubview(timeLabel)
        scrollView.addSubview(timeText)
        scrollView.addSubview(datePicker)
        scrollView.addSubview(buttonDelete)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints  = [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            
            nameUpperLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 74),
            nameUpperLabel.heightAnchor.constraint(equalToConstant: 18),
            nameUpperLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            nameUpperLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 21),
            
//            nameLabel.widthAnchor.constraint(equalToConstant: 295),
//            nameLabel.heightAnchor.constraint(equalToConstant: 22),
//            nameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15),
//            nameLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 46),
//
            nameTextField.widthAnchor.constraint(equalToConstant: 295),
            nameTextField.heightAnchor.constraint(equalToConstant: 22),
            nameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15),
            nameTextField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 46),
            
            colorLabel.widthAnchor.constraint(equalToConstant: 36),
            colorLabel.heightAnchor.constraint(equalToConstant: 18),
            colorLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            colorLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 83),
            
            colorPicker.widthAnchor.constraint(equalToConstant: 30),
            colorPicker.heightAnchor.constraint(equalToConstant: 30),
            colorPicker.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            colorPicker.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 108),
            
            
            timeLabel.widthAnchor.constraint(equalToConstant: 47),
            timeLabel.heightAnchor.constraint(equalToConstant: 18),
            timeLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            timeLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 153),
            
            timeText.widthAnchor.constraint(greaterThanOrEqualToConstant: 194),
            timeText.heightAnchor.constraint(equalToConstant: 22),
            timeText.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            timeText.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 178),
            
            datePicker.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            datePicker.topAnchor.constraint(equalTo: timeText.bottomAnchor, constant: 15),
            datePicker.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            datePicker.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            buttonDelete.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 114.5),
//            buttonDelete.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 638),
            buttonDelete.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18),
//            buttonDelete.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            buttonDelete.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -113.5),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func didTapButton() {
//        self.dismiss(animated: true, completion: nil)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveHabit() {
        
        
        
        if habitIndex == nil {
//            nameLabel.text = String(statusText)
        let newHabit = Habit(name:"\(nameTextField.text ?? "Без названия")",
                             date: datePicker.date,
                             color: habitColor)
        HabitsStore.shared.habits.append(newHabit)
            
        } else {
            sortHabitArray.sort(by: {stripTime(from: $0.date) < stripTime(from: $1.date)})
            sortHabitArray[habitIndex!].name = nameTextField.text ?? "ERROR"
            sortHabitArray[habitIndex!].date = datePicker.date
            sortHabitArray[habitIndex!].color = habitColor
        }
        
        
        print("Status: \(nameTextField.text ?? "nil")")
        
        dismiss(animated: true, completion: nil)
//        navigationController?.popToRootViewController(animated: true)
        
        
    }
    
    @objc private func deleteHabit() {
        sortHabitArray.sort(by: {stripTime(from: $0.date) < stripTime(from: $1.date)})
        
        let alert = UIAlertController(title: "Удалить привычку",
                                      message: """
        Вы хотите удалить привычку
        "\(sortHabitArray[habitIndex!].name)"
        """,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .default, handler: {
            (action: UIAlertAction!) in
            print("Отмена was pressed")
        }))
//        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { (action: UIAlertAction!) in
//            print("Удалить was pressed")
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { [self] _ in
            print("Удалить was pressed")
            let habitIndexForDelete = HabitsStore.shared.habits.firstIndex(of: sortHabitArray[self.habitIndex!])
            if let index = habitIndexForDelete {
                HabitsStore.shared.habits.remove(at: index)
                sortHabitArray.remove(at: self.habitIndex!)
//                self.dismiss(animated: true, completion: nil)
//                dismissAllControllers()
                self.backToVCDelegate?.backToVCs()
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func dismissAllControllers() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
//        let rootVC = HabitsViewController()
//        let navVC = UINavigationController(rootViewController: rootVC)
//        navVC.modalTransitionStyle = .coverVertical
//        navVC.modalPresentationStyle = .fullScreen
//        present(navVC, animated: true)
        
    }
    
    @objc func didTapSelectColor() {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
    


extension HabitViewController: UIColorPickerViewControllerDelegate {
    
    //  Called once you have finished picking the color.
    
    //  Called on every color selection done in the picker.
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController)
    {
        habitColor = viewController.selectedColor
        colorPicker.backgroundColor = habitColor
//        nameLabel.textColor = habitColor
        
    }
}

