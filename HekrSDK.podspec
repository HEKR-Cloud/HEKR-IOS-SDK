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

  s.name         = "HekrSDK"
  s.version      = "3.2"
  s.summary      = "SDK of Hekr."

  s.description  = <<-DESC
  A longer description of HekrConfig in Markdown format.

  * Think: Why did you write this? What is the focus? What does it do?
    * CocoaPods will be using this to generate tags, and improve search results.
    * Try to keep it short, snappy and to the point.
    * Finally, don't worry about the indent, CocoaPods strips it!
    DESC

    s.homepage     = "http://www.hekr.me"
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
    s.platform     = :ios, "7.0"

    #  When using multiple platforms
    # s.ios.deployment_target = "5.0"
    # s.osx.deployment_target = "10.7"
    # s.watchos.deployment_target = "2.0"


    # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    #
    #  Specify the location from where the source should be retrieved.
    #  Supports git, hg, bzr, svn and HTTP.
    #

    s.source       = { :git => "https://github.com/HEKR-Cloud/HEKR-IOS-SDK.git", :tag => "SDK3.2" }


    # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    #
    #  CocoaPods is smart about how it includes source code. For source files
    #  giving a folder will include any swift, h, m, mm, c & cpp files.
    #  For header files it will include any header in the folder.
    #  Not including the public_header_files will make all headers public.
    #

    s.subspec 'Core' do |sp|
      sp.public_header_files = "*.{h}"
      sp.resource_bundles = {
        'JSSDK' => ['WebViewJavascriptBridge.js.txt']
      }
      sp.vendored_libraries = 'libHekrSDK.a'
      sp.requires_arc = true

      sp.dependency "CocoaAsyncSocket", "~> 7.4"
      sp.dependency "SocketRocket", "~> 0.4"
      sp.dependency "AFNetworking", "~> 3.0"
      sp.dependency "WebViewJavascriptBridge", "~> 4.1"
      sp.dependency "ZipArchive", "~> 1.4"
      sp.dependency "GetuiSDK", "~> 1.4"
      sp.dependency "CocoaLumberjack", "~> 2.3.0"
    end

    s.subspec 'SocailWeibo' do |sp|
      sp.dependency "WeiboSDK", "~> 3.1.3"
    end

    s.subspec 'SocailQQ' do |sp|
      sp.dependency "TencentOpenApiSDK","~> 2.9"
    end

    s.subspec 'SocailWeixin' do |sp|
      sp.dependency "WeixinSDK","~> 1.4"
    end

    s.subspec 'SocailFacebook' do |sp|
      sp.dependency "FBSDKLoginKit", "~> 4.8"
    end

    s.subspec 'SocailTwitter' do |sp|
      sp.dependency "TwitterCore", "~> 1.10.0"
      sp.dependency "TwitterKit", "~> 1.10.0"
    end

    s.subspec 'SocailGoogle' do |sp|
      sp.dependency "Google/SignIn", "~> 1.2"
    end

    s.default_subspec = 'Core'

  end