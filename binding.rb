class Bindings

    def initialize

        @controls = []
       
    end

    def add_control(key, action, rule = nil)

        @controls << { key => { action => rule } }

    end

    def check_controls(body)

        @controls.each { |control|
            control.each { |control, action|
                
                if Gosu.button_down?(control)
                    
                    action.each { |action, rule|
                        
                        if rule.nil?
                            body.add_force(action)
                        elsif body.send(rule)
                            body.add_force(action)
                        end

                    }
                end
            }
        }
    end

end