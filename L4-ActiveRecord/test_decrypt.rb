require "aes"

puts "decrypt encrypted file"

target_file = "test-text.txt.enc"
password = "640374b88ec535db601abfbfc0c8b185"

decrypted = AES.decrypt(File.read(target_file), password)

puts decrypted
