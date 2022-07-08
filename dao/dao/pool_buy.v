module dao

import time

// returns info about what result of order would be, but does not execute it
pub struct BuyOrderInfo {
pub mut:
	currency       string
	tokenprice_usd f64
	orderprice_usd f64
	usd_before     f64
	usd_after      f64
	tokens_before  f64
	tokens_after   f64
}

// simulate a buy order and return info as follows:
// ```
// pub struct BuyOrderInfo {
// 	currency       string
// 	tokenprice_usd f64
// 	orderprice_usd f64
// 	usd_before     f64
// 	usd_after      f64
// 	tokens_before  f64
// 	tokens_after   f64
// }
// ```
pub fn (mut lp Pool) buy_info(args FundingArgs) ?BuyOrderInfo {
	// TODO: we need to do decent check here that buy is possible, is there enough money on the accounts
	return BuyOrderInfo{
		currency: lp.currency
		tokenprice_usd: lp.usdprice_buy
		orderprice_usd: args.amount / lp.usdprice_buy
	}
	// TODO: need to fill in before & after
}

// this allows a user to buy a chose currency
// e.g. dao.buy(buy(currency:"tft", account:kristof, amount:1000)?
//		this means kristof is buying 1000 tft, this needs to come from his personal account, if not there will fail
// account is Account object
pub fn (mut dao DAO) buy(args LPOrderArg) ?BuyOrderInfo {
	mut poolusd := dao.pool_get('usdc')?
	mut lp := dao.pool_get(args.currency)?

	poolusd.calculate()?
	lp.calculate()?

	poolusd.modtime = dao.time_current
	lp.modtime = dao.time_current

	usdneeded := args.amount / lp.usdprice_buy // money as paid for by the customer, needs to be given to the pool in usd
	currencyreceive := args.amount // documentation purpose, is the currency the user is buying & amount

	// this should always be there, because has been initialized that way
	mut buyer_private_account_usd := poolusd.wallets[args.account.address]
	buyer_private_account_usd.amount -= usdneeded

	for key, mut p in lp.wallets_pool {
		// TODO: need to do a check in advance that its possible maybe not enough money
		p.amount -= currencyreceive / p.poolpercentage // deduct the bought currency in percentage from all account wallets
		mut posusd := poolusd.wallets_pool[key] // add the usd coming in to all the usd accounts in same percentage
		posusd.amount += usdneeded / p.poolpercentage
	}

	poolusd.calculate()?
	lp.calculate()?

	return lp.buy_info(args)
}
