module dao

import time
import freeflowuniverse.crystallib.texttools

// dao pools are done per currency
[heap]
pub struct Pool {
pub mut:
	currency      string    // symbol of currency
	curvalue      f64       // how much of the currency is there
	usdprice_buy  f64       // what value do we buy the currency in usd
	usdprice_sell f64       // what value do we sell the currency in usd
	modtime       time.Time // timestamp of last calculation

	positions_pool map[string]&Position // money kept for an account in pool, they key is the public key of account
	positions      map[string]&Position // money kept for an account, not in pool, they key is the public key of account
}

pub struct AssetPairArg {
pub mut:
	currency      string // e.g. usdc, tft, ...
	usdprice_buy  f64
	usdprice_sell f64
}

// set dao pool
pub fn (mut t DAO) liquiditypool_set(arg AssetPairArg) ?&Pool {
	if texttools.name_fix_no_underscore(arg.currency).to_lower() != arg.currency {
		return error('can specify currency only in lowercase and no special chars, e.g. tft, usdc, ... is ok')
	}
	if arg.currency in t.pools {
		// means the dao pool already exists, we need multisignature
		mut lp := t.pools[arg.currency]
		lp.currency = arg.currency
		lp.usdprice_sell = arg.usdprice_sell
		lp.usdprice_buy = arg.usdprice_buy
		lp.modtime = t.time_current
		// check that nothing weird is filled in
		asset_check(lp)?
		return lp
	}

	mut a := Pool{
		currency: arg.currency
		usdprice_sell: arg.usdprice_sell
		usdprice_buy: arg.usdprice_buy
		modtime: t.time_current
	}
	asset_check(a)?

	t.pools[arg.currency] = &a

	return t.pools[arg.currency]
}

pub fn (mut t DAO) liquiditypool_get(currency string) ?&Pool {
	if currency in t.pools {
		return t.pools[currency]
	}
	return error('Cannot find liquidity pool for currency $currency')
}

// will recalculate of all positions
pub fn (mut lp Pool) calculate() ? {
	mut tot := 0.0
	for key, p in lp.positions_pool {
		tot += p.amount
	}
	for key, mut p in lp.positions_pool {
		if tot > 0 {
			p.poolpercentage = p.amount / tot
		}
	}
}

// add money to the dao poolfor a user
pub fn (mut dao DAO) fund(args PositionArgs) ?&Position {
	mut lp := dao.liquiditypool_get(args.currency)?
	mut lpusd := dao.liquiditypool_get('usdc')?

	mut p := Position{
		account: args.account
	}
	if args.inpool {
		if args.account.address in lp.positions_pool {
			p = lp.positions_pool[args.account.address]
		} else {
			lp.positions_pool[args.account.address] = &p
		}
	} else {
		if args.account.address in lp.positions {
			p = lp.positions[args.account.address]
		} else {
			lp.positions[args.account.address] = &p
		}
	}

	p.modified = true
	p.amount += args.amount
	p.amount_funded += args.amount
	p.modtime = dao.time_current

	lp.calculate()? // calculates how much percent each user has in the liquidity pool

	// check if person has also usdc account, if not need to create
	if args.account.address !in lpusd.positions_pool {
		dao.fund(currency: 'usdc', account: args.account, amount: 0, inpool: true)?
	}

	return &p
}
