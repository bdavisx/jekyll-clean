---
title: "Currying and Uncurrying (Ex 2.3 and 2.4)"
layout: post
date: "2016-10-29T08:12:05-05:00"
published: true
series: "Functional Programming in Scala in Kotlin"	
---

## Exercise 2.3 - Currying

The FPiS book says that there is only one implementation that compiles for Scala, I don't know if
that's true for Kotlin. Basically we want to take a function that takes two parameters and returns a
value - and "split" it into two functions - the first one will take the first parameter and return a
function that takes the second parameter and returns a value. The first function doesn't do 
anything except return the second function.
 
On line 8, we specify that the parameter named `function` is a function that takes an A and B, and
returns a C: <br/>
`function: (A,B) -> C`<br/> 
We then say that we're returning a function that takes an A, and that function that we are
returning, returns a function that takes a B and returns a C:<br/>
`(A) -> ((B) -> C)`<br/>
We are basically declaring two functions in the return declaration portion of the signature.

Line 9 is where we declare and return the function that the user wants - a function that takes an A
and returns another function. On line 10 we get to the function that does the actual 'work' of the
curry - on line 11 the original function that the user passed in is called, along with the
parameters a and b that were supplied earlier. Notice how we are using parameters that were passed
in 3 different function calls.

{% highlight kotlin linenos %}
{% include_code /home/bill/src/functional-programming-in-kotlin/src/main/kotlin/ws/billdavis/fpik/chapter02/Curry.kt %}
{% endhighlight %}

For the test, on line 28 we define the function that will have the `curry()` function applied. It
takes an Int and Double and returns a String. In the test itself, on line 19, we pass the
`functionToBeCurried()` to `curry()` and keep the result in a val. You don't need to declare the val
types, they can be inferred, but I left them in for illustration (`val curried = curry
(::functionToBeCurried)`). On line 20, we call the first "level" of the curry with an Int so we are
left with a function that takes a double and returns a string. Then on line 21, we call the final
"level" and pass in our double, getting a String back in return.

## Exercise 2.4 - Uncurrying

There's not much to say about this function after the `curry()` one. The function signature on line
8 is the reverse of the `curry()` signature. Then we return a function with the expected signature.
When that function is run, we make the first call - `function(a)` then call pass the second value
`(b)`. It might look a little strange - you can see the calls separated out in the
`uncurrySeparate()` function - look at lines 16 and 17.

{% highlight kotlin linenos %}
{% include_code /home/bill/src/functional-programming-in-kotlin/src/main/kotlin/ws/billdavis/fpik/chapter02/Uncurry.kt %}
{% endhighlight %}


