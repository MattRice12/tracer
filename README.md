# What is Tracer?

Tracer is a script that takes a starting point and prints out all the downstream methods that are called. The goals are two-fold:
1. To increase the visibility one has for what is affected by their changes, and
2. To gather the scope of changes one will need to make if they choose to insert a new feature into existing functionality.

# Wants

1. Print out a tree-like display to for a better visualization of the branches a service may take to execute
2. Print out the parameters the methods take
3. Distinguish between class and instance methods

# Author
me