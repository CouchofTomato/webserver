require 'socket'

#parse the HTTP request and split it into an array
def parse_input(input)
	input.split(" ")
end

def response(input)
	verb = parse_input[0]
	case verb
	when "GET" then get_response(input)
	else
		"Sorry, unable to help!"
	end
end

def get_response(input)
	file = get_filename(input)
end

def get_filename(input)
	parse_input(input)[1].split("/").last
end

server = TCPServer.open(2000)

loop {
	client = server.accept
	input = client.recv(1024)
	#client_response = response(input)
	client.puts(input)
	client.close
}
