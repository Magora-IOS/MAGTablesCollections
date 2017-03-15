//
//  MAGTableManager+Redefinition.h
//  Pods
//
//  Created by Matveev on 14/03/17.
//
//

#import <MAGTablesCollections/MAGTablesCollections.h>

/**
	@brief You must to rewrite CRITICAL section's methods in your subclass of MAGTableManager! You can rewrite optional methods too by your wish.
	MAGTableManager has special work for MAGBaseCell.
*/

/**
	CRITICAL:
	
	cellClassNamesForNibOrClassRegistering		- здесь возвращаешь массив классов: тех ячеек что имеют ксибок и что не имеют. Она
	автоматом создастся и будет переиспользоваться (если же permanent то будет висеть в памяти постоянно). Никаких забот.
	
	permanentCellForItem:atIndexPath:				- внутри своего сабкласса MAGTableManager добавляешь проперти ячеек, которые будут
	показываться стабильно и КОТОРЫЕ НЕ НУЖНО НИКОГДА РЕЛОАДИТЬ. То есть они всегда будут храниться в памяти. В итоге они
	хранятся в пропертях твоего TM. Тут ты просто возвращаешь сами объекты для нужных индексов. Сперва таблица ищет перманентные
	ячейки по IP. Если их нет то ищет обычные. Если их тоже нет то создает стандартную ячейку.
	
	cellIdentifierForItem:atIndexPath					- возвращаешь идентификатор ячейки, чтобы она работала как reusable ячейка (не забудь прописать его в xib). Если ячейка является постоянной
	
	configureCell:withItem:atIndexPath:			- вызывается когда ячейку нужно сконфигурировать. тут просто конфигурируй нужную ячейку
	configureHeaderView:forSection:					- вызывается когда хидер нужно сконфигурировать. по дефолту делай пустую реализацию
	configureFooterView:forSection:					- вызывается когда футер нужно сконфигурировать. по дефолту делай пустую реализацию
*/

/**
	OPTIONAL:
	
	selectedBackgroundColorForBaseCell			- выставляет специальный бэкграунд цвет выделения только для MAGBaseCell-ячеек
	separatorDisplayingModeForBaseCellNormalState: atIndexPath:		- MAGBaseCell умеет рисовать сепаратор. Режим отрисовки в норм состоянии
	separatorDisplayingModeForBaseCellSelectedState: atIndexPath:	- MAGBaseCell умеет рисовать сепаратор. Режим отрисовки в выделенном состоянии
*/

@interface MAGTableManager (Redefinition)

//		CRITICAL REDEFINITION

- (NSArray *)cellClassNamesForNibOrClassRegistering;//        for registering of nib or class (if nib not exists)
- (UITableViewCell *)permanentCellForItem:(id)item atIndexPath:(NSIndexPath *)indexPath;
- (NSString *)cellIdentifierForItem:(id)item atIndexPath:(NSIndexPath *)indexPath;//        ! indexPath added bcs different sections can contains same item but display it in different cell types. For avoid wrong behavior YOU MUSTNOT return here cell's identifier when you return permanentCell for this indexPath from - (UITableViewCell *)permanentCellForItem:(id)item atIndexPath:(NSIndexPath *)indexPath method.
- (void)configureCell:(__kindof UITableViewCell *)cell withItem:(id)item atIndexPath:(NSIndexPath *)indexPath;//     indexPath added for same reason
- (void)configureHeaderView:(UIView *)view forSection:(MAGTableSection *)section;
- (void)configureFooterView:(UIView *)view forSection:(MAGTableSection *)section;



//		OPTIONAL MAIN REDEFINITION

- (CGFloat)heightForItem:(id)item;
- (BOOL)shouldHighlightAndSelectCellAtIndexPath:(NSIndexPath *)indexPath;
- (UIColor *)selectedBackgroundColorForBaseCell:(MAGBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (SeparatorDisplayingMode)separatorDisplayingModeForBaseCellNormalState:(MAGBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (SeparatorDisplayingMode)separatorDisplayingModeForBaseCellSelectedState:(MAGBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath;

//		OPTIONAL ADDITIONAL REDEFINITION

- (CGFloat)heightForHeaderViewOfSection:(MAGTableSection *)section;
- (CGFloat)heightForFooterViewOfSection:(MAGTableSection *)section;
- (NSString *)headerIdentifierForSection:(MAGTableSection *)section;
- (NSString *)footerIdentifierForSection:(MAGTableSection *)section;

@end
