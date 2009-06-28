RAILS_ENV = 'test'

#set up test enviroment
require( File.expand_path( File.join( File.dirname( __FILE__ ), '../../../../config/environment.rb' ) ) )
require( 'test/unit' )

#load test schema
load( File.dirname( __FILE__ ) + "/schema.rb" )

#load test model
require( File.join( File.dirname( __FILE__ ), 'models/test_model' ) )
