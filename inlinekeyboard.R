# Basic example for a bot that uses inline keyboards.

library(telegram.bot)



start <- function(bot, update){
  keyboard <- list(list(InlineKeyboardButton("Option 1", callback_data = 1),
                        InlineKeyboardButton("Option 2", callback_data = 2)), 
                   list(InlineKeyboardButton("Option 3", callback_data = 3)))
  reply_markup = InlineKeyboardMarkup(inline_keyboard = keyboard)
  bot$sendMessage(chat_id = update$message$chat_id, "Please choose:", reply_markup = reply_markup)
}


button <- function(bot, update){
  query <- update$callback_query
  cid <- query$message$chat$id
  mid <- query$message$message_id
  bot$editMessageText(chat_id = cid, message_id = mid, text = paste("Selected option:", query$data))
}


help <- function(bot, update){
  bot$sendMessage(chat_id = update$message$chat_id, "Use /start to test this bot.")
}


error <- function(bot, error){
  # Log Errors caused by Updates.
  warning(simpleWarning(conditionMessage(error), call = "Updates polling"))
}

updater <- Updater(token = bot_token("RTelegramBot"))

start_handler <- CommandHandler("start", start)
error_handler <- ErrorHandler(error)
help_handler <- CommandHandler("help", help)
button_handler <- CallbackQueryHandler(button)

updater <- updater + 
           start_handler + 
           button_handler +
           help_handler + 
           error_handler

updater$start_polling()
