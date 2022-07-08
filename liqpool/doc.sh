v fmt -w liquidity
v doc -f html -m . -readme

rm -rf docs
mv _docs docs

# open https://threefoldfoundation.github.io/dao_research/liqpool/docs/liquidity.html