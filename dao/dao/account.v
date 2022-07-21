module dao

import freeflowuniverse.crystallib.texttools

// is the account on the blockchain
[heap]
pub struct Account {
pub mut:
	name       string
	address    string   // as used on blockchain, is the public key
	currencies []string // just to have pointer to currencies as used on account, easier to find liquidity pools
}

pub fn (mut dao DAO) create_account(address string, name string) ? &Account {
	name_ := texttools.name_fix(name)
	address_ := texttools.name_fix(address)

	if address in dao.accounts {
		return error('Account with adress $address already exists.')
	}

	mut account := Account{
		name: name_
		address: address_
	}

	dao.accounts[address_] = &account
	return &account
}

// make sure account exists in the dao
pub fn (mut dao DAO) account_get(address string, name string) ?&Account {
	address_ := texttools.name_fix(address)
	name_ := texttools.name_fix(name)

	if address_ in dao.accounts {
		return dao.accounts[address]
	} else {
		return error('Account with $address not found.')
	}
}
