assets_are_in "#{::Scribe.root_path}/assets"

asset 'scribe.min.js' do |a|
	a.scan 'scripts/coffee'
	a.toolchain :coffeescript, :require
	a.post_build :closure
end
