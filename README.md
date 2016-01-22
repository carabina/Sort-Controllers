# Sort-Controllers
A library for sorting custom objects into sections, good for UITableView and UICollectionView. Written in Swift

# How it works
There are sort controller, and there are your objects, you give the objects to the sort controller, and it will return
a sections of the organized objects..

# SKSSortableObject and SKSSortController

Any object you wish to sort **must** conform to this protocol, which defines a set of optional properties, each property
used by a different sort controller..
All the sort controllers conform to protocol SKSSortController, which defines a a methods for sorting and configuring the
sort operation. ( you can find details in the source, it's documented ).

# Using them with UITableView or UICollectionView

The main goal of this library is to link the pool of the unordered model objects, into the tableview.. by ordering them
and returning them in packages..

In the sortController instance, there are method called sort:, which will return an array of sections, just pass the
sections into the tableView or collectionView..
Getting object is done by calling sortController.objectAtIndexPath:

**It's still in tests, if you have any questions or notes, feel free to tell me.. **
