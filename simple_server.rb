require 'socket'
require 'json'

#parse the HTTP request and split it into an array
def parse_input(input)
	input.split(" ")
end

def response(input)
	verb = parse_input(input)[0]
	case verb
	when "GET" then get_response(input)
	when "POST" then post_response(input)
	else
		"Sorry, unable to help!"
	end
end

def get_response(input)
	file = get_filename(input)
	if !File.exist?(file)
		return "#{error_404}"
	else
		return "#{ok_200(file)}"
	end
end

def get_filename(input)
	parse_input(input)[1].split("/").last
end

def error_404
	error_string = <<-HELLO
HTTP/1.0 404 Not Found
#{Time.now}
	HELLO
	error_string
end

def ok_200(file)
	file_contents = load_file(file)
	ok_string = <<-HELLO
HTTP/1.0 200 OK
#{Time.now}
Content-Type: text/html
Content-Length: #{File.size(file)}\r\n\r\n
#{file_contents}
HELLO
ok_string
end

def load_file(file)
	file_contents = []
	File.open("#{file}", 'r') do |line|
		while content = line.gets
			file_contents << content
		end
	end
	file_contents.join()
end

def post_response(input)
	get_params = post_params(input).last
	params = JSON.parse(get_params)
	file = get_filename(input)
	if !File.exist?(file)
		return "#{error_404}"
	else
		return "#{post_ok_200(file, params)}"
	end 
end

def post_params(input)
	input.split("\n")
end

def post_ok_200(file, params)
	return_file = File.read(file)
	data = "<li> Name : #{params['viking']['name']}</li> <li> Email : #{params['viking']['email']}</li>"
	return_file = return_file.gsub("<%= yield %>", data)
	data = <<-HELLO
HTTP/1.0 200 OK
#{Time.now}
Content-Type: text/html
Content-Length: #{File.size(file)}\r\n\r\n
#{return_file}
HELLO
data
end

server = TCPServer.open(2000)

loop {
	client = server.accept
	input = client.recv(1024)
	client_response = response(input)
	client.puts(client_response)
	client.close
}
