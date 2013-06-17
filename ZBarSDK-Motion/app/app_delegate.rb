class HomeController < UIViewController

  def viewDidLoad
    @action = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @action.setTitle('Scan Code', forState:UIControlStateNormal)
    @action.addTarget(self, action:'modalReader', forControlEvents:UIControlEventTouchUpInside)
    @action.frame = [[20, 200], [view.frame.size.width - 40, 80]]
    view.addSubview(@action)
  end

  def modalReader
    @reader = ZBarReaderViewController.new;
    @reader.readerDelegate = self;
    @reader.supportedOrientationsMask = ZBarOrientationMaskAll;

    # TODO: (optional) additional reader configuration here
    # EXAMPLE: disable rarely used I2/5 to improve performance
    #[scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    @reader.scanner.setSymbology(ZBAR_I25, config: ZBAR_CFG_ENABLE, to: 0)

    # present and release the controller
    #[self presentModalViewController:reader animated:YES];
    self.presentModalViewController(@reader, animated: true)
  end

  def imagePickerController(reader, didFinishPickingMediaWithInfo: info)
    message = ""
    info[ZBarReaderControllerResults].each do |item|
      NSLog item.typeName.to_s
      NSLog item.data.to_s
      message += "#{item.typeName.to_s} : #{item.data.to_s}\n"
    end
    alert = UIAlertView.alloc.initWithTitle("Information", message: message, delegate: nil, cancelButtonTitle: 'Dismiss', otherButtonTitles: nil)
    alert.show
    alert = nil
    @reader.dismissModalViewControllerAnimated(true)
  end
end
class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = HomeController.alloc.init
    @window.makeKeyAndVisible
    true
  end
end
