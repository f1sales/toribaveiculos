require 'toribaveiculos/version'

require 'f1sales_custom/parser'
require 'f1sales_custom/source'
require 'f1sales_custom/hooks'
require 'f1sales_helpers'
require 'http'

module Toribaveiculos
  class Error < StandardError; end

  class F1SalesCustom::Hooks::Lead
    class << self
      def switch_source(lead)
        @lead = lead
        return source_name unless source_name.include?('Facebook') && lead.message.split(':').last&.include?('pompeia')

        HTTP.post('https://toribapompeia.f1sales.org/public/api/v1/leads', json: lead_payload)

        nil
      end

      private

      def lead_payload
        {
          lead: {
            message: message,
            customer: customer,
            product: product,
            source: source
          }
        }
      end

      def source_name
        @lead.source.name
      end

      def source
        {
          name: source_name
        }
      end

      def lead_customer
        @lead.customer
      end

      def customer
        {
          name: lead_customer.name,
          email: lead_customer.email,
          phone: lead_customer.phone
        }
      end

      def lead_product
        @lead.product
      end

      def product
        {
          name: lead_product.name
        }
      end

      def message
        @lead.message
      end
    end
  end

  class F1SalesCustom::Email::Source
    def self.all
      [
        {
          email_id: 'website',
          name: 'Website - Novos'
        },
        {
          email_id: 'website',
          name: 'Website - Seminovos'
        }
      ]
    end
  end

  class F1SalesCustom::Email::Parser
    def parse
      parsed_email = @email.body.colons_to_hash
      all_sources = F1SalesCustom::Email::Source.all
      source = all_sources[0]
      source = all_sources[1] if @email.subject.downcase.include?('seminovos')

      {
        source: {
          name: source[:name]
        },
        customer: {
          name: parsed_email['nome'],
          phone: parsed_email['telefone'].tr('^0-9', ''),
          email: parsed_email['email']
        },
        product: (parsed_email['interesse'] || ''),
        message: (parsed_email['menssage'] || parsed_email['mensagem']).gsub('-', ' ').gsub("\n", ' ').strip,
        description: parsed_email['assunto']
      }
    end
  end
end
