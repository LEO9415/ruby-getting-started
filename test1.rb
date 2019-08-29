if event.message['text']=～/おみくじ/
	message[:text] =
		["大吉","中吉","小吉","凶","大凶"].shuffle.first
end

