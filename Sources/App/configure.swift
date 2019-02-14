import FluentSQLite
import Vapor
import Foundation

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentSQLiteProvider())

    // Add custom services

    guard let telegramToken = Environment.get("TELEGRAM_TOKEN") else {
        throw ServiceError(identifier: "noApiKeyFound", reason: "No 'TELEGRAM_TOKEN' environment variable was found")
    }
    guard let botName = Environment.get("BOT_NAME") else {
        throw ServiceError(identifier: "noApiKeyFound", reason: "No 'BOT_NAME' environment variable was found")
    }
    guard let googleNLPApiKey = Environment.get("GOOGLE_NLP_API_KEY") else {
        throw ServiceError(identifier: "noApiKeyFound", reason: "No 'GOOGLE_NLP_API_KEY' environment variable was found")
    }
    let customConfigService = CustomConfigService(telegramToken: telegramToken, botName: botName, googleNLPApiKey: googleNLPApiKey)
    services.register(customConfigService, as: CustomConfigService.self)

    // End Add custom services

    /// Register routes to the router
    let router = EngineRouter.default()
    // TODO: Fix this absolute garbage
    try routes(router, customConfigService)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite database
    let sqlite = try SQLiteDatabase(storage: .memory)

    /// Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Todo.self, database: .sqlite)
    services.register(migrations)
}
