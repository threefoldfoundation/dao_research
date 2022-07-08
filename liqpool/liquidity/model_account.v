module liquidity

// is the account on the blockchain
pub struct LPAccount {
pub mut:
	name    string
	address string
}

pub fn (mut account LPAccount) save() ? {
}
