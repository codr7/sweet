(check _
  (^foo [] 42)
  (foo))

(check 42
  (^foo [;Int] 42)
  (foo))
 
(check 42
  (^foo [x Int;Int] x)
  (foo 42))

(check 42
  (^foo [x Int;Int]
    (^bar [;Int] x)
    (bar))
    
  (foo 42))
