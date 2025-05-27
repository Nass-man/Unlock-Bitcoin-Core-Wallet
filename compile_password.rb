# compile_password.rb

# Define the control characters as bytes
CONTROL_CHARS = {
  em:  0x19.chr,  # End of Medium
  syn: 0x16.chr,  # Synchronous Idle
  dle: 0x10.chr,  # Data Link Escape
  dc3: 0x13.chr   # Device Control 3
}

# Prompt the user for their hex-encoded password
print "Enter your hex-encoded password: "
hex_password = gets.strip

# Convert hex to raw bytes
begin
  raw_password = [hex_password].pack("H*")
rescue
  puts "Invalid hex string."
  exit
end

# Insert control characters in the pattern:
# Pattern: <chunk1><EM><chunk2><SYN><chunk3><DLE><chunk4><DC3>
chunk_size = (raw_password.length / 4.0).ceil
chunks = raw_password.scan(/.{1,#{chunk_size}}/)

# Build the final compiled password
compiled = ""
compiled << chunks[0].to_s + CONTROL_CHARS[:em]
compiled << chunks[1].to_s + CONTROL_CHARS[:syn] if chunks[1]
compiled << chunks[2].to_s + CONTROL_CHARS[:dle] if chunks[2]
compiled << chunks[3].to_s + CONTROL_CHARS[:dc3] if chunks[3]

# Output the result
puts "\nCompiled password (non-printable chars shown):"
puts compiled.inspect
