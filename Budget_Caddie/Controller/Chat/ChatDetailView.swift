//
//  ChatViewController.swift
//  Budget_Caddie
//
//  Created by Sabin on 10/04/25.
//


import SwiftUI
import RMQClient
struct ChatDetailView: View {
    @StateObject var vm: ChatDetailViewModel = ChatDetailViewModel()
    @Environment(\.presentationMode) var presentationMode
    var chatUser: ChatUser
    static let emptyScrollToString = "Empty"
    let conn = RMQConnection(uri: "amqp://myrabbitserver.com:1234",
                             delegate: RMQConnectionDelegateLogger())
    var channel: RMQChannel!
    init(chatUser: ChatUser) {
        self.chatUser = chatUser
    }
    
    var body: some View {
        ZStack {
            Color("secondary")
                .ignoresSafeArea()
                .onAppear {
                    vm.chatUser = chatUser
                    vm.fetchMessage()
                }
            
            VStack {
                // Cancel button aligned to top right
                HStack {
                    Spacer()
                    Button(action: {
                        NotificationCenter.default.post(name: .closeChatPageNotification, object: nil)
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(Color.red)
                            .padding(.trailing, 24)
                            .padding(.top, 16)
                    }
                }
                
                ScrollView {
                    ScrollViewReader { scrollViewProxy in
                        VStack {
                            ForEach(vm.chatMessages) { message in
                                if message.fromId == "user1" {
                                    HStack {
                                        Spacer()
                                        Text(message.text)
                                            .fontWeight(.regular)
                                            .lineSpacing(4)
                                            .font(.subheadline)
                                            .multilineTextAlignment(.trailing)
                                            .padding(16)
                                            .background(Color("primary"))
                                            .cornerRadius(16, corners: [.topLeft, .topRight, .bottomLeft])
                                            .frame(maxWidth: UIScreen.main.bounds.width * 0.70, alignment: .trailing)
                                            .foregroundColor(.white)
                                    }
                                } else {
                                    HStack {
                                        Text(message.text)
                                            .fontWeight(.regular)
                                            .lineSpacing(4)
                                            .font(.subheadline)
                                            .multilineTextAlignment(.leading)
                                            .padding(16)
                                            .background(Color.white)
                                            .foregroundColor(.black)
                                            .cornerRadius(16, corners: [.topRight, .bottomLeft, .bottomRight])
                                            .frame(maxWidth: UIScreen.main.bounds.width * 0.70, alignment: .leading)
                                        Spacer()
                                    }
                                }
                            }
                            
                            HStack { Spacer() }
                                .padding(.bottom, 100)
                                .id(Self.emptyScrollToString)
                        }
                        .padding(24)
                        .onReceive(vm.$count) { _ in
                            withAnimation(.easeOut(duration: 0.5)) {
                                scrollToBottom(proxy: scrollViewProxy)
                            }
                        }
                        .onReceive(vm.$count) { _ in
                            withAnimation(.easeOut(duration: 0.5)) {
                                scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                            }
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    chatBar
                }
            }
        }
        .navigationTitle(vm.chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        // Small delay to ensure the view has updated
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeOut(duration: 0.5)) {
                proxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
            }
        }
    }
    var chatBar: some View{
        HStack(alignment: .bottom, spacing: 16){
            if #available(iOS 16.0, *) {
                TextField("write a message...", text: $vm.chatText, axis: .vertical)
                    .padding(.leading, 16)
                    .padding(.vertical, 2)
                    .frame(minHeight: 56)
                    .background(Color("secondary"))
                    .cornerRadius(16)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
            } else {
                // Fallback on earlier versions
            }
            if(vm.chatText.isEmpty){
                HStack(spacing: 8){
                    Button{} label: {
                        Image(systemName: "camera")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(16)
                            .frame(maxWidth: 56, maxHeight: 56)
                            .background(Color("secondary"))
                            .cornerRadius(16)
                            .foregroundColor(.black)
                    }
                    Button{} label: {
                        Image(systemName: "mic")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(16)
                            .frame(maxWidth: 56, maxHeight: 56)
                            .background(Color("primary"))
                            .cornerRadius(16)
                            .foregroundColor(.white)
                    }
                }
            } else {
                Button{
                    vm.handleSend()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(16)
                        .frame(maxWidth: 56, maxHeight: 56)
                        .background(Color("primary"))
                        .cornerRadius(16)
                        .foregroundColor(.white)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(.white)
    }
    mutating func createConnection() {
        conn.start()
        self.channel = conn.createChannel()
        
    }
    func sendData() {
        if conn.isOpen() {
            let q = channel.queue("hello")
            channel.defaultExchange().publish("Hello World!".data(using: .utf8) ?? Data(), routingKey: q.name)
        }
    }
    func receive() {
        print("Attempting to connect to local RabbitMQ broker")
        let q = channel.queue("hello")
        q.subscribe({(_ message: RMQMessage) -> Void in
            print("Received \(String(data: message.body, encoding: .utf8) ?? "")")
        })
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

class ChatDetailViewModel: ObservableObject {
    @Published var chatText = ""
    @Published var chatMessages = [ChatMessage]()
    @Published var count = 0
    
    var chatUser: ChatUser?
    
    // Sample responses to simulate conversation
    private let sampleResponses = [
        "Hi there!",
        "How can I help you today?",
        "That's interesting!",
        "Tell me more about that.",
        "I understand what you mean.",
        "Let me think about that...",
        "Great question!",
        "I'm not sure I follow, could you explain?",
        "That makes sense to me.",
        "Thanks for sharing that information."
    ]
    
    func fetchMessage() {
        // Load initial sample messages
        let initialMessages = [
            ChatMessage(id: UUID().uuidString, fromId: "user2", toId: "user1", text: "Hello!", timestamp: Date().addingTimeInterval(-3600)),
            ChatMessage(id: UUID().uuidString, fromId: "user1", toId: "user2", text: "Hi there! How are you?", timestamp: Date().addingTimeInterval(-3500)),
            ChatMessage(id: UUID().uuidString, fromId: "user2", toId: "user1", text: "I'm doing well, thanks for asking. How about you?", timestamp: Date().addingTimeInterval(-3400))
        ]
        
        self.chatMessages = initialMessages
        count += 1
    }
    
    func handleSend() {
        guard !chatText.isEmpty else { return }
        
        // Create and add user message
        let userMessage = ChatMessage(id: UUID().uuidString, fromId: "user1", toId: "user2", text: chatText, timestamp: Date())
        chatMessages.append(userMessage)
        
        // Clear input
        chatText = ""
        count += 1
        
        // Simulate response after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Generate random response
            let responseText = self.sampleResponses.randomElement() ?? "I see..."
            let responseMessage = ChatMessage(id: UUID().uuidString, fromId: "user2", toId: "user2", text: responseText, timestamp: Date())
            
            // Add response message
            self.chatMessages.append(responseMessage)
            self.count += 1
        }
    }
}
