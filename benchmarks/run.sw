(import! core*)

(load! (path "fibonacci.sw"))

(say! (benchmark 10000 (fib-tail! 50 0 1)))