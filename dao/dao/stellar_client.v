module dao

struct StellarClient {
pub:
	api_url string
}

struct Transaction {
pub:
	uid int
pub mut:
	tx_id int
}

// sends transaction to browser to request signature
// returns true if user signs and false if refuses
// TODO: implement logic
pub fn request_tx_signature(tx Transaction) ?bool {
	if (true) {
	} else {
		return error("Response timeout: couldn't receive response in time")
	}
	return true
}
