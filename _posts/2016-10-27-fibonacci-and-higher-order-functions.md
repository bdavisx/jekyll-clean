---
title: "Fibonacci and Higher Order Functions (Ex 2.1 and 2.2)"
layout: post
date: "2016-10-28T12:29:04-05:00"
published: true
series: "Functional Programming in Scala in Kotlin"	
---

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

The {% ih kotlin %}fibonacci(){% endih %} function starts out by declaring a local function {% ih
kotlin %}loop(){% endih %} that does most of the work. On line 7, we can just return the value of
the {% ih kotlin %}when(){% endih %} statement directly, without needing to create a variable. The
{% ih kotlin %}loop(){% endih %} function just counts the sequence down, adding each value as it
counts down (line 9). When it gets to 0 (line 8), it has added all of the elements together and
returns the result. The function is marked tail recursive, which was one of the points of the
exercise. If the function you create is not tail recursive and you mark it with {% ih kotlin
%}tailrec{% endih %}, you will get a warning from the compiler. I created a test using [KotlinTest]
(https://github.com/kotlintest/kotlintest).
 
{% highlight kotlin linenos %}
import io.kotlintest.KTestJUnitRunner
import io.kotlintest.specs.FeatureSpec
import org.junit.runner.RunWith

fun fibonacci(n: Int): Int {
    tailrec fun loop(n: Int, previous: Int, current: Int): Int {
        return when(n) {
            0 -> previous
            else -> loop(n-1, current, previous+current)
        }
    }

    return loop(n, 0, 1)
}

@RunWith(KTestJUnitRunner::class)
class FibonacciTest: FeatureSpec() {
    init {
        val expectedValues = arrayOf(0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610,
            987, 1597, 2584, 4181, 6765, 10946, 17711, 28657, 46368, 75025, 121393, 196418, 317811)

        feature("fibonacci functions tested directly") {
            scenario("should return the correct first value") {
                fibonacci(0) shouldBe 0
            }

            scenario("should return the correct values in expectedValues") {
                for (i in 0..(expectedValues.size - 1)) {
                    val value = fibonacci(i)
                    value shouldBe expectedValues[i]
                }
            }
        }
    }
}
{% endhighlight %}

I considered an {% ih kotlin %}if/else{% endih %} statement in the {% ih kotlin %}loop(){% endih %}
inner function, but I think the {% ih kotlin %}when(){% endih %} version is more compact and
[idiomatic](https://kotlinlang.org/docs/reference/idioms.html).
 
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
The {% ih kotlin %}loop(){% endih %} function takes a {% ih kotlin %}current{% endih %} array index
and if we've reached the end of the array (line 10), we return {% ih kotlin %}true{% endih %}, the
entire array is sorted. Otherwise we check to see if the current element is greater than the
previous element. If not, we return false and short-circuit the check (line 12). Otherwise we
recursively call ourself with the next array index.

The {% ih kotlin %}loop(){% endih %} function has access to all of the parameters passed into the
parent function. So it does not need the array or ordered parameters to be passed to it.

Outside the local {% ih kotlin %}loop(){% endih %} function (line 19), we first do a check, if the
array is empty, we just return true, otherwise we start the recursive {% ih kotlin %}loop(){% endih
%} call.

{% highlight kotlin linenos %}
{% include_code /home/bill/src/functional-programming-in-kotlin/src/main/kotlin/ws/billdavis/fpik/chapter02/IsSorted.kt %}
{% endhighlight %}

## Using a Higher Order Function with Testing

After I wrote the {% ih kotlin %}fibonacci2(){% endih %} function (the {% ih kotlin %}if/then{%
endih %} version), I basically copied the test and called {% ih kotlin %}fibonacci2(){% endih %}
instead, then refactored the test to use a higher-order function that would run the tests for both
functions. The {% ih kotlin %}runFibonacciTests(){% endih %} (line 37) function takes as a
parameter, a function that gets passed and int and returns an int. That signature is the same as
both of the fibonacci functions, so we can just pass those to the function to run the tests (lines
51-52).
  
{% highlight kotlin linenos %}
{% include_code /home/bill/src/functional-programming-in-kotlin/src/main/kotlin/ws/billdavis/fpik/chapter02/Fibonacci.kt %}
{% endhighlight %}
