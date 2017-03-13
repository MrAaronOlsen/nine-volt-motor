require './body'
require './part'
require './point'

require './space'
require './environment'
require './material'

require './bbox'
require './collision'
require './manifold'
require './vector'

require './ruby'

require './test'

# Constants

$SLOP = 0.15 # Allows objects to overlap to help reduce resting jitter.
$IMPULSE = 0.99 # Effects the dampening of an impulse. 1 = no change in force, 0 = Objects go crazy.
$RESTING = 0.03 # Effects how fast an object enters a resting state. 0 = Never rests, 1 = Rests really fast.
$RESTITUTION = 0.4 # Effects angle of impulse reflection. 1 = perfect elestic, 0 = perfect plastic.

$HISTORY = 8 # Number of iterations for resolving collision responces. Probably don't mess with this.