require( 'rake' )
require( 'rake/testtask' )
require( 'rake/rdoctask' )

desc( 'Default: run unit tests' )
task( :default => :test )

desc( 'Test multi_stage_form plugin' )
Rake::TestTask.new( :test ) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
