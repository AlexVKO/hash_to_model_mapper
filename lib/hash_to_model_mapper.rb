# frozen_string_literal: true

require 'hash_to_model_mapper/version'

require 'active_support/core_ext/hash'
require 'active_support/core_ext/string'

module HashToModelMapper
  @registry = {}

  def self.register(model_name, type, mapper)
    @registry[model_name] ||= {}
    @registry[model_name][type] = mapper
  end

  def self.registry
    @registry
  end

  def self.defined_mappings_for(model_name)
    @registry[model_name]
  end

  def self.defined_fields_for(model_name)
    defined_mappings_for(model_name).values
      .map(&:attributes)
      .map(&:keys)
      .flatten
      .uniq
  end

  def self.define(&block)
    definition_proxy = DefinitionProxy.new
    definition_proxy.instance_eval(&block)
  end

  def self.call(model_name, type = nil, hash)
    fail("hash needs to be present") unless hash.present?

    instance = model_name.to_s.classify.constantize.new
    instance.readonly!
    mapper = registry[model_name][type] || fail("Mapper not defined for #{model_name} -> #{type}")
    attributes = mapper.attributes
    hash = hash.with_indifferent_access

    attributes.each do |attribute_name, path|
      value = hash.dig(*path)

      if (transformer = mapper.transformers[attribute_name])
        value = transformer.call(value)
      end
      instance.__send__("#{attribute_name}=", value)
    end

    instance
  end
end

class DefinitionProxy
  def mapper(model_name, type: :none, &block)
    mapper = Mapper.new
    mapper.instance_eval(&block)
    HashToModelMapper.register(model_name, type, mapper)
  end
end

class Mapper
  def initialize
    @transformers = {}
    @attributes = {}
  end

  attr_reader :attributes, :transformers

  def method_missing(name, *path, **args)
    @transformers[name] = args[:transform]
    @attributes[name] = path
  end
end