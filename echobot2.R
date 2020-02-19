library(telegram.bot)


start <- function(bot, update)
{
  # Send a message when the command /start is issued
  bot$sendMessage(chat_id = update$message$chat_id,
                  text = "Hi!")
}

help <- function(bot, update)
{
  # Send a message when the command /help is issued.
  bot$sendMessage(chat_id = update$message$chat_id,
                  text = "Help!")
}


echo <- function(bot, update){
  # Echo the user message.
  bot$sendMessage(chat_id = update$message$chat_id,
                  text = update$message$text)
}


error <- function(bot, error){
  # Log Errors caused by Updates.
  warning(simpleWarning(conditionMessage(error), call = "Updates polling"))
}


updater <- Updater(token = bot_token("RTelegramBot"))

start_handler <- CommandHandler("start", start)
error_handler <- ErrorHandler(error)
help_handler <- CommandHandler("help", help)
echo_handler <- MessageHandler(echo, MessageFilters$text)

updater <- updater + start_handler + help_handler + echo_handler + error_handler
updater$start_polling()