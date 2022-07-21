module dao

import time

// is the top struct holds everything of the DAO
// liquidity pool is just the start
[heap]
pub struct DAO {
pub mut:
	accounts     map[string]&Account
	pools        map[string]&Pool // a dao pool in line to currency
	path         string // location where pool info is being stored
	treasury     Treasury
	time_current time.Time
}

fn (mut t DAO) save() ? {
}

// get dao pool
pub fn create_dao(path string) ?DAO {
	mut t := DAO{
		path: path
	}
	t.time_current = time.now()
	t.pool_set(currency: 'usdc', usdprice_buy: 1, usdprice_sell: 1) ?
	return t
}

// set the time, important to be able to simulate
//  "YYYY-MM-DD HH:mm:ss" format
pub fn (mut d DAO) time_set(now string) ? {
	d.time_current = time.parse(now) ?
}

// move the clock, only useful in test scenarios
pub fn (mut d DAO) time_add_seconds(secs int) {
	d.time_current = d.time_current.add_seconds(secs)
}

pub fn (mut d DAO) status() string {
	mut status := 'DAO Status: \n ================ \n '

	// stringifies info about pools in DAO
	status += 'Pools:'
	for _, p in d.pools {
		status += '$p.currency: $p.curvalue \n USD Buy: $p.usdprice_buy 
		\n USD Sell: $p.usdprice_sell \n Last modified: $p.modtime'
	}

	return status
}

// used for testing and simulation, creates money out of thin air :)
pub fn (mut d DAO) fund(account &Account, currency string, amount f64) ?&TWallet {
	if account.address !in d.treasury.wallets {
		return error('Wallet for $account.name not found')
	}

	d.treasury.wallets[account.address].transaction(currency, amount)
	return d.treasury.wallets[account.address]
}
