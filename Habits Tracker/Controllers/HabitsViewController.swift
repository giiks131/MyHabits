
import UIKit

class HabitsViewController: UIViewController {
    
    private let scrollView = UIScrollView()
//    private var habitsTableView = UITableView(frame: .zero, style: .grouped)
    
//    enum CellReuseID: String {
//        case `default` = "TableViewCellReuseID"
//    }
    
    private lazy var habitCollectionView: UICollectionView = {
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1)
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: ProgressCollectionViewCell.id)
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: HabitCollectionViewCell.id)

        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1)
        self.navigationItem.title = "Сегодня"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        habitCollectionView.dataSource = self
        habitCollectionView.delegate = self
        
        
        navigationController?.navigationBar.prefersLargeTitles = true
//        self.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .purple
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.shadowColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.29)
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain,target: self, action: #selector(didTapButton))
        
        setupViews()
        self.habitCollectionView.reloadData()
    }
    
    
    private func setupViews() {
        view.addSubview(habitCollectionView)
        
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
//            habitCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
//            habitCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//            habitCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -17),
//            habitCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -22),
//            habitCollectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            habitCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            habitCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            habitCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            habitCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            habitCollectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            
        
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func didTapButton() {
        let rootVC = HabitViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalTransitionStyle = .coverVertical
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
//        navigationController?.pushViewController(navVC, animated: true)
    }
}


//extension HabitsViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if (section == 0) {
//            return 1
//        } else {
//            return 1
//        }
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return
//    }
//}

extension HabitsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var returnValue = Int()

            if section == 0 {
                returnValue = 1

            } else if section == 1 {
                returnValue = HabitsStore.shared.habits.count

            }

            return returnValue
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
//
            let cell = habitCollectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.id, for: indexPath) as! ProgressCollectionViewCell
        
            cell.updateProgress()
            return cell
        } else {
            let cell = habitCollectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionViewCell.id, for: indexPath) as! HabitCollectionViewCell
            var sortHabitArray = HabitsStore.shared.habits
            sortHabitArray.sort(by: {stripTime(from: $0.date) < stripTime(from: $1.date)})
            cell.configure(habit: sortHabitArray[indexPath.item])
            
            cell.habitTrackCircleAction = { [weak self] in
                if sortHabitArray[indexPath.item].isAlreadyTakenToday {
                    return
                }
                else {
                    let habit = sortHabitArray[indexPath.item]
                    HabitsStore.shared.track(habit)
                }
                self?.habitCollectionView.reloadData()
            }
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        if indexPath.section == 1 {
            let rootVC = HabitDetailsViewController()
            rootVC.habitIndex = indexPath.item
//            HabitsStore.shared.habits.removeAll()
            navigationController?.pushViewController(rootVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var returnValue = CGSize()
        let paddingWidth = collectionView.frame.width - 32
        
        if indexPath.section == 0 {
            returnValue = CGSize(width: paddingWidth, height: 60)
        } else {
            returnValue = CGSize(width: paddingWidth, height: 130)
        }
//         if indexPath.section == 0 {
//             returnValue = CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height / 3.0 - 8)
//         } else if indexPath.section == 1 {
//             returnValue = CGSize(width: collectionView.frame.size.width / 2.9 - 8, height: collectionView.frame.size.height / 2.9 - 8)
//         }

         return returnValue
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 0 {
            return UIEdgeInsets(top: 22, left: 16, bottom: 18, right: 16)
        } else {
           return UIEdgeInsets(top: 0, left: 16, bottom: 12, right: 16)
        }
    }
    }

extension HabitsViewController {
    
    func reloadView() {
        self.habitCollectionView.reloadData()
    }
}
