ActiveRecord::Schema.define( :version => 0 ) do
  create_table( "test_models", :force => true ) do |t|
    t.string( :name_1 )
    t.string( :name_2 )
    t.string( :name_3 )
    t.string( :name_4 )
  end
end
