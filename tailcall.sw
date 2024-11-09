(import! core*)

(^ fib-tail! [n a b;Int]
  (if-else (> n 1) (return (fib-tail! (dec! n) b (+ a b)) (if-else (= n 0) a b))))
    
(say! (fib-tail! 2 0 1))