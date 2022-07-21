module dao

import time

// asset = money stored in liqduitity pool, is owned by an account
[heap]
pub struct LPWallet {
pub mut:
	account        &Account // pointer to account who owns position
	amount         f64
	amount_funded  f64 // this is how much was funded by the user, the usdvalue is higher because of rewards of being in the pool
	modtime        time.Time
	poolpercentage f64 // expressed in 0-100 as float
	modified       bool = true
}

// updates wallet amounts and pool value
// called when user deposits or withdraws
fn (mut wallet LPWallet) transaction(amount f64) {
	wallet.modified = true
	wallet.amount += amount
	wallet.amount_funded += amount
	wallet.modtime = time.now()
}
