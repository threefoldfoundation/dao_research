module main
import liquidity

fn simulate() ? {
	mut lp := liquidity.get("/tmp/lp")?
	println(lp)

}

fn main() {
	simulate() or { panic(err) }
}
