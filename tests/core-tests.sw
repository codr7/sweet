(import! core _ ^ = check Int)

(check (= 42 42))

(check 3
  #1:2:3)

(check 3
  #[1 2 3])

(check _
  (^foo [] 42)
  (foo))

(check 42
  (^foo [;Int] 42)
  (foo))
 
(check 42
  (^foo [x;@] x)
  (foo 42))

(check 42
  (^foo [x;@]
    (^bar [;@] x)
    (bar))
    
  (foo 42))
