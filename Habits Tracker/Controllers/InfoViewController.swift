
import UIKit

class InfoViewController: UIViewController {
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        title = "Информация"
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.shadowColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.29)
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
    }
}

