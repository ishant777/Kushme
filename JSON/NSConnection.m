//
//  NSConnection.m
//  zelinx

#import "NSConnection.h"
#import "JSON.h"

@implementation NSConnection
@synthesize conDelegate = _conDelegate;

-(id)init{
	self = [super init];
	if (self) {
		NSLog(@"init");
	}
	return self;
}

-(id)initWithDelegate:(id)delegate{
    self = [super init];
    if (self) {
        _conDelegate = delegate;
    }
	return self;
}

-(void)sendRequest:(NSString*)strURL withParaMeter:(NSString*)strParameter withMethod:(NSString*)methodName withTag:(int)tag{
	NSLog(@"url is:- %@",strURL);
	if (_checkConnection==0) {
		dicConnection = [[NSMutableDictionary alloc] init];
	}
	_checkConnection++;
	strURL = [strURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	NSURL *url = [NSURL URLWithString:strURL];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:200];
    if ([strParameter length]>0) {
        [request setHTTPBody:[strParameter dataUsingEncoding:NSUTF8StringEncoding]];
    }
	[request setHTTPMethod:methodName];
	[dicConnection setObject:request forKey:[NSString stringWithFormat:@"%i",tag]];
}

-(void)startAsynchronousRequest{
	NSMutableDictionary *dic = [dicConnection mutableCopy];
	if ([dic count]>0) {
		for (int i=0; i<[dic count]; i++) {
			NSString *key = [NSString stringWithFormat:@"%@",[[dic allKeys]objectAtIndex:i]];
			NSMutableURLRequest *request = [dic objectForKey:key];
			[dicConnection removeObjectForKey:key];
			NSURLConnection *objCon = [[NSURLConnection alloc] initWithRequest:request delegate:self];
			[dicConnection setObject:objCon forKey:key];
			NSMutableData *data = [[NSMutableData alloc] init];
			[dicConnection setObject:data forKey:[objCon description]];
			
		}
	}
}




#pragma mark 
#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	NSMutableData *objData = [dicConnection objectForKey:[connection description]];
	[objData appendData:data];
    if (objData) {
        [dicConnection setObject:objData forKey:[connection description]];

    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	int tagIndex = [[dicConnection allValues] indexOfObject:connection];
	int	tag = [[[dicConnection allKeys] objectAtIndex:tagIndex]intValue];

	if ([_conDelegate respondsToSelector:@selector(NSConnection:didFailWithError:withTag:)]) {
		[_conDelegate NSConnection:self didFailWithError:error withTag:tag];
	}
	
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	
	int tagIndex = [[dicConnection allValues] indexOfObject:connection];
	int	tag = [[[dicConnection allKeys] objectAtIndex:tagIndex]intValue];

	@try {
		int tagIndex = [[dicConnection allValues] indexOfObject:connection];
		int	tag = [[[dicConnection allKeys] objectAtIndex:tagIndex]intValue];
		NSMutableData *objData = [dicConnection objectForKey:[connection description]];
		SBJSON *objJson = [SBJSON new];
		NSError *error=nil;
		NSDictionary *dicObj = nil;
		NSString *strResponseText = [[NSString alloc] initWithBytes:[objData bytes] length:[objData length] encoding:NSStringEncodingConversionAllowLossy];
        NSLog(@"response string is:- %@",strResponseText);
		dicObj = [objJson objectWithString:strResponseText error:&error];
		NSLog(@"response is:- %@",dicObj);
        if ([_conDelegate respondsToSelector:@selector(NSConnection:didSuccessWithItems:withData:withTag:)]) {
            [_conDelegate NSConnection:self didSuccessWithItems:dicObj withData:objData withTag:tag];
        }

		[dicConnection removeObjectForKey:[connection description]];
		[dicConnection removeObjectForKey:[NSString stringWithFormat:@"%i",tag]];
		
		
	}
	@catch (NSException * e) {
		NSError *error = [NSError errorWithDomain:@"get exception with parsing" code:1001 userInfo:[NSDictionary dictionaryWithObject:[e description] forKey:NSLocalizedDescriptionKey]];

		if ([_conDelegate respondsToSelector:@selector(NSConnection:didFailWithError:withTag:)]) {
			[_conDelegate NSConnection:self didFailWithError:error withTag:tag];
		}
	}
	@finally {
		
	}
}



@end
