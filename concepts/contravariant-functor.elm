-- Inspired by: https://www.schoolofhaskell.com/school/to-infinity-and-beyond/pick-of-the-week/profunctors


module ContravariantFunctor exposing (..)

-- Let's define a type alias for predicate functions.


type alias Predicate a =
    a -> Bool



-- Now let's add an example of this type.


large : Predicate Int
large n =
    n > 10



-- We can compose this predicate function with other functions.


length : String -> Int
length =
    String.length


long : Predicate String
long str =
    str
        |> length
        |> large



-- We can write this more compact using the composition operator.


long2 : Predicate String
long2 =
    length >> large



-- We turned a Predicate Int into a Predicate String!
-- This looks a bit like calling map with a function on a List or Maybe.
-- Let's try to write such a map function.


map : (b -> a) -> Predicate a -> Predicate b
map fn predicate =
    fn >> predicate



-- We can now use this map function to implement long.


long3 : Predicate String
long3 =
    map length large



-- The type signature of map tells us Predicate is a contravariant functor.
-- An ordinary (covariant) functor's map has a type signature like this:
--     (a -> b) -> Functor a -> Functor b
-- List and Maybe are good examples of that.
-- For a contravariant functor's map, a and b are flipped:
--     (b -> a) -> Functor b -> Functor a
