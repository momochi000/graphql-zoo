module GraphQL
  class AnimalSource < GraphQL::Source::ActiveRecordSource
    build_all

    #query_fields do
    #  field :dietary_requirements, String, array: true
    #end

    #def dietary_requirements
    #  object.dietary_requirements
    #end
  end
end
