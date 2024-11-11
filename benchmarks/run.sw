(import core*)

(load (path "fibonacci.sw"))

(say (benchmark 100 (fib-rec 20 0 1)))
(say (benchmark 10000 (fib-tail 40 0 1)))