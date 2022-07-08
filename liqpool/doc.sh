v fmt -w dao
v doc -f html -m . -readme

rm -rf docs
mv _docs docs

open docs/index.html

# open https://threefoldfoundation.github.io/dao_research/liqpool/docs/liquidity.html