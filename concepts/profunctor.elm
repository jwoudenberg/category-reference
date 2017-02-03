module ProFunctor exposing (..)

-- Let's define a type alias for functions.


type alias Function a b =
    a -> b



-- This allows us to be really obtuse!


length : Function String Int
length =
    String.length



-- Why would you do this?
-- Merely to illustrate how -> is like any type with two parameters,
-- just like Result or Tuple.
-- And like Result or Tuple, we can map over either parameter.


mapInput : (b -> a) -> Function a x -> Function b x
mapInput mapFn fn =
    mapFn >> fn


mapOutput : (a -> b) -> Function x a -> Function x b
mapOutput mapFn fn =
    fn >> mapFn



-- The type signature of mapInput is that of a contravariant functor.
-- The type signature of mapOutput that of an ordinary (covariant) functor.
-- Having these two mapping functions makes -> a Profunctor.
