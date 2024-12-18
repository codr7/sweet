(^fib-rec [n;Int]
  (if-else (< n 2) n (+ (fib-rec (dec n)) (fib-rec (dec n)))))

(^fib-tail [n a b;Int]
  (if-else (> n 1) (return (fib-tail (dec n) b (+ a b))) (if-else (= n 0) a b)))