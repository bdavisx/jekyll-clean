+++
title = "Fibonacci and Higher Order Functions (Ex 2.1 and 2.2)"
draft = false
date = "2016-10-28T12:29:04-05:00"

+++

I'm going to be writing about implementing exercises from ["Functional Programming in Scala" 
(FPiS))](https://www.manning.com/books/functional-programming-in-scala)
using the Kotlin language. I'm not an expert in Scala, Kotlin or Functional Programming, so feel 
free to let me know if you think there's a better way to do things. I'm trying for expressive 
code here, so I know that often it could be shorter - I'm trying to make it understandable. 
There's quite a few places I could let the compiler infer the types, but I'm making them explicit
 so it's clear to the reader. 

# Exercise 2.1 - Fibonacci
The first exercise is to write a fibonacci function that is tail recursive. The result is similar to
the Scala version. 

The `fibonacci()` function starts out by declaring a local function `loop()` that does most of the
work. On line 8, we can just return the value of the `when()` statement directly, without needing to
create a variable. The `loop()` function just counts the sequence down, adding each value as it
counts down (line 10). When it gets to 0 (line 9), it has added all of the elements together and 
returns
 the
result. The function is marked tail recursive, which was one of the points of the exercise. If the
function you create is not tail recursive and you mark it with `tailrec`, you will get a warning
from the compiler. I created a test using [Spek] (https://jetbrains.github.io/spek/), then copied
the expected values from a website.
 
{% highlight kotlin linenos %}
import org.jetbrains.spek.api.Spek
import org.jetbrains.spek.api.dsl.describe
import org.jetbrains.spek.api.dsl.it
import org.junit.Assert

fun fibonacci(n: Int): Int {
    tailrec fun loop(n: Int, previous: Int, current: Int): Int {
        return when(n) {
            0 -> previous
            else -> loop(n-1, current, previous+current)
        }
    }

    return loop(n, 0, 1)
}

class Ch02Test : Spek({
    describe("fibonacci function") {
        val expectedValues = arrayOf(0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610,
            987, 1597, 2584, 4181, 6765, 10946, 17711, 28657, 46368, 75025, 121393, 196418, 317811)

        it("should return the correct first value") {
            assertEquals(0, fibonacci(0))
        }

        it("should return the correct values in expectedValues") {
            for( i in 0..(expectedValues.size-1) ) {
                val value = fibonacci(i)
                assertEquals(expectedValues[i], value)
            }
        }
    }
})  
{% endhighlight %}

I considered an `if/else` statement in the `loop()` inner function, but I think the `when()` version
is more compact and [idiomatic](https://kotlinlang.org/docs/reference/idioms.html).
 
{% highlight kotlin linenos %}
fun fibonacci2(n: Int): Int {
    tailrec fun loop(n: Int, previous: Int, current: Int): Int {
        return if( n == 0 ) {
            previous
        } else {
            loop(n-1, current, previous+current)
        }
    }

    return loop(n, 0, 1)
}
{% endhighlight %}
 
# Exercise 2.2 - isSorted Higher Order Function

This exercise is "Implement isSorted, which checks whether an Array[A] is sorted according to a
given comparison function." We need to use a local function again to be able to be tail recursive.
The `loop()` function takes a `current` array index and if we've reached the end of the array (line
10), we return `true`, the entire array is sorted. Otherwise we check to see if the current element
is greater than the previous element. If not, we return false and short-circuit the check (line 12).
Otherwise we recursively call ourself with the next array index.

The `loop()` function has access to all of the parameters passed into the parent function. So it
does not need the array or ordered parameters to be passed to it.

Outside the local `loop()` function (line 19), we first do a check, if the array is empty, we 
just return true, otherwise we start the recursive `loop()` call. 

{% highlight kotlin linenos %}
import org.jetbrains.spek.api.Spek
import org.jetbrains.spek.api.dsl.describe
import org.jetbrains.spek.api.dsl.it
import kotlin.test.assertFalse
import kotlin.test.assertTrue

fun <A> isSorted(array: Array<A>, ordered: (A,A) -> Boolean): Boolean {
    tailrec fun loop(current: Int): Boolean {
        when(current) {
            array.size -> return true
            else -> {
                if(!ordered(array[current-1], array[current])) { return false }

                return loop(current+1)
            }
        }
    }

    if(array.size == 0) return true

    return loop(1)
}

class IsSortedTest: Spek({
    describe("isSorted function") {
        val sortedArray = arrayOf(2, 4, 6, 8, 10)
        val emptyArray = arrayOf<Int>()
        val unsortedArray = arrayOf(5,4,3)

        it("Should return true for a sorted array") {
            assertTrue(isSorted(sortedArray, { lhs, rhs -> lhs < rhs }))
        }

        it("Should return true for an empty array") {
            assertTrue(isSorted(emptyArray, { lhs, rhs -> lhs < rhs }))
        }

        it("Should return false for an unsorted array") {
            assertFalse(isSorted(unsortedArray, { lhs, rhs -> lhs < rhs }))
        }
    }
})
{% endhighlight %}

## Using a Higher Order Function with Testing

After I wrote the `fibonacci2()` function (the `if/then` version), I basically copied the test and
called `fibonacci2()` instead, then refactored the test to use a higher-order function that would
run the tests for both functions. The `runFibonacciTests()` (line 5) function takes as a parameter,
a function that gets passed and int and returns an int. That signature is the same as both of the
fibonacci functions, so we can just pass those to the function to run the tests (lines 19-20).
  
{% highlight kotlin linenos %}
class Ch02Test : Spek({
    val expectedValues = arrayOf(0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610,
        987, 1597, 2584, 4181, 6765, 10946, 17711, 28657, 46368, 75025, 121393, 196418, 317811)

    fun runFibonacciTests(function: (Int) -> Int) {
        it("should return the correct first value") {
            assertEquals(0, function(0))
        }

        it("should return the correct values in expectedValues") {
            for( i in 0..(expectedValues.size-1) ) {
                val value = function(i)
                assertEquals(expectedValues[i], value)
            }
        }
    }

    describe("fibonacci functions") {
        runFibonacciTests(::fibonacci)
        runFibonacciTests(::fibonacci2)
    }
})  
{% endhighlight %}