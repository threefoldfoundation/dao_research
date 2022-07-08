module liquidity

import freeflowuniverse.crystallib.texttools

// is the account on the blockchain
[heap]
pub struct LPAccount {
mut:
	id i64
pub mut:
	name    string
	address string // as used on blockchain
}

// add money to the liquidity poolfor a user
pub fn (mut lp LPPool) account_add(name string, address string) ?&LPAccount {
	address_ := texttools.name_fix(address)
	name_ := texttools.name_fix(name)
	for account in lp.accounts {
		if account.address == address_ {
			return error('cannot add account because is duplicate address, $address_')
		}
		if account.name == name_ {
			return error('cannot add account because is duplicate name, $name_')
		}
	}
	lp.last_account += 1
	mut lpa := LPAccount{
		name: name_
		address: address_
		id: lp.last_account
	}
	lp.accounts << lpa
	return &lpa
}

pub struct LPAccountArgGet {
pub:
	id      i64
	name    string
	address string // as used on blockchain
}

// get the account from the liquidity pool
// can get based on id, name, address
pub fn (mut lp LPPool) account_get(arg LPAccountArgGet) ?&LPAccount {
	address_ := texttools.name_fix(arg.address)
	name_ := texttools.name_fix(arg.name)
	for account in lp.accounts {
		if arg.id > 0 && account.id == arg.id {
			return &account
		}
		if address_ != '' && account.address == address_ {
			return &account
		}
		if name_ != '' && account.name == name_ {
			return &account
		}
	}
	return error('Cannot find account with find args:\n$arg')
}
