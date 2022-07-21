module dao

import time

struct FundingArgs {
	currency string
	account  &Account
	amount   f64
}

// get money from your treasury private wallet and send to the treasury pool wallet
// once money has been send to the pool you can not retrieve it, there are rules on how money can be retrieved
//```args
// 	currency string
// 	account &Account
// 	amount f64
//```
// add money to the dao poolfor a user
pub fn (mut dao DAO) pool_deposit(args FundingArgs) ?&LPWallet {
	mut twallet := dao.treasury.get_wallet(args.account) ?
	mut lpwallet := dao.pools_wallet_get(args.account, args.currency) ?


	// checks if enough funds
	if twallet.assets[args.currency] < args.amount {
		return error('Insufficient funds in treasury wallet.')
	} 

	// updates treasury wallet and lp wallet
	twallet.transaction(args.currency, -args.amount)
	lpwallet.transaction(args.amount)
	calculate()

	return lpwallet.wallet
}

// get money out of pool towards your treasury wallet
//```args
// 	currency string
// 	account &Account
// 	amount f64
//```
pub fn (mut dao DAO) pool_withdraw(args FundingArgs) ?&LPWallet {
	mut twallet := dao.treasury.get_wallet(args.account) ?
	mut lpwallet := dao.pools_wallet_get(args.account, args.currency) ?

	// checks if enough funds
	if lpwallet.assets[args.currency] > args.amount {
		return error('Insufficient funds in treasury wallet.')
	} 

	// updates treasury wallet and lp wallet
	twallet.transaction(args.currency, args.amount)
	lpwallet.transaction(-args.amount)
	calculate()

	return lpwallet.wallet
}