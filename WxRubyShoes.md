# Introduction #

I belatedly discovered wxRuby, and was blown away (pleasantly) by its look, power and flexibility, and (unpleasantly) by it's very non-rubyish syntax.

OTOH, I love Shoes, but hate that it has to run in it's own interpreter.

WxRubyShoes is the bastard child of both worlds.  It wraps up the wxRuby library in a syntax that is extremely Shoesish.

# Thank You #

A big call-out to [Why the lucky stiff](http://whytheluckystiff.net/), who I have never met but always respected as the demented genius he obviously is.  I have shamelessly stolen a piece of magic from one of his posts - the cloaker method.  I hope he doesn't mind.

# Details #

I have tried to keep all the method and parameter names the same as their counterparts in the wxRuby library, so the [standard documentation for wxRuby](http://wxruby.rubyforge.org/doc/) will stand you in good stead.

Class constructors are lowercase and underscored, instead of camel-capitalized.  All method parameters are passed as a single hash.  This is a little more verbose, but I like it's self-documenting nature, and you only have to put in the arguments you want - everything else has sensible defaults.  For example:
```
Wx::Button.new(parent, id) 
```
becomes:
```
button(:parent => parent, :id => id) 
```

This example may not look like much, but it is the ability to nest constructors in blocks, and have the library keep track of context for you, that makes it so concise.

Download it, look at the simple example.  It's pretty self-explanatory.  Except for the bit where the frame controller module is passed to the frame method - that bit deserves your close attention.

# Known Issues #

Currently we are at the first cut stage.  Only those controls I am actually using in the example are coded (I have finished all the layouts, though).  Nesting layouts works, but right now I am only using the library for single form applications.  I really haven't thought of the next step, and probably won't until I want to use it.  Suggestions are welcome.

You will notice from the example that I have not done anything nice to wrap up the standard dialogs.  I'll get there.
