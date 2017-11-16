#
#  Be sure to run `pod spec lint HekrConfig.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "HekrApiSDK"
  s.version      = "3.0"
  s.summary      = "SDK for HEKR"

  s.description  = <<-DESC
  A longer description of HekrConfig in Markdown format.

  * Think: Why did you write this? What is the focus? What does it do?
    * CocoaPods will be using this to generate tags, and improve search results.
    * Try to keep it short, snappy and to the point.
    * Finally, don't worry about the indent, CocoaPods strips it!
    DESC

    s.homepage     = "http://hekr.me"
    # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


    # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    #
    #  Licensing your code is important. See http://choosealicense.com for more info.
    #  CocoaPods will detect a license file if there is a named LICENSE*
    #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
    #

    s.license      = "MIT see http://www.hekr.me"
    # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


    # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    #
    #  Specify the authors of the library, with email addresses. Email addresses
    #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
    #  accepts just a name if you'd rather not provide an email address.
    #
    #  Specify a social_media_url where others can refer to, for example a twitter
    #  profile URL.
    #

    s.author             = { "Mike" => "ccteym@gmail.com" }
    # Or just: s.author    = "Mike"
    # s.authors            = { "Mike" => "ccteym@gmail.com" }
    # s.social_media_url   = "http://twitter.com/Mike"

    # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    #
    #  If this Pod runs only on iOS or OS X, then specify the platform and
    #  the deployment target. You can optionally include the target after the platform.
    #

    s.platform     = :ios
    s.platform     = :ios, "8.0"

    #  When using multiple platforms
    # s.ios.deployment_target = "5.0"
    # s.osx.deployment_target = "10.7"
    # s.watchos.deployment_target = "2.0"


    # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    #
    #  Specify the location from where the source should be retrieved.
    #  Supports git, hg, bzr, svn and HTTP.
    #

    s.source       = { :git => "https://github.com/HEKR-Cloud/HEKR-IOS-SDK.git", :tag => "3.0" }

    s.vendored_frameworks = 'HekrApiSDK.framework'

    s.resource_bundles = {
      'JSSDK' => ['WebViewJavascriptBridge.js.txt']
    }
    s.requires_arc = true

    s.dependency "CocoaAsyncSocket", "~> 7.4"
    s.dependency "SocketRocket", "~> 0.4"
    s.dependency "AFNetworking", "~> 3.0"
    s.dependency "WebViewJavascriptBridge", "~> 4.1"
    s.dependency "ZipArchive", "~> 1.4"
    s.dependency "CocoaLumberjack", "~> 2.3.0"
    s.dependency 'SHAlertViewBlocks', '~> 1.2.1'

  end
