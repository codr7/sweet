(import! core*)

(^foo [x;Int]
  (^bar [x;Int] x)
  (return (bar x)))
    
(say! (foo 42))