(import core _ ^ = check Int)

(check (= 42 42))

(check _
  (^foo [] 42)
  (foo))

(check 42
  (^foo [;Int] 42)
  (foo))
 
(check 42
  (^foo [x;Int] x)
  (foo 42))

(check 42
  (^foo [x;Int]
    (^bar [;Int] x)
    (bar))
    
  (foo 42))
