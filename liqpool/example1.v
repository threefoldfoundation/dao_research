module main
import liquidity

fn simulate() ? {

	mut lp := liquidity.get("/tmp/lp")?

	lp.time_set("2022-07-05 10:10:04")?

	//need to define the basic price, in reality this can only be done by the council and needs consensus
	lp.asset_set(assettype:"tft",usdprice_buy:0.05,usdprice_sell:0.1)?


	mut kristof := lp.account_add("kristof","aabbccddeeff")?
	lp.fund(kristof,"tft",99)?
	lp.fund(kristof,"usdc",10)?
	lp.fund(kristof,.gold,1)?

	mut timur := lp.account_add("timur","aabbccddeedd")?
	lp.fund(timur,"tft",1199)?

	lp.order(account:kristof, ordertype:.buy, assettype:"tft", amount:10)?
	lp.order(account:kristof, ordertype:.sell, assettype:"tft", amount:5)?

	lp.time_add_seconds(1) //is in seconds
	lp.buy(account:timur,sell:"tft", get:"usdc",amount:10)?

	println(lp)
	

}

fn main() {
	simulate() or { panic(err) }
}
