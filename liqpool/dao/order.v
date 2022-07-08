module dao

import time

// arguments for doing an order (can be buy or sell)
pub struct LPOrderArg {
pub mut:
	currency string
	account  &Account // person who is doing the order
	amount   f64      // amount of the currency we will buy e.g. tft
}

// returns info about what result of order would be, but does not execute it
pub struct OrderInfo {
pub mut:
	currency       string
	tokenprice_usd f64
	orderprice_usd f64
	usd_before     f64
	usd_after      f64
	tokens_before  f64
	tokens_after   f64
}

pub fn (mut lp Pool) buy_info(args LPOrderArg) ?OrderInfo {
	// TODO: we need to do decent check here that buy is possible, is there enough money on the accounts
	return OrderInfo{
		currency: lp.currency
		tokenprice_usd: lp.usdprice_buy
		orderprice_usd: args.amount / lp.usdprice_buy
	}
	// TODO: need to fill in before & after
}

// add money to the dao pool for a user
pub fn (mut dao DAO) buy(args LPOrderArg) ?OrderInfo {
	mut poolusd := dao.liquiditypool_get('usdc')?
	mut lp := dao.liquiditypool_get(args.currency)?

	poolusd.calculate()?
	lp.calculate()?

	poolusd.modtime = dao.time_current
	lp.modtime = dao.time_current

	usdneeded := args.amount / lp.usdprice_buy // money as paid for by the customer, needs to be given to the pool in usd
	currencyreceive := args.amount // documentation purpose, is the currency the user is buying & amount

	// this should always be there, because has been initialized that way
	mut buyer_posusd := poolusd.positions_pool[args.account.address]
	buyer_posusd.amount -= currencyreceive

	for key, mut p in lp.positions_pool {
		// TODO: need to do a check in advance that its possible maybe not enough money
		p.amount -= currencyreceive / p.poolpercentage // deduct the bought currency in percentage from all account positions
		mut posusd := poolusd.positions_pool[key] // add the usd coming in to all the usd accounts in same percentage
		posusd.amount += usdneeded / p.poolpercentage
	}

	poolusd.calculate()?
	lp.calculate()?

	return lp.buy_info(args)
}