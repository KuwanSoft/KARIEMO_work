=begin

[[item.kind, item.id],true,id,false,stack#, magic_hash]は

        [0]      [1]      [2]         [3]         [4]        [5]

[[種類、ID],鑑定済み,装備箇所,呪われている,スタック数,MagicHash]のフラグ

装備箇所 1:主武器 2:補助武器or盾 3:鎧 4:兜 5:脚鎧 6:腕鎧

7:その他1 8:その他2  装備無しは[2]の値は"0"となる。

when 8 # 北向き
when 6 # 東向き
when 2 # 南向き
when 4 # 西向き

Debug::write(c_m,"param:#{valiable}")

コメント
-- 1行コメントは「#」のあとに書く
--「=begin」から「=end」の間がコメントになる
__END__
-- この行以降すべてがコメントになる

クラス名の命名規則
キャメルケース（CamelCase）:
Rubyのクラス名は通常、キャメルケース（またはアッパーキャメルケース）で書かれます。これは各単語の最初の文字を大文字にし、単語間のスペースを省略する書き方です。
例: MyClass, UserAccount, XMLParser

モジュール名の命名規則
各単語の最初の文字は大文字にします。
単語間にスペースやアンダースコアは使わず、単語を連続させます。
例
Math：Rubyの標準ライブラリの一つ。
Enumerable：Rubyのミックスインとしてよく使用されるモジュール。
FileUtils：ファイル操作を行うためのメソッドを提供するモジュール。

その他の命名規則
メソッド名や変数名:
メソッド名や変数名はスネークケース（snake_case）で書かれることが一般的です。これは全ての文字を小文字にし、単語間をアンダースコア（_）でつなぐ書き方です。
例: calculate_age, default_value, print_hello_world

定数:
定数は全て大文字のスネークケースで書かれます。単語間はアンダースコアでつなぎます。
例: MAX_LIMIT, DEFAULT_SIZE

ファイル名:
Rubyのファイル名はスネークケースで書かれることが多いです。例えば、my_classクラスを定義するファイル名はmy_class.rbになります。

ローカル変数とインスタンス変数
スネークケース（snake_case）:
ローカル変数とインスタンス変数は通常、スネークケースで命名されます。これは全て小文字で、単語間をアンダースコア（_）でつなぐ書き方です。
例: item_count, database_connection, first_name

グローバル変数
グローバル変数:
グローバル変数は $ で始まり、スネークケースで命名されることが一般的です。
例: $application_status, $default_path

クラス変数
クラス変数:
クラス変数は @@ で始まり、スネークケースで命名されます。
例: @@instance_count, @@default_settings

定数
定数:
定数は全て大文字のスネークケースで命名されます。単語間はアンダースコアでつなぎます。
例: MAX_LIMIT, DEFAULT_URL

シンボル
シンボル:
シンボルも通常はスネークケースで命名されます。
例: :user_name, :http_status

Version2.rvdataの形式は4つの値を持つhash値である。
data_hash[:ver]
data_hash[:date]
data_hash[:build]
data_hash[:uniqueid]
=end
