INTRODUCTION
------------

This package contains the source for Ocaml 
interface to Wordnet. For more information on WordNet refer
http://wordnet.princeton.edu/

This library enables Ocaml programs to use
the Wordnet dictionary for (english) word forms and meanings
It directly parses the WordNet dictionary files, and does not
depend on any other libraries

This library requires WordNet 2.1 to be installed (or at least
the dictionary files to be available)

WARNING

This library was only tested on a Win XP machine
It is not known whether it works on other systems although
there is no reason why it should not work.

PACKAGE
-------

Files are:
  - README.txt this file
  - the library:
      . wordnet.mli      Interface to Wordnet 2.1
      . wordnet.ml       Implementation of interface 
  - Application example:
      . related.ml       Toy example application of this library. Given
                         a word, suggests related words ordered by 
			 usage frequency

ENVIRONMENT
-----------

This library requires the environment variable WNSEARCHDIR
to be set to point to the directory containing WordNet dictionary
For example, on WinXP, WNSEARCHDIR may point to
C:\Program Files\WordNet\2.1\dict

DOCUMENTATION
-------------

This API is minimalist in providing only the necessary functions
which cannot be derived from other api functions.

The API is organized around two Types:
wordType  : represents a word-form and the meanings it represents
senseType : represents a meaning and the word-forms it represents

There is a many-many relationship between words and senses.
There are pointers of various types between senses.

example interactive session..

# #load "wordnet.cma";;
# open Wordnet;;
# let w = getWord "house" NOUN;;
# printWord w;;
... snip
# let sense0 = List.hd (getSenses w);;
# let senses1 = getPtrSense HYPOPTR sense0
# List.iter printSense senses1
... snip
# # let senses1 = getPtrSense HYPERPTR sense0
# List.iter printSense senses1
... snip
# morph "housing" VER;;
- : string = "house"
# let w = getWord "house" VER;;
# let senses = getSenses w;;
# getVerbFrames "house" (List.hd senses);;
- : string list = ["Something ----s somebody"; "Something ----s something"]
# List.iter printSense senses;;
... snip


RELATED
-------

WordNet APIs for other languages are available at
http://wordnet.princeton.edu/

AUTHOR
------

Ramu Ramamurthy - ramu_ramamurthy at yahoo dot com

LICENSE (BSD)
-------------

Copyright (c) 2006, Ramu Ramamurthy
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of the author nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
