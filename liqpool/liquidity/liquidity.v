module liquidity

// get liquidity pool
pub fn get(path string) ?LPPool {
	mut lp := LPPool{
		path: path
	}
	return lp
}
