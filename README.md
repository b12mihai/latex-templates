Latex Templates
=======

This repos purpose is to offer a \LaTeX alternative to Power Point or Word for
those who want to write really beautiful documents and hate to write the code 
from scratch because of the deadlines (I really know the feeling!) or simply
want to have an adaptable framework.

Feel free to contribute to this code. 

Additional note for Word conversion
-----------------------------------

Use the latex source from [math-basic](math-basic). It's designed to be as bare minimum as possible for
conversion to be smooth by using:

```
pandoc -s math-basic.tex -o math-basic.docx
``` 

Contents
---------

* __cover-letter__ -> a simplistic cover letter to apply for a job
* __mathematical-project__ -> a basic setup for a lab essay/report with 
tones of mathematical formulas, or to typeset your hand written courses/cheatsheets
* __algorithmic-project__ -> a basic setup for a lab essay/report algorithms
oriented

Coming soon: source code, with syntax highlight environment, beamer, thesis template

