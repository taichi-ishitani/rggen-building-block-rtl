require_relative 'builtins/loaders/configuration/json_loader'
require_relative 'builtins/loaders/configuration/yaml_loader'
require_relative 'builtins/loaders/register_map/csv_loader'
require_relative 'builtins/loaders/register_map/xls_loader'
require_relative 'builtins/loaders/register_map/xlsx_ods_loader'

require_relative 'builtins/global/address_width'
require_relative 'builtins/global/data_width'

require_relative 'builtins/bit_field/bit_assignment'
require_relative 'builtins/bit_field/field_model_creation'
require_relative 'builtins/bit_field/field_model_declaration'
require_relative 'builtins/bit_field/initial_value'
require_relative 'builtins/bit_field/name'
require_relative 'builtins/bit_field/reference'
require_relative 'builtins/bit_field/type'
require_relative 'builtins/bit_field/rw'
require_relative 'builtins/bit_field/ro'
require_relative 'builtins/bit_field/wo'
require_relative 'builtins/bit_field/reserved'

require_relative 'builtins/register/accessibility'
require_relative 'builtins/register/address_decoder'
require_relative 'builtins/register/array'
require_relative 'builtins/register/field_model_creator'
require_relative 'builtins/register/field_model_declarations'
require_relative 'builtins/register/offset_address'
require_relative 'builtins/register/name'
require_relative 'builtins/register/read_data'
require_relative 'builtins/register/reg_model_constructor'
require_relative 'builtins/register/reg_model_creation'
require_relative 'builtins/register/reg_model_declaration'
require_relative 'builtins/register/reg_model_definition'
require_relative 'builtins/register/shadow'
require_relative 'builtins/register/shadow_index_configurator'
require_relative 'builtins/register/uniqueness_validator'

require_relative 'builtins/register_block/base_address'
require_relative 'builtins/register_block/block_model_constructor'
require_relative 'builtins/register_block/block_model_default_map_creator'
require_relative 'builtins/register_block/byte_size'
require_relative 'builtins/register_block/clock_reset'
require_relative 'builtins/register_block/host_if'
require_relative 'builtins/register_block/apb'
require_relative 'builtins/register_block/module_definition'
require_relative 'builtins/register_block/name'
require_relative 'builtins/register_block/reg_model_creator'
require_relative 'builtins/register_block/reg_model_declarations'
require_relative 'builtins/register_block/response_mux'
require_relative 'builtins/register_block/signal_declarations'
