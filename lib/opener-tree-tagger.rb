module Opener
  module TreeTagger
    VERSION = "0.10.0"

    class Configuration
      CORE_DIR    = File.expand_path("../core", File.dirname(__FILE__))
      KERNEL_CORE = CORE_DIR+'/tt_from_kaf_to_kaf.py'
    end
  end
end

KERNEL_CORE=Opener::TreeTagger::Configuration::KERNEL_CORE
