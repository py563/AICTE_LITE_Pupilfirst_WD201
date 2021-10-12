def get_command_line_argument
  # ARGV is an array that Ruby defines for us,
  # which contains all the arguments we passed to it
  # when invoking the script from the command line.
  # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines
dns_raw = File.readlines("zone")

# method parses and sythenises dns records from zone file.
def parse_dns(dns_raw)
  dns_records_hash = {}
  # loop through each line in the file expect for empty lines and comments,
  dns_raw.each { |line|
    if line[0] != "\n" && line[0] != "#"
      line_split = line.split(", ")
      line_split[2] = line_split[2].strip # remove newline
      # building a hash where :type stores dns record type like A or CNAME,
      # :target store ip address or domain name
      # with key as alias or domain name of that particular record
      dns_records_hash[line_split[1]] = { :type => line_split[0], :target => line_split[2] }
    end
  }
  return dns_records_hash
end

# method resolves user queried domain's DNS value using recursion and returns it
def resolve(dns_records_hash, lookup_chain_data, queried_domain)
  # looking up the domain name in the hash
  queried_record = dns_records_hash[queried_domain]
  if (!queried_record)
    lookup_chain_data << "ERROR: record not found for " + queried_domain
  elsif queried_record[:type] == "CNAME"
    # push to stack aka recursively calls itself with the new domain name
    lookup_chain_data.push(queried_record[:target])
    resolve(dns_records_hash, lookup_chain_data, queried_record[:target])
  elsif queried_record[:type] == "A"
    # push ip address to lookup chain data and return
    lookup_chain_data.push(queried_record[:target])
  else
    # edge case for ex: nameserver or mx records
    lookup_chain_data << "ERROR: invalid record type for " + queried_domain
  end
end

# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
