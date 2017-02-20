require './body'
require './part'
require './point'

require './space'
require './binding'
require './environment'
require './material'

require './bbox'
require './collision'
require './vector'

require './ruby'

require './test'

# Constants

$SLOP = 0.99 # scaler that allows objects to overlap. Play with this to help reduce resting jitter.
$IMPULSE = 0.995 # effects force of impulse.
$RESTITUTION = 0.3 # effects angle of impulse reflection. 1 = perfect elestic, 0 = perfect plastic.

$HISTORY = 10 # Number of updates stored for Body.
$GROUNDED = 0.1 # Minimum percent pf $HISTORY an object must report a collision to be considered grounded.
$TOUCHING = 2 # Number of different collisions during an update that will trigger a resting call.
$RESTING = 0.33 # Minimum percent of $HISTORY an object must report resting to actually be considered resting.
$AVERAGE_V = 0.1 # Average velocity of body over $HISTORY to be considered no longer moving.

