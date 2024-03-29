# Sort-Controllers
A library for sorting custom objects into sections, good for UITableView and UICollectionView. Written in Swift.

<p align="center">
  <img src="https://github.com/Hussein75/Sort-Controllers/blob/master/Screenshot.png" alt="screenshot" width="375" height="667">
</p>

# Installation
Just drag the files from the demo application under the folder SortControllers.

# Usage

Conform to the protocol SKSSortableObject for each object you want to sort:
```
class CustomObject: SKSSortableObject ...
```

Create the sort controller ( depending on the sort type ):
```
let sortController = SKSDateSortController()
```

pass the objects to the sort controller, and it will return a sections:

```
let sections = sortController.sort(myBunchOfObjects)
```

That's it! these sections are available to use on any UITableView or UICollectionView.

##Note: for getting the object at indexPath, use the helper method:
```
objectAtIndexPath:inSections:
```

# Types of sort

* Date Sort: ``` SKSDateSortController ```
* Group Sort: ```SKSGroupSortController ```
* Alphabetic Sort: ```SKSAlphabeticSortController ```
* More Coming soon...

# Confuse ?

I'm not good at English, so, you can try the demo application.. ( I think you're going to understand everything )..

**It's still in tests, if you have any questions or notes, feel free to tell me.. **

#TODO's:

* More generic..
* Supporting numbers sorts..
* Tags Sort..
* Improves..

# License
Copyright (c) 2016 Hussein Ryalat

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
