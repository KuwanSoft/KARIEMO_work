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

DEBUG::write(c_m,"param:#{valiable}")

コメント
-- 1行コメントは「#」のあとに書く
--「=begin」から「=end」の間がコメントになる
__END__
-- この行以降すべてがコメントになる
=end
