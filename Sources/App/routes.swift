import Vapor
import TelegramBot
import TelegramBotVapor

/// Register your application's routes here.
public func routes(_ router: Router, _ customConfigService: CustomConfigService) throws {
    // Telegram webhooks
    let telegramBot = TelegramReceiveApi()
    let controller = BotController(
        botName: customConfigService.botName,
        token: customConfigService.telegramToken,
        apiKey: customConfigService.googleNLPApiKey
    )

    telegramBot.messageUpdate = controller.getMessage
    telegramBot.callbackQueryUpdate = controller.getCallback

    telegramBot.setupWebhook(path: customConfigService.telegramToken, routerFunction: router.telegramRegisterAlt)
}

extension Router {

    public func telegramRegisterAlt(path: String, callback: @escaping (_ req: TelegramHTTPRequest, _ cb: @escaping (TelegramHTTPStatus) -> ()) -> ()) {
        post(path) { reqInternal -> Future<HTTPStatus> in
            let promiseStatus = reqInternal.eventLoop.newPromise(HTTPStatus.self)

            // DEBUG ONLY
            let logger = try reqInternal.make(Logger.self)
            logger.error("*** REQUEST ***")
            let body = reqInternal.http.body.data
            logger.error(body?.base64EncodedString() ?? "NIL")

            callback(reqInternal) { status in
                switch status {
                case .ok:
                    promiseStatus.succeed(result: .ok)
                case .badRequest:
                    promiseStatus.succeed(result: .badRequest)
                case .internalServerError:
                    promiseStatus.succeed(result: .internalServerError)
                }
            }

            return promiseStatus.futureResult
        }
    }
}
