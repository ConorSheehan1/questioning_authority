require 'rdf'
module Qa::Authorities
  class Discogs
    module DiscogsUtils
      DISCOGS_GENRE_MAPPING = YAML.load_file(Rails.root.join("config", "discogs-genres.yml"))
      DISCOGS_FORMATS_MAPPING = YAML.load_file(Rails.root.join("config", "discogs-formats.yml"))

      # Constructs an RDF statement where the subject, predicate and object are all URIs
      def contruct_stmt_uri_object(subject, predicate, object)
        RDF::Statement(RDF::URI.new(subject), RDF::URI(predicate), RDF::URI.new(object))
      end

      # Constructs an RDF statement where the subject and predicate are URIs and the object is a literal
      def contruct_stmt_literal_object(subject, predicate, object)
        RDF::Statement(RDF::URI.new(subject), RDF::URI(predicate), RDF::Literal.new(object))
      end

      # frequently used predicates and objects
      def rdf_type_predicate
        RDF::URI("http://www.w3.org/1999/02/22-rdf-syntax-ns#type")
      end

      def rdfs_label_predicate
        RDF::URI("http://www.w3.org/2000/01/rdf-schema#label")
      end

      def bf_main_title_predicate
        RDF::URI("http://id.loc.gov/ontologies/bibframe/mainTitle")
      end

      def bf_agent_predicate
        RDF::URI("http://id.loc.gov/ontologies/bibframe/agent")
      end

      def bf_agent_type_object
        RDF::URI("http://id.loc.gov/ontologies/bibframe/Agent")
      end

      def bf_role_predicate
        RDF::URI("http://id.loc.gov/ontologies/bibframe/role")
      end

      def bf_role_type_object
        RDF::URI("http://id.loc.gov/ontologies/bibframe/Role")
      end

      def discogs_genres
        DISCOGS_GENRE_MAPPING
      end

      def discogs_formats
        DISCOGS_FORMATS_MAPPING
      end

      # both the work and the instance require a statement for the release year
      def build_year_statements(response, type)
        year_stmts = []
        if type == "Work" && response["year"].present?
          year_stmts = get_year_rdf(type + "1", response["year"])
        elsif response["released"].present?
          year_stmts = get_year_rdf(type + "1", response["released"])
        end
        year_stmts # w/out this line, building the graph throws an undefined method `graph_name=' error
      end

      def get_year_rdf(type, year)
        year_stmts = []
        year_stmts << contruct_stmt_uri_object(type, "http://id.loc.gov/ontologies/bibframe/provisionActivity", "#{type}ProvisionActivityDate")
        year_stmts << contruct_stmt_uri_object("#{type}ProvisionActivityDate", rdf_type_predicate, "http://id.loc.gov/ontologies/bibframe/ProvisionActivity")
        # Full RDF statement syntax as this one requires a datatype
        year_stmts << RDF::Statement(RDF::URI.new("#{type}ProvisionActivityDate"), RDF::URI("http://id.loc.gov/ontologies/bibframe/date"), RDF::Literal.new(year.to_s, datatype: RDF::XSD.date))
      end
    end
  end
end
