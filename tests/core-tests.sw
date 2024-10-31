(import core ^ = check)

(check (= 42 42))

(check 42
  (^foo [] 42)
  (foo))
 
(check 42
  (^foo [x] x)
  (foo 42))
