# AMResizableSplitterView 

AMResizableSplitterView is a replacement for UISplitViewController that allows the user to drag a splitter to resize the split views. This project is actively under development, but I decided to make it public from the get-go.

I had been using Matt Gemmell's [MGSplitViewController](https://github.com/mattgemmell/MGSplitViewController/) for one of my current projects, but I have a had a number of issues with it and found the code unnecessarily complex. (I started iOS development with 4.0 and switched to 5.0 as a minimum version after WWDC 2011, so most code older than that seems too complex to me.) AMResizableSplitterView is much simpler since it uses the container view controllers added with iOS 5.

## Features

- User-draggable splitter
- Allows setting different minimum sizes for each view and landscape/portrait orientation
- Splitter is simple UIView with the background color set to a default color. Customize to your hearts desire.

## Usage

Take a look at the AppDelegate class for sample usage. Here's the snippet that setups the split view.

		self.viewController = [[AMResizableSplitViewController alloc] init];
		self.window.rootViewController = self.viewController;
		self.viewController.minimumView2Size = CGSizeMake(200, 200);
	    [self.window makeKeyAndVisible];
		ImageViewController *i1 = [[ImageViewController alloc] init];
		ImageViewController *i2 = [[ImageViewController alloc] init];
		[i1 view];
		[i2 view];
		i1.imageView.image = [UIImage imageNamed:@"image1.jpg"];
		i2.imageView.image = [UIImage imageNamed:@"image2.jpg"];
		self.viewController.controller1 = i1;
		self.viewController.controller2 = i2;


## Requirements

- iOS 5.1 (might work with 5.0, but only tested with 5.1)
- Xcode 4.3 or greater (only tested with 4.5)
- ARC enabled

## To Do

- allow specifying optional gradient colors for splitter background

## License

Copyright (c) 2012 Agile Monks, LLC.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
