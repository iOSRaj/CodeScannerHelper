Pod::Spec.new do |s|
s.name             = 'CodeScannerHelper'
s.version          = '1.0.0'
s.summary          = 'CodeScannerHelper pod to scan all the BarcodeTypes'

s.description      = <<-DESC
CodeScannerHelper pod for use with  swift projects
DESC

s.homepage         = 'https://stash.eden.klm.com/projects/MOBILE/repos/CodeScanner'
s.license          = "Raj"
s.author           = { 'Raj' => 'rajkumargkr@gmail.com' }
s.source           = { :git => 'https://github.com/iOSRaj/CodeScannerHelper.git', :tag => s.version }

s.ios.deployment_target = '8.0'
s.source_files =   'ScannerClass/**/*.{swift}'

s.resources      = ['ScannerClass/*.{storyboard,xib}',
'ScannerClass/*.xcassets']

s.preserve_paths = 'ScannerClass/*'

end
