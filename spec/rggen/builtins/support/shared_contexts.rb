shared_context 'configuration common' do
  class ConfigurationDummyLoader < RgGen::InputBase::Loader
    self.supported_types  = [:txt]

    def self.load_data(data = nil)
      @load_data  = data  if data
      @load_data
    end

    def self.clear
      @load_data  = nil
    end

    def load_file(file)
      self.class.load_data
    end
  end

  def build_configuration_factory
    f         = RgGen.builder.build_factory(:configuration)
    f.loaders = [ConfigurationDummyLoader]
    f
  end

  def configuration_file
    'configuration.txt'
  end

  def dummy_configuration
    RgGen::InputBase::Component.new(nil)
  end

  def create_configuration(load_data = {})
    ConfigurationDummyLoader.load_data(load_data)
    build_configuration_factory.create(configuration_file)
  end

  after do
    ConfigurationDummyLoader.clear
  end
end

shared_context 'register_map common' do
  class RegisterMapDummyLoader < RgGen::InputBase::Loader
    self.supported_types  = [:txt]

    def self.load_data(data = nil)
      @load_data  = data  if data
      @load_data
    end

    def self.clear
      @load_data  = nil
    end

    def load_file(file)
      create_map(self.class.load_data, file)
    end
  end

  def build_register_map_factory
    f         = RgGen.builder.build_factory(:register_map)
    f.loaders = [RegisterMapDummyLoader]
    f
  end

  def build_register_block_factory
    build_register_map_factory.instance_variable_get(:@child_factory)
  end

  def position(sheet_name, row, column)
    RgGen::RegisterMap::GenericMap::Cell::Position.new(register_map_file, sheet_name, row, column)
  end

  def register_map_file
    'register_map.txt'
  end

  def create_register_map(configuration, data)
    RegisterMapDummyLoader.load_data(data)
    build_register_map_factory.create(configuration, register_map_file)
  end

  after do
    RegisterMapDummyLoader.clear
  end
end

shared_context 'bit field type common' do
  include_context 'register_map common'

  def set_load_data(data)
    all_data  = [
      [nil, nil, "block_0"],
      [nil, nil, 256      ],
      [nil, nil, nil      ],
      [nil, nil, nil      ]
    ]
    all_data.concat(data)
    RegisterMapDummyLoader.load_data("block_0" => all_data)
  end

  def build_bit_fields(data)
    set_load_data(data)
    @factory.create(configuration, register_map_file).bit_fields
  end

  let(:bit_fields) do
    build_bit_fields(load_data)
  end
end

shared_context 'rtl common' do
  def build_rtl_factory
    RgGen.builder.build_factory(:rtl)
  end

  def have_parameter(*expectation)
    handle_name, attributes = expectation.last(2)
    attributes[:name     ]  ||= handle_name.to_s
    attributes[:parameter_type] = :parameter
    have_identifier(*expectation).and have_parameter_declaration(attributes)
  end

  def have_input(*expectation)
    handle_name, attributes = expectation.last(2)
    attributes[:name     ]  ||= handle_name.to_s
    attributes[:direction]  = :input
    have_identifier(*expectation).and have_port_declaration(attributes)
  end

  def have_output(*expectation)
    handle_name, attributes = expectation.last(2)
    attributes[:name     ]  ||= handle_name.to_s
    attributes[:direction]  = :output
    have_identifier(*expectation).and have_port_declaration(attributes)
  end

  def have_logic(*expectation)
    handle_name, attributes = expectation.last(2)
    attributes[:name]  ||= handle_name.to_s
    attributes[:data_type]  = :logic
    have_identifier(*expectation).and have_signal_declaration(attributes)
  end
end

shared_context 'ral common' do
  def build_ral_factory
    RgGen.builder.build_factory(:ral)
  end

  def have_sub_model(model_class, name, attributes = {})
    have_sub_model_declaration(attributes.merge(data_type: model_class, name: name, random: true))
  end
end
