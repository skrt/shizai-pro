# UUID v7 generator (RFC 9562)
# Time-sortable UUID with millisecond precision timestamp + random bits
module UUIDv7
  def self.generate
    timestamp_ms = Process.clock_gettime(Process::CLOCK_REALTIME, :millisecond)

    # 48 bits of Unix timestamp (milliseconds)
    uuid_bytes = [timestamp_ms >> 16, timestamp_ms & 0xFFFF].pack("Nn")

    # 4 bits version (0111 = 7) + 12 bits random
    random_a = SecureRandom.random_number(0x1000) | 0x7000
    uuid_bytes += [random_a].pack("n")

    # 2 bits variant (10) + 62 bits random
    random_b = SecureRandom.random_bytes(8)
    random_b.setbyte(0, (random_b.getbyte(0) & 0x3F) | 0x80)
    uuid_bytes += random_b

    # Format as standard UUID string
    hex = uuid_bytes.unpack1("H32")
    "#{hex[0, 8]}-#{hex[8, 4]}-#{hex[12, 4]}-#{hex[16, 4]}-#{hex[20, 12]}"
  end
end
