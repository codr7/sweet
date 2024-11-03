(check 6
  (+ 1 2 3))

(check 41
  (^foo! [x Int;Int] (dec! x))
  (foo! 42))