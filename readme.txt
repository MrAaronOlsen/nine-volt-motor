Nine Volt

	A very basic game engine for Ruby for use with Gosu

	Gosu is REQUIRED!

Description

	I discovered vectors and decided I'd just embrace that can of worms. One thing led to another and I decided I wanted to collide things. That can of worms led me to creating this game engine. This project will likely never be more than my personal learning environment for this sort of thing. It's simple, not very practical, and will never have very good documention. With that said, There are Ruby examples of Vectors, Shape and Body creation, AABB testing, SAT collision detection, and MTV reflection responce. I certainly didn't find many examples myself...

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


