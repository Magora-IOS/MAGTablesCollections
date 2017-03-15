# MAGTablesCollections

Framework for very convenient work with UITableView and UICollectionView

With this class you mustn't interact with tableView directly but should to do it via tableManager.
        
Take in attention that MAGTableManager prefer works with MAGBaseCell-like cells (but it is not required. It required for special abilities of MAGTableManager and its cells)
		
## I MAGTableManager FEATURES:
	
1 Displaying of separators at full wide: useSeparatorsZeroInset = YES
 
2 Specify colors of all separators: separatorsColor = [UIColor myColor]
 
3 Set default selection color for all tables of your app: +setDefaultSelectionColor:[UIColor myColor]. Then at any moment you can use other values for concrete MAGTableManager-s
		
4 Display backgroundColor of allCells in alternate color order inside each section: alternateBackgroundColors = @[myColor1, myColor2, myColor3, etc]
	
5 Display emptyView over tableView when data is empty: 
```
setDisplayEmptyViewWhenDataIsEmpty:YES classnameForEmptyView:[MyTableEmptyView class] emptyViewCustomizationBlock:^(UIView *view) {
		MyTableEmptyView *v = (MyTableEmptyView *)view; 
		v.title = @"List is empty";
	}
```
6 If you want close your table's bottom for avoid default zebra from separators and close bottom of last cell, then you can
set useFooterSeparatorViewInsteadOfEmptyTableFooterView = YES.
 
7 Clear cell's selection once: clearSelectionOnce = YES
8 Disable changing selection by user taps: changingSelectionByUserTapsDisabled = YES
		
9 Displaying single section with any items: items = @[myItem1, myItem2, myItem3 etc]
10 Displaying many sections with any items inside each section:
```
	MAGTableSection *s1 = [MAGTableSection new];
	s1.items = @[myItem1, myItem2];
	MAGTableSection *s2 = [MAGTableSection new];
	s2.items = @[myItem3, myItem4];
	sections = @[s1,s2]
```		
Table will reload immediately after set items or sections.
		
11 Set selected items (detected by selected rows of table):  selectedItems = @[myItem1, myItem2]
For getting selected items: [self selectedItems]
 
12 At any time you can fastly find your item by indexPath or by cell: 
```	itemByIndexPath:
	itemByCell:
```			
13 You can find indexPath of item in sections:
	indexPathsOfItem: inSections:
Or to know which sections contains your item:
	sectionsContainingItem:
			
14 You can do operations with items usable methods:
```	makeInsertOperations: animated:completion:
	makeReloadOperations: animated: completion:
	makeAllItemOccurenciesDeleteOperations: animated: completion:
```			
## II For better results use MAGBaseCell as cells, bcs then you will have additional possibilities:
		
1) Cells extended with good system of separators displaying inside cell
2) Autocalculation of cell's height bypassing stupid system methods (which differs for iOS versions). To have it you should:
	a) To know about "top view" is subview with minimal Y of cell's contentView's subviews (it is important far)
	b) So you can specify that bottom margin should be equal to topView y: bottomMarginEqualToTopViewMargin = YES
	c) else if you want custom bottom margin, then bottomMarginEqualToTopViewMargin = NO, bottomMargin = 15.0 (for example)
	note: you can setup bottomMarginEqualToTopViewMargin and bottomMargin from both xib or code :)
	d) at MAGTableManager  - heightForItem:  you should return your [baseCell requiredHeight]
3) you can store any item inside of cell.
		
## III EASY REQUIREMENTS:
### After subclassing of MAGTableManager you MUST redefine next methods (category MAGTableManager+Redefinition contains them):
		
1 -cellClassNamesForNibOrClassRegistering return here array of cell class names for autoregistration on reusable of them. Example:
InfoCell, UserCell have InfoCell.xib and UserCell.xib
ManagerCell haven't ManagerCell.xib
So for addition all of them as reusable cells:
@[[InfoCell class], [UserCell class], [Manager class]] - just return array of them's classes
 
	
2 - permanentCellForItem:atIndexPath: - here you should return cells which mustn't be reusable and must be as constantly visible cells.
 
3 - cellIdentifierForItem: atIndexPath: - return cellIdentifier for table might know which cell return for this indexPath ;//        indexPath added bcs different sections can contains same item but display it in different cell types. For avoid wrong behavior YOU MUSTNOT return here cell's identifier when you return permanentCell for this indexPath from - (UITableViewCell *)permanentCellForItem:(id)item atIndexPath:(NSIndexPath *)indexPath method.

4 - configureCell: withItem: atIndexPath: - here you can configure your cell if needed

5 - configureHeaderView: forSection: - is required bcs at any time you can add headerView
6 - configureFooterView: forSection:  - is required bcs at any time you can add footerView
		
## IV OPTIONALLY for increasing of features you can redefine next methods:
- heightForItem: - specify cell height for some item. Take in attention that some sections might contains the same item, so be careful!
- shouldHighlightAndSelectCellAtIndexPath: - you can specify indexpaths which yon wantn't to be highlightable and selectable
- selectedBackgroundColorForBaseCell: atIndexPath: - specify selected background color for concrete baseCells (it works with MAGBaseCell only!)
- separatorDisplayingModeForBaseCellNormalState: atIndexPath: - specify separatorDisplayingMode for normal state ob baseCell at indexPath (it works with MAGBaseCell only!)
- separatorDisplayingModeForBaseCellSelectedState: atIndexPath: - specify separatorDisplayingMode for selected state ob baseCell at indexPath (it works with MAGBaseCell only!)
