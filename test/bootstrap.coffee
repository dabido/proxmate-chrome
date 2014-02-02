tests = []
for file in Object.keys(window.__karma__.files)
  if /test\.js$/.test(file)
    tests.push file

require.config
	baseUrl: '/base/src/js'
	paths:
    "text": "../../bower_components/requirejs-text/text"
    "jquery": "../../bower_components/jquery/jquery"

	# load all tests
	deps: tests

	# kick off karma
	callback: window.__karma__.start