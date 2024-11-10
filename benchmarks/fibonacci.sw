(^fib-tail! [n a b;Int]
  (if-else (> n 1) (return (fib-tail! (dec! n) b (+ a b))) (if-else (= n 0) a b)))