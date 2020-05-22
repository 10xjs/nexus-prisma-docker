import { schema } from "nexus"
import { GraphQLDateTime } from "graphql-iso-date"

schema.scalarType({
  name: "DateTime",
  serialize: GraphQLDateTime.serialize,
  parseValue: GraphQLDateTime.parseValue,
  parseLiteral: GraphQLDateTime.parseLiteral,
})
