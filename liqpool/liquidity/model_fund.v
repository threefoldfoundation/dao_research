module liquidity

import time

// asset = money stored in liqduitity pool, is owned by an account
pub struct LPFund {
pub mut:
	id        i64
	account   LPAccount // person who owns the asset
	assettype AssetType
	amount    f64
	timestamp time.Time
}

// add money to the liquidity poolfor a user
pub fn (mut lp LPPool) fund(account LPAccount, at AssetType, amount f64) ?&LPFund {
	lp.last_asset += 1
	mut a := LPFund{
		assettype: at
		account: account
		amount: amount
		timestamp: lp.time_current
		id: lp.last_asset
	}
	lp.assets << a
	return &a
}
