import sys
import itertools # to leverage `pairwise` https://docs.python.org/3/library/itertools.html#itertools.pairwise

def predict(numbers, callback):
    # if all numbers are 0, return 0. leveraging that `0` is "falsy" in Python
    # so the only situation where there would be no True/truthy elems in the number list
    # is when they're all 0
    if not any(numbers):
        return 0

    # pairwise iterate through the numbers
    # If you look at the first line in the example data:,
    # [0, 3, 6, 9, 12, 15]
    # the pairwise itertool we get ouptut like
    # `(0, 3), (3, 6), (6, 9), (9, 12), (12, 15)`
    #                   nice
    # we want the difference between each pair. So this code for `next_line`
    # would all result in: [3, 3, 3, 3, 3]
    next_line = [b - a for a, b in itertools.pairwise(numbers)] 
    # also this list comprehension syntax is ass, why do people like this language lol

    # this gets into the recursive aspect of my solution, which is probably a bit
    # hard to explain through comments lol.
    # This is also probably not a great situation to learn it because there's an
    # intermediate `callback` function here so I can easily toggle whether I'm looking
    # at the end (for p1) or at the beginning (for p2).
    return callback(numbers, next_line)

# the callback for calculating part1
# for following the recursive logic here and with the `pre` function, I think
# it's easiest to start at the end. Eventually, `predict` is going to return `0`,
# because there's that `if not any(numbers)` check at the beginning. So the next
# level up the stack, we add the final number in the list to 0. And this is carried
# up the call stack until we calculate the answer at the top level. Hopefully this
# makes some sense lol. If you don't have much exposure to recursion, it's probably
# easiest to learn it via YouTube (for visualization) and stepping through some recursive
# functions with a debugger.
def post(numbers, next_line):
    return numbers[-1] + predict(next_line, post)

def pre(numers, next_line):
    return numers[0] - predict(next_line, pre)

with open(sys.argv[1]) as f:
    sequences = [[int(char) for char in line.split()] for line in f]

    part_1 = sum([predict(seq, post) for seq in sequences])
    print(part_1)

    part_2 = sum([predict(seq, pre) for seq in sequences])
    print(part_2)
