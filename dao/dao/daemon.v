module dao

import net.websocket

// Server: gets instructions from browser executes code returns responses.
// Response: the server responds in two ways, either:
// - a markdown file detailing the result of an action is returned to be displayed
// - a signature request is returned to execute a blockchain tx.

struct Daemon {
pub mut:
	ws_server websocket.Server
	ws_client websocket.Client
}

// TODO: to be implemented with action parser
pub fn handler(action string) ?bool {
	return true
}

// TODO: implement logic
// returns to client a markdown response on the result of the action executed
pub fn (mut d Daemon) respond(response string) ?bool {
	d.ws_client.write_string(response) ?
	return true
}
