module liquidity

import time

[heap]
pub struct LPPool {
pub mut:
	assets       []LPAsset
	accounts     []LPAccount
	path         string // location where pool info is being stored
	orders       []LPOrder
	time_current time.Time
	last_asset   i64
	last_order   i64
	last_account i64
}

fn (mut lp LPPool) save() ? {
}

// set the a time, important to be able to simulate
//  "YYYY-MM-DD HH:mm:ss" format
pub fn (mut lp LPPool) time_set(now string) ? {
	lp.time_current = time.parse(now)?
}

pub fn (mut lp LPPool) time_add_seconds(secs int) {
	lp.time_current = lp.time_current.add_seconds(secs)
}
