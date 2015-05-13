//
//  NSConnection.h
//  zelinx
//



#import <Foundation/Foundation.h>

@class NSConnection;
@protocol NSConnectionDelegate<NSObject>
@optional

-(void)NSConnection:(NSConnection*)conn didFailWithError:(NSError*)error withTag:(int)tag;
-(void)NSConnection:(NSConnection*)request didSuccessWithItems:(NSDictionary*)dicData withData:(NSData*)data withTag:(int)tag;

@end


@interface NSConnection : NSObject {
	id <NSConnectionDelegate> _conDelegate;
    NSMutableDictionary *dicConnection;

	BOOL _checkConnection;
}
@property (nonatomic,strong) id <NSConnectionDelegate> conDelegate;

-(void)sendRequest:(NSString*)strURL withParaMeter:(NSString*)strParameter withMethod:(NSString*)methodName withTag:(int)tag;
-(void)startAsynchronousRequest;


-(id)init;
-(id)initWithDelegate:(id)delegate;

@end

