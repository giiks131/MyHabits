import UIKit

class HabitDetailsViewController: UIViewController {
   
//    enum CellReuseID: String {
//        case `default` = "HabitDetailsViewCellID"
//    }
    var habitIndex: Int = 0
    
    var detailsTableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
//        title = "Привет"
//        self.navigationItem.largeTitleDisplayMode = .never
//        self.tabBarController?.tabBar.backgroundColor = .white
//        let navigationBarAppearance = UINavigationBarAppearance()
//        navigationBarAppearance.shadowColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.29)
//        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        view.addSubview(detailsTableView)
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        self.detailsTableView.register(HabitDetailsViewCell.self, forCellReuseIdentifier: HabitDetailsViewCell.id)
        setupViews()
        self.detailsTableView.reloadData()
//        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        var sortHabitArray = HabitsStore.shared.habits
        sortHabitArray.sort(by: {stripTime(from: $0.date) < stripTime(from: $1.date)})
        title = sortHabitArray[habitIndex].name
        self.navigationItem.largeTitleDisplayMode = .never
        self.tabBarController?.tabBar.backgroundColor = .white
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.shadowColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.29)
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .plain,target: self, action: #selector(didTapButton))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.popViewController(animated: true)
    }
    
    func setupViews() {
        
        detailsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
        
            detailsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func didTapButton() {
        let rootVC = HabitViewController()
        rootVC.backToVCDelegate = self
        rootVC.habitIndex = self.habitIndex
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalTransitionStyle = .coverVertical
        navVC.modalPresentationStyle = .fullScreen
        
       
    
//        navigationController?.pushViewController(navVC, animated: true)
        present(navVC, animated: true)
    }
}

extension HabitDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HabitsStore.shared.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.doesRelativeDateFormatting = true
        
        let habitDetailsCell = tableView.dequeueReusableCell(withIdentifier: HabitDetailsViewCell.id, for: indexPath) as! HabitDetailsViewCell
        
        let dateArray:[Date] = Array(HabitsStore.shared.dates.reversed())
        habitDetailsCell.textLabel?.text = dateFormatter.string(from: dateArray[indexPath.row])
        var sortHabitArray = HabitsStore.shared.habits
        sortHabitArray.sort(by: {stripTime(from: $0.date) < stripTime(from: $1.date)})
        if HabitsStore.shared.habit(sortHabitArray[habitIndex], isTrackedIn: dateArray[indexPath.item]) {
            habitDetailsCell.accessoryType = .checkmark
        }
        
        return habitDetailsCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "АКТИВНОСТЬ"
    }
    
}

extension HabitDetailsViewController: TransferViewController {
    func backToVCs() {
        navigationController?.dismiss(animated: true)
        navigationController?.popToRootViewController(animated: false)
            
    }
}
