module liquidity
import time

//liquidity pools are done per currency
[heap]
pub struct Treasury {
pub mut:
	lp_pools     map[string]LPPool //a liquidity pool in line to currency
	path         		string // location where pool info is being stored
	time_current time.Time

	last_account u32
}

fn (mut t Treasury) save() ? {
}



// get liquidity pool
pub fn get(path string) ?Treasury {
	mut t := Treasury{
		path: path
	}
	t.time_current = time.now()
	t.liquiditypool_set(currency:"usdc",usdprice_buy:1,usdprice_sell:1)?
	return t
}

// set the a time, important to be able to simulate
//  "YYYY-MM-DD HH:mm:ss" format
pub fn (mut t Treasury) time_set(now string) ? {
	t.time_current = time.parse(now)?
}

//move the clock, only useful in test scenarios
pub fn (mut t Treasury) time_add_seconds(secs int) {
	t.time_current = lp.time_current.add_seconds(secs)
}

