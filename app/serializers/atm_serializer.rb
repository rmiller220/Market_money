class AtmSerializer
  include JSONAPI::Serializer
  attributes :distance, :address, :lon, :lat, :name
end
