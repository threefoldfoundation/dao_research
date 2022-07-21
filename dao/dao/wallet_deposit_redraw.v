module dao

import time

struct WalletArgs {
	currency string
	account  &Account
	ispool   bool
}
