module dao

import time
import json
import freeflowuniverse.crystallib.texttools

// dao pools are done per currency
// they group money on behalf of users in the DAO
[heap]
pub struct Treasury {
pub mut:
	assets  map[string]int      // map of assets (such as currencies) and amount of each
	modtime time.Time           // timestamp of last calculation
	wallets map[string]&TWallet // wallets contributing to the treasury, mapped by account addr
	account &Account // Account of the treasury, where money is sent and received
}

// money kept for an account, not in pool, they key is the public key of account
// is like your private wallet on top of your treasury
[heap]
pub struct TWallet {
pub mut:
	account  &Account       // pointer to account who owns position
	assets   map[string]f64 // map of assets (such as currencies) and amount of each
	modtime  time.Time
	modified bool = true
}

// creates treasury wallet
fn (mut t Treasury) create_wallet(account &Account) ?&TWallet {
	new_wallet := TWallet{
		account: account
		assets: map[string]f64{}
		modtime: time.now()
		modified: true
	}
	t.wallets[account.address] = &new_wallet
	return &new_wallet
}

// get wallet information, is from your wallet on the DAO Treasory
// args
// - currency string
// - account &Account
fn (mut t Treasury) get_wallet(account &Account) &TWallet {
	if account.address in t.wallets {
		return t.wallets[account.address]
	} else { // creates new wallet if wallet doesn't exist
		new_wallet := TWallet{
			account: account
			assets: map[string]f64{}
			modtime: time.now()
			modified: true
		}
		t.wallets[account.address] = &new_wallet
		return &new_wallet
	}
}

// updates wallet assets and modification variables
fn (mut wallet TWallet) transaction(asset string, amount f64) {
	wallet.modified = true
	wallet.assets[asset] += amount
	wallet.modtime = time.now()
}

// send money to your personal wallet on the DAO treasury
// should only run after tx to treasury is confirmed
// this money you can freely been redraw
// from here you can bring the money to the DAO Pool but then certain rules are in place
//```args
// 	currency string
// 	account &Account
// 	amount f64
//```

// TODO: to be implemented
// uses stellar api to confirm transaction to/from treasury
pub fn (mut dao DAO) confirm_tx(account Account, transaction Transaction) ?bool {
	return true
}

// send money to your personal wallet on the DAO treasury
// should only run after tx to treasury is confirmed
// this money you can freely been redraw
// from here you can bring the money to the DAO Pool but then certain rules are in place
//```args
// 	currency string
// 	account &Account
// 	amount f64
//```
pub fn (mut dao DAO) twallet_deposit(args FundingArgs) ?&TWallet {
	// TODO: implement function to request tx from client
	// server.request_tx('send', json.encode(args))

	mut twallet := dao.treasury.get_wallet(args.account)
	twallet.transaction(args.currency, -args.amount)
	return twallet
}

// withdraw money from your wallet and end back to your personal account where the money came from
// important for now we only support sending money back to blockchain account who put the money in
//```args
// 	currency string
// 	account &Account
// 	amount f64
//```
pub fn (mut dao DAO) twallet_withdraw(args FundingArgs) ?&TWallet {
	// TODO: have validators cosign withdrawal tx

	// deducts withdrawn amount from treasury wallet
	mut twallet := dao.treasury.get_wallet(args.account)
	twallet.transaction(args.currency, -args.amount)
	return twallet
}
