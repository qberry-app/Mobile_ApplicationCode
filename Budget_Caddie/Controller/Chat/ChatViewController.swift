//
//  ChatViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 10/04/25.
//

import UIKit
import SwiftUI

class ChatViewController: UIViewController {
    var hostingController: UIHostingController<ChatDetailView>?
    var chatDetailView = ChatDetailView(chatUser: ChatUser.init(uid: "user1", email: "sabin@gmail.com"))
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.closeChatPageNotification(notification:)), name: Notification.Name("closeChatPageNotificationIdentifier"), object: nil)

        // Do any additional setup after loading the view.
    }
    @objc func closeChatPageNotification(notification: NSNotification){
        dismissView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let hostingController = UIHostingController(rootView: chatDetailView)
        hostingController.view.frame = CGRect(x: 0.0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        addChild(hostingController)
        self.view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        self.hostingController = hostingController
    }
    func dismissView() {
            // Remove the hosting controller from parent
            hostingController?.willMove(toParent: nil)
            hostingController?.view.removeFromSuperview()
            hostingController?.removeFromParent()
            hostingController = nil
        self.dismiss(animated: true)
        }
}

