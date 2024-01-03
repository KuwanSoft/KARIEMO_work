#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆ ファイル暗号化２ - KGC_FileEncryption2 ◆ XP/VX ◆
#_/    ◇ Last update : 2006/11/27 ◇
#_/----------------------------------------------------------------------------
#_/  『TCrypt.dll』を使用した暗号化処理を行います。
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

=begin
┏━━━━ 搭載メソッド - Methods ━━━━━━━━━━━━━━━━━━━━━━━
┠─── Module - TCrypt ───────────────────────────
┃ version()
┃   - no arguments -
┃ 『TCrypt.dll』のバージョンを整数値(Integer)で返します。
┃ Returns the version of "TCrypt.dll" by Integer.
┃
┃ encrypt(infile, outfile, key, mode[, bufsize])
┃   infile  : 入力ファイル
┃             Input file.
┃   outfile : 出力ファイル
┃             Output file.
┃   key     : 暗号化キー
┃             Encryption key.
┃   mode    : 暗号化形式
┃             Encryption mode.
┃             << 0..MKERS  1..MKES >>
┃   bufsize : バッファサイズ(省略時 : 4096Byte)
┃             Buffer size. (Default: 4096Byte)
┃ infile を暗号化して outfile に出力します。
┃ Encrypts 'infile', and outputs it to 'outfile'.
┃
┃ decrypt(infile, outfile, key, mode[, bufsize])
┃   infile  : 入力ファイル
┃             Input file.
┃   outfile : 出力ファイル
┃             Output file.
┃   key     : 暗号化キー
┃             Encryption key.
┃   mode    : 暗号化形式
┃             Encryption mode.
┃             << 0..MKERS  1..MKES >>
┃   bufsize : バッファサイズ(省略時 : 4096Byte)
┃             Buffer size. (Default: 4096Byte)
┃ infile を復号して outfile に出力します。
┃ Decrypts 'infile', and outputs it to 'outfile'.
┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
=end

$imported = {} if $imported == nil
$imported["FileEncryption2"] = true

module TCrypt
  # コードページ
  CP_UTF8 = 65001  # UTF-8

  # 暗号化モード
  MODE_MKERS = 0  # MKERS
  MODE_MKES  = 1  # MKES

  module_function
  #--------------------------------------------------------------------------
  # ○ 『TCrypt.dll』のバージョンを取得
  #     (<例> 1.23 → 123)
  #--------------------------------------------------------------------------
  def version
    begin
      api = Win32API.new("./Debug/TCrypt.dll", 'DllGetVersion', %w(v), 'l')
      ret = api.call
    rescue
      ret = -1
    end
    return ret
  end
  #--------------------------------------------------------------------------
  # ○ 暗号化
  #     infile  : 入力ファイル名
  #     outfile : 出力ファイル名
  #     key     : 暗号化キー
  #     mode    : 暗号化形式
  #     bufsize : バッファサイズ(16～1048576)
  #--------------------------------------------------------------------------
  def encrypt(infile, outfile, key, mode, bufsize = 4096)
    begin
      api = Win32API.new("./Debug/TCrypt.dll", 'EncryptA', %w(l p p p l l l), 'l')
      ret = api.call(0, infile, outfile, key, mode, bufsize, CP_UTF8)
    rescue
      ret = -1
    end
    return ret
  end
  #--------------------------------------------------------------------------
  # ○ 復号
  #     infile  : 入力ファイル名
  #     outfile : 出力ファイル名
  #     key     : 暗号化キー
  #     mode    : 暗号化形式
  #     bufsize : バッファサイズ(16～1048576)
  #--------------------------------------------------------------------------
  def decrypt(infile, outfile, key, mode, bufsize = 4096)
    begin
      api = Win32API.new("./Debug/TCrypt.dll", 'DecryptA', %w(l p p p l l l), 'l')
      ret = api.call(0, infile, outfile, key, mode, bufsize, CP_UTF8)
    rescue
      ret = -1
    end
    return ret
  end
end
