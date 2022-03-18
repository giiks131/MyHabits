
import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = .systemGray5
        self.tabBar.tintColor = .purple
        
    
    }
    
    func setupTabBar() {
        let habitsViewController = creativeNavController(viewController: HabitsViewController(), itemName: "Привычки", ItemImage: "rectangle.grid.1x2.fill")
        let infoViewController = creativeNavController(viewController: InfoViewController(), itemName: "Информация", ItemImage: "info.circle.fill")
        viewControllers = [habitsViewController, infoViewController]

    }
    
    func creativeNavController(viewController: UIViewController, itemName: String, ItemImage: String) -> UINavigationController {
     
        let item = UITabBarItem(title: itemName, image: UIImage(systemName: ItemImage)?.withAlignmentRectInsets(.init(top: 6, left: 0, bottom: -6, right: 0)), tag: 0)
        item.titlePositionAdjustment = .init(horizontal: 0, vertical: -1)
       
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = item
        return navController
    }
}


