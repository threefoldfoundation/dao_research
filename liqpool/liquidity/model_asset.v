module liquidity

import time

pub enum AssetType {
	tft
	usdc
	gold // gram of gold
}

// asset = money stored in liqduitity pool, is owned by an account
pub struct LPAsset {
pub mut:
	id        i64
	assettype AssetType
	amount    f64 //is recalculated
	timestamp time.Time //timestamp of last calculation
}

// add money to the liquidity poolfor a user
pub fn (mut lp LPPool) fund(account LPAccount, at AssetType, amount f64) ?&LPAsset {
	lp.last_asset += 1
	mut a := LPAsset{
		assettype: at
		account: account
		amount: amount
		timestamp: lp.time_current
		id: lp.last_asset
	}
	lp.assets << a
	return &a
}
