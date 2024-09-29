#!/usr/bin/sh

(
  # Benchmark getopts
  start=$(date +%s%N)
  for i in $(seq 1 1000000); do
    while getopts "a:b:c:" opt; do
      case $opt in
        a) a_val=$OPTARG ;;
        b) b_val=$OPTARG ;;
        c) c_val=$OPTARG ;;
      esac
    done
  done
  end=$(date +%s%N)
  echo "getopts time: $((end - start)) nanoseconds"
) &

(
# Benchmark awk
start=$(date +%s%N)
for i in $(seq 1 1000000); do
  echo "a=1 b=2 c=3" | awk -F' ' '{print $1, $2, $3}' > /dev/null;
done 
end=$(date +%s%N)
echo "awk time: $((end - start)) nanoseconds"
) &