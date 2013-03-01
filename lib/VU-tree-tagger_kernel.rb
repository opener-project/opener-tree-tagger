module Opener
   module Kernel
     module VU
       module TreeTagger
      		VERSION = "0.0.1"

      		class Configuration
        		CORE_DIR    = File.expand_path("../core", File.dirname(__FILE__))
        		KERNEL_CORE = CORE_DIR+'/treetagger.py'
      		end
    	end
    end
  end
end

KERNEL_CORE=Opener::Kernel::VU::TreeTagger::Configuration::KERNEL_CORE
