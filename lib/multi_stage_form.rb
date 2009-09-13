module MultiStageForms
  module ActiveRecord
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def multi_stage_form(options = {})
        self.validates_on_stage = options[:validates_on_stage] || []
        self.stages = options[:stages] || 0
      end

      def partial_data
        @partial_data
      end

      def partial_data= pd
        @partial_data = pd
      end

      def get_partial_data_from_session
        unless(partial_data.blank?)
          data = partial_data
        else
          data = self.new
        end
        data
      end

      def partial_create(params)
        model = self.get_partial_data_from_session
        model.attributes = params
        model
      end
      
      def stages=(s)
        @@stages = s
      end

      def stages
        @@stages
      end

      def validates_on_stage=(v)
        @@validates_on_stage = v
      end

      def validates_on_stage
        @@validates_on_stage
      end
    end
  end

  module ActionController
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def multi_stage_form(options = {})
      end
    end

    module InstanceMethods
      def msf_new(current_step)
        current_step = current_step || 1
        if(current_step.to_i == 1)
          session[:partial_data] = nil
        end
        model_class_name = controller_name.singularize.camelize
        model = Kernel.const_get(model_class_name)
        model.partial_data = session[:partial_data]
        model_instance = model.get_partial_data_from_session
        model_instance.current_stage = current_step
        model_instance
      end

      def msf_create(model_attr)
        model_class_name = controller_name.singularize.camelize
        model = Kernel.const_get(model_class_name)
        model.partial_data = session[:partial_data]
        model_instance = model.partial_create(model_attr)
        model_instance.current_stage = model_attr[:current_stage]
        model_instance
      end

      def multi_stage_form(model, options = {})
        stage_name = "stage_#{model.current_stage}"
        class_name = model.class.to_s.downcase
        self.send(stage_name)if(respond_to?(stage_name))

        validates = model.class.validates_on_stage[model.current_stage.to_i] || []

        
        if(valid_for_attributes(model, validates))
          unless(model.nil?)
            session[:partial_data] = model
          end
          unless(model.current_stage.to_i == model.class.stages.to_i)
            redirect_to(eval("new_#{class_name}_path(:current_stage => model.current_stage.to_i + 1)"))
          else
            model = get_partial_data_from_session
            model.save
            session[:partial_data] = nil
            redirect_to(eval("#{class_name.pluralize}_path"))
          end
        else
          render(:action => "new")
        end
      end


      def save_partial_data_in_session
      end

      def get_partial_data_from_session
        unless(session[:partial_data].nil?)
          data = session[:partial_data] 
        else
          data = self.new
        end
        data
      end

      def valid_for_attributes(model, attributes)
        puts "DDDDDDDDDDDDDD"
        puts model.valid?.inspect
        puts attributes.inspect

        unless(model.valid?)
          attributes = attributes.map{ |x| x.to_s }
          errors = model.errors
          our_errors = []
          errors.each do |attr, error|
            if(attributes.include?(attr))
              our_errors << [attr, error]
            end
          end
          errors.clear
          our_errors.each do |attr, error|
            errors.add(attr, error)
          end
          return false unless errors.empty?
        end
        return true
      end
    end
  end
end

