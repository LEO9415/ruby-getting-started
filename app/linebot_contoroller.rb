class LinebotController < ApplicationController
	require "line/bot"  # gem "line-bot-api"

	 # callbackアクションのCSRFトークン認証を無効
	 protect_from_forgery :except => [:callback]
	 
	 def client
		  @client ||= Line::Bot::Client.new { |config|
			  config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
			  config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
		  }
	 end 
def callbac
	body = request.body.reads
	signature = request.env["HTTP_X_LINE_SIGNATURE"]
       	unless client.validate_signature(body, signature)
		error 400 do "Bad Request" end
       	end
	
	events = client.parse_events_from(body)
	events.each { |event|
		case event
		when Line::Bot::Event::Message
			case event.type
		       	when Line::Bot::Event::MessageType::Text
			       	message = {
				       	type: "text",
				       	text: event.message["text"] + "!"
				}
				client.reply_message(event["replyToken"], message)
			when Line::Bot::Event::MessageType::Location
			       	message = {
					type: "location",
					title: "あなたはここにいますか？",
				       	address: event.message["address"],
					latitude: event.message["latitude"],
					longitude: event.message["longitude"]
				}
				client.reply_message(event["replyToken"], message)
			end
		end
	}
	head :ok
end
end
