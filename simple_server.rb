require 'socket'

#parse the HTTP request and split it into an array
def parse_input(input)
	input.split(" ")
end

def response(input)
	verb = parse_input(input)[0]
	case verb
	when "GET" then get_response(input)
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

server = TCPServer.open(2000)

loop {
	client = server.accept
	input = client.recv(1024)
	client_response = response(input)
	client.puts(client_response)
	client.close
}
