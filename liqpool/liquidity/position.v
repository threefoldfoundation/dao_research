module liquidity

import time

// asset = money stored in liqduitity pool, is owned by an account
[heap]
pub struct LPPosition {
pub mut:
	id             i64
	account        int //int of the account who owns this position
	currency	   string //string of the currency of this position e.g. usdc, tft
	amount         f64
	amount_funded f64 //this is how much was funded by the user, the usdvalue is higher because of rewards of being in the pool
	timestamp      time.Time
	usdvalue       f64	
	poolpercentage f64  //expressed in 0-100 as float
	modified       bool = true
}

pub struct LPPositionArgs {
pub mut:
	account   int // person who owns the asset
	currency	   string
	amount    f64
	inpool    bool // if in pool it means that the money will be made available to pool to work with
}

// add money to the liquidity poolfor a user
pub fn (mut lp LPPool) fund(args LPPositionArgs) ?&LPPosition {
	for mut fund in lp.funds {
		if fund.account.address == args.account.address && fund.currency == args.currency
			&& fund.inpool == args.inpool {
			// this means the fund already exists for the user and in liquidity pool is matching
			fund.modified = true
			fund.amount += args.amount
			fund.amount_funded += args.amount
		}
	}
	lp.last_fund += 1
	mut a := LPPosition{
		currency: args.currency
		account: args.account
		amount: args.amount
		amount_funded: args.amount
		inpool: args.inpool
		timestamp: lp.time_current
		id: lp.last_fund
		modified: true
	}
	lp.funds << a
	return &a
}
