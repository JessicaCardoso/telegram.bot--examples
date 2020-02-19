library(telegram.bot)


update_id <- 0


main <- function(){
  # Run the bot
  
  # Telegram Bot Authorization Token
  bot <- Bot(token = bot_token("RTelegramBot"))
  
  # get the first pending update_id, this is so we can skip over it in case
  # we get an "Unauthorized" exception.
  update_id <<- tryCatch(
  {
    return (bot.get_updates()[[1L]]$update_id)
  },
  error=function(cond) {
    return(0)
  })
  

  while(TRUE){
    
    result <- tryCatch(echo(bot), error = function(c){
      msg <- conditionMessage(c)
    })
    
    if(class(result) == "try-error"){
      error_type <- attr(result,"condition")
      if("HTTP 400" %in% class(error_type)){
        Sys.sleep(1)
      }else{
        update_id <<- update_id + 1
      }
    }
  }
  
}

echo <- function(bot){
  # Echo the message the user sent.
  
  # Request updates after the last update_id
  for (update in bot$get_updates(offset=update_id, timeout=10)){
    update_id <<- update$update_id + 1
    if (length(update$message) > 0)  # your bot can receive updates without messages
      # Reply to the message
      bot$sendMessage(chat_id = update$message$chat_id, text=update$message$text)
  }
  
}

main()