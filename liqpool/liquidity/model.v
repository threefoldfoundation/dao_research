module liquidity

pub enum AssetType {
	tft
	usdc
	gold // gram of gold
}

pub struct LPPool {
pub mut:
	assets []LPAsset
	// location where pool info is being stored
	path string
}

pub struct LPAsset {
pub mut:
	// person who owns the asset
	account   LPAccount
	assettype AssetType
}
