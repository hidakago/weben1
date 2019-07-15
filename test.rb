# gem install webrickでインストールされたライブラリ「webrick」を呼び出しています。こうすることで、このRubyファイル内でWebrickが使えるようになります。
require 'webrick'

module WEBrick
  module HTTPServlet
    FileHandler.add_handler('rb', CGIHandler)
  end
end

# WEBrick::HTTPServer.newでWebrickのインスタンスを作成し、serverという名前のローカル変数に入れます。
# その際の初期値として、
#
# #DocumentRoot -> このWebアプリケーションのドメインの設定（ここに書き込まれた記述が、作成す#るWebアプリケーションのドメインになる）
#
# #CGIInterpreter -> このプログラムを実行（翻訳）できるプログラム（Rubyのこと）本体の居場所を指定する記述。'/usr/local/rvm/rubies/ruby-2.3.4/bin/ruby'とすることで、システムに入っているRubyの本体を指定して、プログラムを実行できる
#
# #Port -> このWebアプリケーションの情報の出入り口を表す設定。
#
# の、3つを設定する必要があります。
server = WEBrick::HTTPServer.new({
  :DocumentRoot => '.',
  :CGIInterpreter => WEBrick::HTTPServlet::CGIHandler::Ruby,
  :Port => '3000',
})
['INT', 'TERM'].each {|signal|
  Signal.trap(signal){ server.shutdown }
}

# そのあとに、
#
# #server.mount('/test', WEBrick::HTTPServlet::FileHandler, 'test.html')
#server.mount(”送信するURL情報”, WEBrick::HTTPServlet::FileHandler, "開きたいファイル名")
#
# #というコードを記述することで、Webサーバを起動した状態で、（DocumentRootの値）/testというURLを送信すると、同じディレクトリ階層にあるtest.htmlファイルを表示する、という機能が付与されます。
#server.mount('/', WEBrick::HTTPServlet::FileHandler, 'test.html')
#server.mount('/test', WEBrick::HTTPServlet::FileHandler, 'test.html')
server.mount('/', WEBrick::HTTPServlet::ERBHandler, 'webkadai.html.erb')
server.mount('/test', WEBrick::HTTPServlet::ERBHandler, 'test.html.erb')

# この一行を追記
server.mount('/indicate.cgi', WEBrick::HTTPServlet::CGIHandler, 'indicate.rb')

server.mount('/goya.cgi', WEBrick::HTTPServlet::CGIHandler, 'goya.rb')

server.mount('/notjika.cgi', WEBrick::HTTPServlet::CGIHandler, 'notjika.rb')
server.mount('/qualityfalse.cgi', WEBrick::HTTPServlet::CGIHandler, 'qualityfalse.rb')

#server.startはその名の通り、Webrickのサーバを起動させる、という意味のコードです。
server.start
