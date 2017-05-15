require_relative '../nine_volt/body'
require_relative '../nine_volt/part'
require_relative '../nine_volt/point'

require_relative '../nine_volt/space'
require_relative '../nine_volt/environment'
require_relative '../nine_volt/material'

require_relative '../nine_volt/bbox'
require_relative '../nine_volt/collision'
require_relative '../nine_volt/manifold'
require_relative '../nine_volt/vector'

require_relative '../nine_volt/ruby'

require_relative '../nine_volt/test'

# Constants

$SLOP = 0.15 # Allows objects to overlap to help reduce resting jitter.
$IMPULSE = 0.99 # Effects the dampening of an impulse. 1 = no change in force, 0 = Objects go crazy.
$RESTING = 0.03 # Effects how fast an object enters a resting state. 0 = Never rests, 1 = Rests really fast.
$RESTITUTION = 0.4 # Effects angle of impulse reflection. 1 = perfect elestic, 0 = perfect plastic.

$HISTORY = 8 # Number of iterations for resolving collision responces. Probably don't mess with this.