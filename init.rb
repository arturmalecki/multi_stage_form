require( "multi_stage_form" )
ActiveRecord::Base.send( :include, MultiStageForms::ActiveRecord )
ActionController::Base.send( :include, MultiStageForms::ActionController )
