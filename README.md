# MAGTablesCollections

Framework for very convenient work with UITableView and UICollectionView

		With this class you mustn't interact with tableView directly but should to do it via tableManager.
        Take in attention that MAGTableManager prefer works with MAGBaseCell-like cells (but it is not required. It required for special abilities of MAGTableManager and its cells)
		
 
		Mostly useful features:
	
		Displaying of separators at full wide: useSeparatorsZeroInset = YES
 
		Specify colors of all separators: separatorsColor = [UIColor myColor]
 
		Sed default selection color for all tables of your app: +setDefaultSelectionColor:[UIColor myColor]. Then at any moment you can use other values for concrete MAGTableManager-s
		
		Display backgroundColor of allCells in alternate color order inside each section: alternateBackgroundColors = @[myColor1, myColor2, myColor3, etc]
	
		Display emptyView over tableView when data is empty: setDisplayEmptyViewWhenDataIsEmpty:YES classnameForEmptyView:[MyTableEmptyView class] emptyViewCustomizationBlock:^(UIView *view) {
			MyTableEmptyView *v = (MyTableEmptyView *)view; 
			v.title = @"List is empty";
			}
 
		If you want close your table's bottom for avoid default zebra from separators and close bottom of last cell, then you can
		set useFooterSeparatorViewInsteadOfEmptyTableFooterView = YES.
 
		Clear cell's selection once: clearSelectionOnce = YES
		Disable changing selection by user taps: changingSelectionByUserTapsDisabled = YES
		
		Displaying single section with any items: items = @[myItem1, myItem2, myItem3 etc]
		Displaying many sections with any items inside each section:
		MAGTableSection *s1 = [MAGTableSection new];
		s1.items = @[myItem1, myItem2];
		MAGTableSection *s2 = [MAGTableSection new];
		s2.items = @[myItem3, myItem4];
		sections = @[s1,s2]
		
		Table will reload immediately after set items or sections.
		
		Set selected items (detected by selected rows of table):  selectedItems = @[myItem1, myItem2]
		For getting selected items: [self selectedItems]
 
		At any time you can fastly find your item by indexPath or by cell: 
			itemByIndexPath:
			itemByCell:
			
		You can find indexPath of item in sections:
			indexPathsOfItem: inSections:
		Or to know which sections contains your item:
			sectionsContainingItem:
			
		You can do operations with items usable methods:
			makeInsertOperations: animated:completion:
			makeReloadOperations: animated: completion:
			makeAllItemOccurenciesDeleteOperations: animated: completion:
			
		Here exists category for redefinition of methods to get better control over tableManager: MAGTableManager+Redefinition
		
		If you use MAGBaseCell as cells, then you have additional possibilities:
		
		1) Cells extended with good system of separators displaying inside cell
		2) You can use autocalculation of cell's height. To do it:
			a) You should to know that "top view" is subview with minimal Y of cell's contentView's subviews
			b) so you can specify that bottom margin should be equal to topView y: bottomMarginEqualToTopViewMargin = YES
			c) else if you want custom bottom margin, then bottomMarginEqualToTopViewMargin = NO, bottomMargin = 15.0 (for example)
			note: you can setup bottomMarginEqualToTopViewMargin and bottomMargin from both xib or code :)
			d) at MAGTableManager  - heightForItem:  you should return your [baseCell requiredHeight]
		3) you can setup selectedBackgroundColor and nonselectedBackgroundColor
		4) you can store any item inside of cell.
		
		EASY REQUIREMENTS:
		After subclassing of MAGTableManager you MUST redefine next methods:
		
		-cellClassNamesForNibOrClassRegistering return here array of cell class names for autoregistration on reusable of them. Example:
			InfoCell, UserCell have InfoCell.xib and UserCell.xib
			ManagerCell haven't ManagerCell.xib
			So for addition all of them as reusable cells:
			@[[InfoCell class], [UserCell class], [Manager class]] - just return array of them's classes
 
	
		- permanentCellForItem:atIndexPath: - here you should return cells which mustn't be reusable and must be as constantly visible cells.
 
		- cellIdentifierForItem: atIndexPath: - return cellIdentifier for table might know which cell return for this indexPath ;//        indexPath added bcs different sections can contains same item but display it in different cell types. For avoid wrong behavior YOU MUSTNOT return here cell's identifier when you return permanentCell for this indexPath from - (UITableViewCell *)permanentCellForItem:(id)item atIndexPath:(NSIndexPath *)indexPath method.

		- configureCell: withItem: atIndexPath: - here you can configure your cell if needed

		- configureHeaderView: forSection: - is required bcs at any time you can add headerView
		- configureFooterView: forSection:  - is required bcs at any time you can add footerView
		
		OPTIONALLY for increasing of control you can redefine next methods:
			- heightForItem: - specify cell height for some item. Take in attention that some sections might contains the same item, so be careful!
			- shouldHighlightAndSelectCellAtIndexPath: - you can specify indexpaths which yon wantn't to be highlightable and selectable
			- selectedBackgroundColorForBaseCell: atIndexPath: - specify selected background color for concrete baseCells (it works with MAGBaseCell only!)
			- separatorDisplayingModeForBaseCellNormalState: atIndexPath: - specify separatorDisplayingMode for normal state ob baseCell at indexPath (it works with MAGBaseCell only!)
			- separatorDisplayingModeForBaseCellSelectedState: atIndexPath: - specify separatorDisplayingMode for selected state ob baseCell at indexPath (it works with MAGBaseCell only!)
