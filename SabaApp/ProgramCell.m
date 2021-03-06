//
//  ProgramCell.m
//  SabaApp
//
//  Created by Syed Naqvi on 4/29/15.
//  Copyright (c) 2015 Naqvi. All rights reserved.
//

#import "ProgramCell.h"

// Third party libraries
#import "UIImageView+AFNetworking.h"

#import "SabaClient.h"

NSDictionary *dayToImage = nil;

@interface ProgramCell()

@property (weak, nonatomic) IBOutlet UILabel *title;
/*
 change programDescription type to UITextView in order to make links clickable. 
 We need to set the autolayout constraints correctly and turn off the scrollbar to make its height adjustable based on the contents.
 */
@property (weak, nonatomic) IBOutlet UITextView *programDescription;
@property (weak, nonatomic) IBOutlet UIImageView *programImageview;

@end

@implementation ProgramCell


- (void)awakeFromNib {
	// round image
//	self.programImageview.layer.cornerRadius = 8.0;
//	self.programImageview.clipsToBounds = YES;

	// Add a border
	//self.programImageview.layer.borderWidth = 1.0;
	//self.programImageview.layer.borderColor = [[UIColor yellowColor] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setProgram:(Program *)program{
	_program = program;
	NSString *imageUrl = [program imageUrl];
	if(imageUrl == nil && ([self.program.name isEqual: @"Weekly Programs"] == YES)){
		NSString *day = [self getFirstWordFromString: self.program.title]; // This is the day in our case.
		[self setImageForDay:day];
	} else if([imageUrl length] != 0){
		[self.programImageview setImageWithURLRequest:
		 [NSURLRequest requestWithURL:[NSURL URLWithString: imageUrl]] placeholderImage:nil
				  success:^(NSURLRequest *request , NSHTTPURLResponse *response , UIImage *image ){
					  [self.programImageview setImage:image];
				  }
				  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
					  NSLog(@"failed loading: %@", error);
				  }
		 ];
	}
	self.title.attributedText = [[SabaClient sharedInstance] getAttributedString:[self.program title] fontName:self.title.font.fontName fontSize:self.title.font.pointSize withOpacity:1.0];

	self.programDescription.attributedText = [[SabaClient sharedInstance] getAttributedString:[self.program programDescription] fontName:self.programDescription.font.fontName fontSize:self.programDescription.font.pointSize withOpacity:.75];
}

-(NSString*) getFirstWordFromString:(NSString*)text{
	NSRange range = [text rangeOfString:@" "];
	if (range.location != NSNotFound) {
		return [text substringToIndex:range.location];
	}
	return nil;
}

-(void) setImageForDay:(NSString*) day{
	if(day == nil)
		return;
	
	// Currently, our icons are having the same name as of days so no need to map.
	// otherise we may need to have a dictionary to have a mapping from "Day" to Image.
	self.programImageview.image = [UIImage imageNamed:day];
}

@end
