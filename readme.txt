* This is a working, although limmited, 2d physics engine writtin in ruby. It was how I learned ruby, and I'm proud of it. That said, it has no testing, serious structural flaws, and fundemental missunderstanding of what phsyics engines are supposed to be. I've completely abandonded this version and started on [Twelve Volt](https://github.com/MrAaronOlsen/twelve_volt) instead.

Nine Volt

	A very basic game engine for Ruby for use with Gosu

	Gosu is REQUIRED!

Description

	I discovered vectors and decided I'd just embrace that can of worms. One thing led to another and I decided I wanted to collide things. That can of worms led me to creating this physics engine. This project will likely never be more than my personal learning environment. It's simple, not very practical, and will never have very good documention. With that said, There are Ruby examples of Vectors, Shape and Body creation, AABB testing, SAT collision detection, and MTV reflection responce. I certainly didn't find many examples myself...

V 0.1

	- Points Class
		- Holds location and displacement information.

	- Part Class
		- Can create circles, segments, and rectangles.
		- Holds velocity and acceleration information.

	- Group Class
		- Holds parts to be moved together.

	- Body Class
		- Holds groups to be moved together.

	- All Bodies, Groups, Parts, and Points move as they should. That is, by moving a Body location all Groups, then all Parts move as one.

	- All Bodies, Groups, Parts, and Points rotate as they should. If a Body is rotated then all Groups and it's Parts rotate as if it were a picture. Same goes for rotating a Group, or just a Part.

	- All Bodies, Groups, Parts, and Points center. After building a Body with Groups or Parts, everything can be centered based on the Body's location.

	- All Bodies, Groups, Parts, and Points originate. After building a Body with Groups or Parts, everything can be un centered to it's origination state.

	- Vector Class
		- Does everything a vector class should do.

	- BBox Class
		- Generic enough that all Body, Group, and Part classes can have one. Nice for optimization.
		- Holds axis aligned sides and center information.

	- Collision Class
		- Only detects a circle Shape vs a Body holding Segments or Rectangles.
		- But it works.
		- Holds the magnitude vector of the collision face and the minimum translation vector.

	- Methods
		- Where I put stuff that has no home.
		- Vector related stuff that returns scalars, dot products, and radian/degree stuff
		- BBox testing methods
		- Reflecting velocity vectors

	- Next Step

		- Circles with a velocity vector magnitude greater than it's radius are in danger of going through walls. Implement a sweep test for these sorts of things, keeping other shape collisions in mind...
		- Update Collision class to except any obj vs obj. That is, Body vs Body, Group vs Body, Part vs Group, etc... Regardless, final check is always a part vs part. So this should be easy...
		- Find homes for stuff is Methods Class.

	- Longer Term

		- Add triangles. Then maybe filled in circles?
		- Add circle vs circle, seg vs seg, seg vs rect, and rect vs rect collision detection.
		- Add velocity related stuff to Body and Groups so they can all be moved independently.

	- Even Longer Term

		- Add data structures for responce of both objects on collision. This will allow forces to finally be useful.

V 0.15

	- Groups Class - Depreciated.
		- Wasn't going to play nice with messaging structure.

	- Part Class
		- Fixed segments, which were not being initialized at origin.
		- Removemed all independent movement options. Now relies soley on Body for movement.

	- Body Class - Updated
		- Accepts Movement Class.
		- Manages it's own responce to a Collision, or future events.

	- Movement Class - Added
		- Holds all movement data for Body, allowing Body to manage it's own movement based on events.

	- Space Class - Added
		- Holds Bodies that are to be Collision tested against each other.
		- Acts as the main controller, updating, testing, and drawing all added Bodies.

	- Collision Class - Updated
		- Is still a mess, but dependencies are at least reduced.
		- Collision visual tests added.
		- Fixed Ball vs Poly corner issue.
		- Fixed Minimum Translation Vector (is now actually a minimum translation vector).
		- Added Ball vs Ball test.

	- Test Class
		- Mostly for me. Not planning on keeping long term.
		- Allows data to be printed or drawn at any point along cycle chain.

	- Next Step
		- Add triangles and filled in ball.
		- Add Poly vs Poly Collision Test. Would be nice if this could handle segs, rects, and tri.
		- Clean up Collision Testing.
		- Clean up Body Responce, or move to own class, or something. It seems wrong hanging out it the Body Class.

	- Longer Term
		- Add forces.

V 0.2

	- Point Class - Updated
		- Points now hold mass, defaulted to 1. This is used to calculate centroid in Part.

	- Shape Class - Update
		- Added triangle.
		- Added filled-in circle.

	- Part Class - Updated
		- Added centroid which is center of gravity. Center no longer tied to bounding box.
		- Can now add Material to parts.

	- Body Class - Updated
		- Is getting a little messy.
		- Now holds all movement info.
		- Added force responce to mass.
		- Movement is now acceleration bassed.
		- Can now add Bindings.
		- Added rules: collided, grounded, resting.
		- Can add Material to overide all Part Materials

	- Space Class - Updated
		- Now accepts Environment

	- Movement Class - Depreciated
		- All movement now held in Body.

	- Collision Class - Updated
		- Is still a mess, but a little cleaned up.

	- Physics Class - Created
		- Holds Impulse calculation

	- Binding Class - Created
		- Holds binding information for Body.
		- Binding(key press, action, rule).

	- Material Class - Created
		- Holds friction and bounce forces

	- Environment Class - Created
		- Holds gravity and drag forces

	- Ruby Class - Created
		- Holds some handy Ruby shortcuts

	- Next Step
		- Add call back functions to detect collisions and respond to them

	- Longer Term
		- Add Poly vs Poly Collision Test.
		- Add Rotation Forces

	V 0.25

	- Cleaned up and refactored all Classes

	- Space Class - Updated
		- Only true collision queries are now sent to Body responce handlers.

	- Body Class - Updated
		- Created a history that holds Manifold class.
		- Resting state determined by incrementally reducing gravity on objects.
			in constant contact with another body until force of gravity becomes 0.
		- Refactored like heck. Looking better now. Still messy though.

	- Bindings Class - Depreciated
		- Starting over with this. Didn't like how it was playing out.

	- Manifold Class - Created
		- Main class for holding info about collisions.
		- Will hopefully become main callback for manipulating collision responces.

	- Physics Module - Updated
		- Now a Module.
		- Tweeked impulse vector to behave better.
		- Moved minimum translation vector here. Tweeked this too.

	- Next Step
		- Start from scratch on twelve-volt...
