// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "MessageSentimentBot",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),

        // 🔵 Swift ORM (queries, models, relations, etc) built on SQLite 3.
        .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0"),

        // Telegram bot api
        .package(url: "https://github.com/Boilertalk/TelegramBot.swift.git", from: "0.3.0"),

        // PromiseKit dependency
        .package(url: "https://github.com/mxcl/PromiseKit.git", from: "6.0.0"),
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentSQLite", "Vapor", "TelegramBot", "TelegramBotVapor", "TelegramBotPromiseKit", "PromiseKit"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)
