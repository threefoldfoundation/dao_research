module liquidity
import time
import freeflowuniverse.crystallib.texttools

//liquidity pools are done per currency
[heap]
pub struct LPPool {
pub mut:
	currency     string	//symbol of currency
	curvalue        f64 // how much of the currency is there
	usdprice_buy  f64 //what value do we buy the currency in usd
	usdprice_sell f64 //what value do we sell the currency in usd
	usdvalue	  f64 //price calculated of how much value there is in this asset in total
	modtime     time.Time // timestamp of last calculation

	positions_pool     map[int]LPPosition   //money kept for an account in pool, they key is the id of account
	positions     map[int]LPPosition   //money kept for an account, not in pool, they key is the id of account

}

pub struct AssetPairArg {
pub mut:
	currency     	string  //e.g. usdc, tft, ...
	usdprice_buy  f64
	usdprice_sell f64
}

//set liquidity pool
pub fn (mut t Treasury) liquiditypool_set (arg AssetPairArg) ?&LPPool{
	if texttools.name_fix_no_underscore(arg.currency).to_lower() != arg.currency{
		return error("can specify currency only in lowercase and no special chars, e.g. tft, usdc, ... is ok")
	}
	if arg.currency in t.lp_pools{
		//means the liquidity pool already exists, we need multisignature
		mut lp := t.lp_pools[arg.currency]
		lp.currency = arg.currency
		lp.usdprice_sell = arg.usdprice_sell
		lp.usdprice_buy = arg.usdprice_buy
		lp.time_current = t.time_current
		lp.modtime = t.time_current
		// check that nothing weird is filled in
		asset_check(lp)?
		return &lp
	}

	mut a := LPPool{
		currency: arg.currency
		usdprice_sell: arg.usdprice_sell
		usdprice_buy: arg.usdprice_buy
		time_current: t.time_current
		modtime: t.time_current
	}
	asset_check(a)?

	t.lp_pools[arg.currency] = a

	return &a
}





// get liquidity pool
pub fn get(path string) ?LPPool {
	mut lp := LPPool{
		path: path
	}
	lp.time_current = time.now()
	lp.asset_set(currency:"usdc",usdprice_buy:1,usdprice_sell:1)?
	return lp
}


//will recalculate of all positions
pub fn (mut lp LPPool) calculate() ?{

	for at in assettypes{
		mut asset := lp.asset_get(at)?
		asset.usdvalue = 0.0
	}

	for mut fund in lp.funds{
		mut asset := lp.asset_get(fund.currency)?
		fund.usdvalue = fund.amount / asset.usdvalue
		if fund.inpool{
			asset.usdvalue += fund.usdvalue
		}

	}

	for mut fund in lp.funds{
		mut asset := lp.asset_get(fund.currency)?
		fund.usdvalue = fund.amount / asset.usdvalue
		if fund.inpool{
			asset.usdvalue += fund.usdvalue
		}

	}

}
