require 'discordrb'
require 'net/http'
require 'json'
require 'time'

bot = Discordrb::Commands::CommandBot.new token: '/* BOT TOKEN HERE*/', prefix: '-'
myriadstart = Time.at(1946702800)
myriadlast = Time.at(1946702800)

bot.message(with_text: 'ping') do |event|
	event.respond 'pong'
end

bot.ready do |event| #初期処理

	begin
	sss = JSON.parse(Net::HTTP.get(URI('http://api.patnetresort.com/myriad/next.php')))
	myriadstart = Time.parse(sss['holdAt'].to_s)
	bot.channel(441169414151471104).send("初期処理完了。 次のミリアドは、" + myriadstart.strftime("%F %T") + "です")
	rescue
	event << "エラーが発生しました。めぐみそを呼べえええええ"
	end
	nil
	end

bot.command(:help) do |event|
	event << "BlackOfInfinity Ver1.1.1 COMMAND LIST"
	event << "-myriad 次回のミリアド時間と現在の枚数を表示します。"
	event << "-lastmyriad 前回のミリアドの結果を表示します。"
	event << ""
	event << "Created by Megumiso#1210. バグ報告は左記のDiscordまで。"
end


bot.command :myriad do |event|
begin
sss = JSON.parse(Net::HTTP.get(URI('http://api.patnetresort.com/myriad/next.php')))
event << "次のミリアド: #{sss['holdAt']}"
event << "現在の枚数: #{sss['currentJp']}"
rescue
event << "エラーが発生しました。めぐみそを呼べえええええ"
end
nil
end

bot.command :debug do |event|
	debug = myriadstart.to_i - 31800
	debug4 = myriadstart - 31800
debug2 = Time.now.to_i
debug3 = Time.now
event << debug
event << debug4
event << debug2
event << debug3
end

bot.command :lastmyriad do |event| #最後のミリアドの結果
	begin
		sss = JSON.parse(Net::HTTP.get(URI('https://api.patnetresort.com/myriad/all.php')))
		myriadlast = Time.parse(sss['log'][0]['holdAt'].to_s)
		event << "前回のミリアドは、" + myriadlast.strftime("%F %T") + "です"
		event << "前回の当選者:"
		event << sss['log'][0]['winners'][0]
		event << sss['log'][0]['winners'][1]
		event << sss['log'][0]['winners'][2]
		event << sss['log'][0]['winners'][3]
		event << sss['log'][0]['winners'][4]
	rescue
		event << ""
		end
		nil
end

bot.heartbeat do |event|

	if myriadstart.to_i - 31800 <= Time.now.to_i
begin
	sss = JSON.parse(Net::HTTP.get(URI('https://api.patnetresort.com/myriad/all.php')))
#	message = ("ミリアド終了！当選者はこちら！ → " + sss['log'][0]['winners'][0] + ", " + sss['log'][0]['winners'][1] + ", " + sss['log'][0]['winners'][2])
	message = ("ミリアド終了！当選者はこちら！ → ")
	message = message + sss['log'][0]['winners'][0]
	message = message + ", " + sss['log'][0]['winners'][1]
	message = message + ", " + sss['log'][0]['winners'][2]
	message = message + ", " + sss['log'][0]['winners'][3]
	message = message + ", " + sss['log'][0]['winners'][4]
rescue

ensure
	message = message + "です！ 今回もめぐみそは当選しませんでした！"
	bot.channel(555764305648156677).send(message)
	ssss = JSON.parse(Net::HTTP.get(URI('http://api.patnetresort.com/myriad/next.php')))
	myriadstart = Time.parse(ssss['holdAt'].to_s)
	bot.channel(555764305648156677).send("次のミリアドは、" + myriadstart.strftime("%F %T") + "です")
	end
	nil
end
end


bot.run
