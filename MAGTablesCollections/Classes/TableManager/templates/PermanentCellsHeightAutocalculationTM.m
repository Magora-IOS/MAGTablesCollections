







/*
#import "HistoryMessageTM.h"
#import "HistoryTextCell.h"
#import "HistoryReceiverCell.h"

@interface HistoryMessageTM () <MDHTMLLabelDelegate>

@end


@implementation HistoryMessageTM

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.tableView.allowsSelection = NO;
	
	[self updateWithItem:self.historyMessage];
	
	self.useFooterSeparatorViewInsteadOfEmptyTableFooterView = YES;
}

- (void)setHistoryMessage:(HistoryMessage *)item {
	_historyMessage = item;
	
	[self updateWithItem:item];
}

- (void)updateWithItem:(HistoryMessage *)item {
	HistoryTextCell *cell;
	
	if (item) {
		cell = [HistoryTextCell mag_loadFromNib];
		cell.hintLabel.text = LS(@"history_message.lb.send_date");
		cell.valueLabel.text = item.sendDate;
		self.sendDateCell = cell;
		
		cell = [HistoryTextCell mag_loadFromNib];
		cell.hintLabel.text = LS(@"history_message.lb.message_type");
		cell.valueLabel.text = item.messageType.title;
		self.messageTypeCell = cell;
		
		HistoryReceiverCell *receiverCell = [HistoryReceiverCell mag_loadFromNib];
		receiverCell.hintLabel.text = LS(@"history_message.lb.receiver");
		receiverCell.valueLabel.text = [Transformer formattedPhoneNumberStringFromJustDigitsPhoneString:item.phone];
		receiverCell.commentLabel.text = item.operatorName;
		receiverCell.secondLineLabel.text = item.region;
		self.receiverCell = receiverCell;
 
		self.items = @[self.sendDateCell, self.messageTypeCell, self.receiverCell];
	} else {
		self.items = @[];
	}
}


- (UITableViewCell *)permanentCellForItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *result = [self.items objectAtIndex:indexPath.row];
	return result;
}

- (CGFloat)heightForItem:(id)item {
	CGFloat result;
	BaseCell *cell = (BaseCell *)item;
	result = [cell requiredHeight];
	return result;
}

@end
*/
