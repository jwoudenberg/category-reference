port module Main exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import Json.Encode exposing (Value)
import Test exposing (Test, describe, fuzz)
import Test.Runner.Node exposing (run, TestProgram)


-- A type is allowed to call itself a monoid if it meets two conditions:
-- 1. A function exists which returns an empty value of that type, whatever that is.
-- 2. A function exists which combines two of that type into one.
-- Let's put that information into a type, so we cannot cheat when creating monoids.


type alias MonoidDefinition monoid =
    { empty : monoid
    , concat : monoid -> monoid -> monoid
    }



-- Plenty of types are already monoids!


listMonoid : MonoidDefinition (List monoid)
listMonoid =
    { empty = []
    , concat = (++)
    }


additionMonoid : MonoidDefinition Int
additionMonoid =
    { empty = 0
    , concat = (+)
    }



-- These functions do need to adhere to some rules.


rightIdentity : MonoidDefinition monoid -> monoid -> Expectation
rightIdentity { empty, concat } anyValue =
    Expect.equal
        (concat anyValue empty)
        anyValue


leftIdentity : MonoidDefinition monoid -> monoid -> Expectation
leftIdentity { empty, concat } anyValue =
    Expect.equal
        (concat empty anyValue)
        anyValue



-- To see these rules are really simple, we replace monoid with one of our examples.
-- For instance, when using the additionMonoid, rightIdentity becomes: (x + 0) == x
-- Because these rules should hold for any monoid value we pass in,
-- This is the perfect case to write some Fuzzer tests to check our example monoids.


testMonoid : Fuzzer a -> MonoidDefinition a -> Test
testMonoid anyValue definition =
    describe "It's a monoid"
        [ fuzz anyValue "It adheres to the right identity" (rightIdentity definition)
        , fuzz anyValue "It adheres to the left identity" (leftIdentity definition)
        ]


tests : Test
tests =
    describe "Our example monoids are are legit"
        [ testMonoid (Fuzz.list Fuzz.string) listMonoid
        , testMonoid Fuzz.int additionMonoid
        ]


main : TestProgram
main =
    run emit tests


port emit : ( String, Value ) -> Cmd msg
