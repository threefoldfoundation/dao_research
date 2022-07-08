module liquidity

import time

pub struct LPOrder {
pub mut:
	id        i64
	account   string
	sell      AssetType
	get       AssetType
	amount    f64
	timestamp time.Time
}

// asset = money stored in liqduitity pool, is owned by an account
pub struct LPOrderArg {
pub mut:
	account LPAccount // person who owns the asset
	sell    AssetType
	get     AssetType
	amount  f64
}

// add money to the liquidity poolfor a user
pub fn (mut lp LPPool) buy(o LPOrderArg) ?int {
	lp.last_order += 1
	mut order := LPOrder{
		account: o.account.address
		sell: o.sell
		get: o.get
		amount: o.amount
		timestamp: lp.time_current
		id: lp.last_order
	}

	lp.orders << order
	return 10
}
