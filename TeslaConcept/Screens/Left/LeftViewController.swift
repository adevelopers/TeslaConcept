//
//  LeftViewController.swift
//  TeslaConcept
//
//  Created by Kirill Khudiakov on 24.09.2020.
//  Copyright © 2020 Kirill Khudiakov. All rights reserved.
//

import UIKit
import VanillaConstraints
import Combine


struct UIControlPublisher<Control: UIControl>: Publisher {

    typealias Output = Control
    typealias Failure = Never

    let control: Control
    let controlEvents: UIControl.Event

    init(control: Control, events: UIControl.Event) {
        self.control = control
        self.controlEvents = events
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, S.Failure == UIControlPublisher.Failure, S.Input == UIControlPublisher.Output {
        let subscription = UIControlSubscription(subscriber: subscriber, control: control, event: controlEvents)
        subscriber.receive(subscription: subscription)
    }
}

final class UIControlSubscription<SubscriberType: Subscriber, Control: UIControl>: Subscription where SubscriberType.Input == Control {
    private var subscriber: SubscriberType?
    private let control: Control

    init(subscriber: SubscriberType, control: Control, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        control.addTarget(self, action: #selector(eventHandler), for: event)
    }

    func request(_ demand: Subscribers.Demand) {
        // We do nothing here as we only want to send events when they occur.
        // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
    }

    func cancel() {
        subscriber = nil
    }

    @objc private func eventHandler() {
        _ = subscriber?.receive(control)
    }
}

final class LeftViewController: UIViewController {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    private lazy var trackLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(imageLiteralResourceName: "trackLocation"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var currentLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(imageLiteralResourceName: "location"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(imageLiteralResourceName: "Tesla")
        return view
    }()
    
    let viewModel: LeftViewModel
    var cancellables = Set<AnyCancellable>()
    
    
    init(viewModel: LeftViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Скорость"
        setupUI()
        setupSubscriptions()
    }
    
    var controlPublisher: ControlPublisher<UIButton>!
    
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(label)
        
        label
            .add(to: view)
            .top(to: \.topAnchor, constant: 48)
            .centerX(to: \.centerXAnchor)
        
        trackLocationButton
            .add(to: view)
            .top(to: \.bottomAnchor, of: label, relation: .equal, constant: 16, priority: .defaultHigh)
            .left(to: \.leftAnchor, constant: 16)
            .width(48)
            .height(48)
        
        currentLocationButton
            .add(to: view)
            .top(to: \.bottomAnchor, of: label, relation: .equal, constant: 16, priority: .defaultHigh)
            .left(to: \.rightAnchor, of: trackLocationButton, constant: 16)
            .width(48)
            .height(48)
        
        imageView
            .add(to: view)
            .centerY(to: \.centerYAnchor)
            .width(to: \.widthAnchor)
            .height(to: \.widthAnchor, multiplier: CGFloat(580/353))
    }
    
    @objc
    private func didTap(_ button: UIButton) {
        switch button {
        case trackLocationButton:
            viewModel.didTapTrackLocation.send()
        case currentLocationButton:
            viewModel.didTapCurrentLocation.send()
        default:
            ()
        }
    }
    
    private func setupSubscriptions() {
        
    }
    
}


class ControlPublisher<T: UIControl>: Publisher {
    typealias ControlEvent = (control: UIControl, event: UIControl.Event)
    typealias Output = ControlEvent
    typealias Failure = Never
    
    let subject = PassthroughSubject<Output, Failure>()
    
    convenience init(control: UIControl, event: UIControl.Event) {
        self.init(control: control, events: [event])
    }
    
    init(control: UIControl, events: [UIControl.Event]) {
        for event in events {
            control.addTarget(self, action: #selector(controlAction), for: event)
        }
    }
    
    @objc
    private func controlAction(sender: UIControl, forEvent event: UIControl.Event) {
        subject.send(ControlEvent(control: sender, event: event))
    }
    
    func receive<S>(subscriber: S) where S :
        Subscriber,
        ControlPublisher.Failure == S.Failure,
        ControlPublisher.Output == S.Input {
        subject.receive(subscriber: subscriber)
    }
}
