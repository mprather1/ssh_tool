class Object
  def values_at(*attributes)
    attributes.map { |attribute| send(attribute) }
  end
end