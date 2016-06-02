require 'socket'
require 'json'

puts "Hello, would you like to send a GET or POST request?"
answer = gets.chomp.downcase
while !answer.eql?("get") && !answer.eql?("post")
	puts "Sorry, you need to enter either 'GET' or 'POST'"
	puts "Would you like to send a GET or POST request?"
	answer = gets.chomp.downcase
end

if answer == 'post'
	puts "Please enter your viking name:"
	viking_name = gets.chomp
	puts "Please enter your email:"
	viking_email = gets.chomp
end

viking_info = {:viking=>{:name=>"#{viking_name}",:email=>"#{viking_email}"}}
viking_info_json = viking_info.to_json
viking_info_size = viking_info_json.length

host = 'localhost'
port = 2000
get_path = "/index.html"
post_path = "/thanks.html"

get_request = "GET #{get_path} HTTP/1.0\r\n\r\n"

post_request = <<-HELLO
POST #{post_path} HTTP/1.0
Content-Length: #{viking_info_size}\r\n\r\n
#{viking_info_json}
HELLO

socket = TCPSocket.open(host,port)
if answer == 'get'
	socket.print(get_request)
else
	socket.print(post_request)
end
response = socket.read
headers,body = response.split("\r\n\r\n", 2)
print headers
print "\n"
print body
