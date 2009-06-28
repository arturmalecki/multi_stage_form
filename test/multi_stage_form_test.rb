require( 'test_helper' )

class MultiStageForm < ActiveSupport::TestCase
  def test_should_set_initial_data
    set_test_model

    assert_equal( TestModel.stages, 4 )
    assert( TestModel.validates_on_stage )
  end

  protected

  def set_test_model( options = {} )
    TestModel.send( :multi_stage_form, {:stages => 4}.merge( options ) )
  end
end
