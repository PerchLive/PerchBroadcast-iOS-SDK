//
//  KFRecordButton.m
//  Pods
//
//  Created by Christopher Ballinger on 4/2/14.
//
//

#import "KFRecordButton.h"
#import "NSBundle+Perch.h"

@interface KFRecordButton()
@property (nonatomic, strong) UIImage *startImage;
@property (nonatomic, strong) UIImage *stopImage;
@property (nonatomic, strong) UIImageView *outerImageView;
@end

@implementation KFRecordButton

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImage *image = [UIImage imageNamed:@"KFRecordButtonStart" inBundle:[NSBundle perchBundle] compatibleWithTraitCollection:nil];
        self.startImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self setImage:self.startImage
                     forState:UIControlStateNormal];
        
        image = [UIImage imageNamed:@"KFRecordButtonStop" inBundle:[NSBundle perchBundle] compatibleWithTraitCollection:nil];
        self.stopImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        self.tintColor = [UIColor redColor];
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self setupOuterImage];
    }
    return self;
}

- (void) setupOuterImage {
    UIImage *image = [UIImage imageNamed:@"KFRecordButtonBorder" inBundle:[NSBundle perchBundle] compatibleWithTraitCollection:nil];
    self.outerImageView = [[UIImageView alloc] initWithImage:image];
    self.outerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.outerImageView];
}

- (void) updateConstraints {
    UIView *superview = self;
    NSDictionary *variables = NSDictionaryOfVariableBindings(_outerImageView, superview);
    NSArray *constraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[superview]-(<=1)-[_outerImageView]"
                                            options: NSLayoutFormatAlignAllCenterX
                                            metrics:nil
                                              views:variables];
    [self addConstraints:constraints];
    
    constraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[superview]-(<=1)-[_outerImageView]"
                                            options: NSLayoutFormatAlignAllCenterY
                                            metrics:nil
                                              views:variables];
    [self addConstraints:constraints];
    [super updateConstraints];
}

- (void) setIsRecording:(BOOL)isRecording {
    _isRecording = isRecording;
    if (_isRecording) {
        [self setImage:self.stopImage
              forState:UIControlStateNormal];
    } else {
        [self setImage:self.startImage
              forState:UIControlStateNormal];
    }
}

- (CGSize) intrinsicContentSize {
    return CGSizeMake(66, 66);
}

@end
