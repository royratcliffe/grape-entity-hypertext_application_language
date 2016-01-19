require 'grape_entity/entity'

module Grape
  class Entity
    def to_hal(env: {})
      representation = HypertextApplicationLanguage::Representation.new

      rel = object.class.table_name
      representation.with_link(HypertextApplicationLanguage::Link::SELF_REL, "#{rel}/#{object.id}")

      object.class.reflections.each do |name, reflection|
        href = unless %i(has_one belongs_to).include?(reflection.macro) && (association = object.send(name))
                 "#{representation.link.href}/#{name}"
               else
                 "#{reflection.plural_name}/#{association.id}"
               end
        representation.with_link(name, href)
      end

      representation.properties = serializable_hash

      representation
    end
  end
end
