class TestModel < ActiveRecord::Base
  attr_accessor( :current_stage )

=begin
  multi_stage_form(
    :validates_on_stage => {
      1 => [:name_1],
      2 => [:name_2],
      3 => [:name_3],
      4 => [:name_4]
    },
    :stages => 4
    #:current_stage => params[:post][:current_stage],
    #:model_name => :post
  )
=end
end
