module liquidity

import time

pub enum OrderType {
	buy
	sell
	fund
}

pub enum OrderState {
	init
	staged //means ready for validators to pick up
	completed
	failed
}


// a

[heap]
pub struct LPOrder {
pub mut:
	id        i64
	account   string
	currency    AssetType
	ordertype  OrderType
	state  OrderState
	amount    f64
	timestamp time.Time
	message	string
}

// asset = money stored in liquitity pool, is owned by an account
pub struct LPOrderArg {
pub mut:
	account LPAccount // person who is doing the order
	currency    AssetType
	ordertype     OrderType
	amount  f64
}

// add money to the liquidity poolfor a user
pub fn (mut lp LPPool) order(o LPOrderArg) ?int {
	lp.last_order += 1
	mut order := LPOrder{
		account: o.account.address
		ordertype: o.ordertype
		currency: o.currency
		amount: o.amount
		timestamp: lp.time_current
		id: lp.last_order
	}

	asset := lp.asset_get(order.currency)?

	//user wants to buy an asset goes against USD
	if order.ordertype == OrderType.buy{

			

	}

	lp.orders << order
	return 10
}
