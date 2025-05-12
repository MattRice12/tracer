# What is Tracer?

Tracer is a script that takes a starting point and prints out all the downstream methods that are called. The goals are two-fold:
1. To increase the visibility one has for what is affected by their changes, and
2. To gather the scope of changes one will need to make if they choose to insert a new feature into existing functionality.

# Current Output
```
Call Tree:
└── class_a.rb:0 `#call`
    └── class_a.rb:16 `#call`
        ├── class_b.rb:4 `.call` (n1=Integer, n2=Integer)
        │   ├── class_b.rb:8 `#initialize`
        │   └── class_b.rb:11 `#call` (n1=Integer, n2=Integer)
        │       ├── class_d.rb:2 `.call`
        │       │   ├── class_d.rb:6 `#initialize`
        │       │   └── class_d.rb:9 `#call`
        │       └── class_b.rb:16 `#product` (n1=Integer, n2=Integer)
        ├── class_e.rb:2 `.call`
        │   ├── class_e.rb:6 `#initialize`
        │   └── class_e.rb:9 `#call`
        └── class_a.rb:22 `#sum`
```
# Author
me