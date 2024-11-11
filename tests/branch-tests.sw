(check 42 (if T 42))
(check _ (if F 42))

(check 1 (if-else T 1 2))
(check 2 (if-else F 1 2))