declare -a bns=("insurance" "cancer" "hepar2" "alarm" "pigs" "survey" "water" "munin")
# "hailfinder" 
CMD="_build/install/default/bin/dice"
DIR="benchmarks/bayesian-networks/single_var"

for bn in "${bns[@]}"
do
	hyperfine --warmup 3 --runs 5 "$CMD $DIR/$bn.bif.dice -determinism -eager-eval"
done

