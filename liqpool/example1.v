module main
import liquidity

fn simulate() ? {

	mut lp := liquidity.get("/tmp/lp")?

	lp.time_set("2022-07-05 10:10:04")?

	mut kristof := lp.account_add("kristof","aabbccddeeff")?
	lp.fund(kristof,.tft,99)?
	lp.fund(kristof,.usdc,10)?
	lp.fund(kristof,.gold,1)?

	mut timur := lp.account_add("timur","aabbccddeedd")?
	lp.fund(timur,.tft,1199)?

	lp.buy(account:kristof,sell:.usdc, get:.tft,amount:10)?

	lp.time_add_seconds(1) //is in seconds
	lp.buy(account:timur,sell:.tft, get:.usdc,amount:10)?

	println(lp)
	

}

fn main() {
	simulate() or { panic(err) }
}
