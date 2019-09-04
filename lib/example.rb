require "ruspea"

code = <<~c
(def plus1
  (fn [num] (+ num 1)))
(plus1 10)
c

eleven = Ruspea::Code.new.run(code).last
puts eleven
