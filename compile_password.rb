# compile_password.rb

# Define control characters
CONTROL_CHARS = {
  em:  0x19.chr,  # End of Medium
  syn: 0x16.chr,  # Synchronous Idle
  dle: 0x10.chr,  # Data Link Escape
  dc3: 0x13.chr   # Device Control 3
}

# Prompt user for hex password
print "Enter your hex-encoded password: "
hex_password = gets.strip

# Validate and decode the hex string
begin
  raw_password = [hex_password].pack("H*")
rescue
  puts "Invalid hex string."
  exit
end

# Split into 4 chunks and insert control characters
chunk_size = (raw_password.length / 4.0).ceil
chunks = raw_password.scan(/.{1,#{chunk_size}}/)

compiled = ""
compiled << chunks[0].to_s + CONTROL_CHARS[:em]
compiled << chunks[1].to_s + CONTROL_CHARS[:syn] if chunks[1]
compiled << chunks[2].to_s + CONTROL_CHARS[:dle] if chunks[2]
compiled << chunks[3].to_s + CONTROL_CHARS[:dc3] if chunks[3]

# Output both raw and hex versions
puts "\nCompiled password (raw bytes with control characters):"
puts compiled.inspect

compiled_hex = compiled.bytes.map { |b| b.to_s(16).rjust(2, '0') }.join
puts "\nCompiled password (hexadecimal form):"
puts compiled_hex
