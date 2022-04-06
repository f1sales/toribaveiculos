require "toribaveiculos/version"

require "f1sales_custom/parser"
require "f1sales_custom/source"
require "f1sales_custom/hooks"
require "f1sales_helpers"
require 'http'

module Toribaveiculos
  class Error < StandardError; end
  class F1SalesCustom::Hooks::Lead

    def self.switch_source(lead)
      source = lead.source
      source_name = source.name
      return source_name unless source_name.include?('Facebook') && lead.message.split(':').last.include?('pompeia')

      customer = lead.customer
      HTTP.post(
        'https://toribapompeia.f1sales.org/public/api/v1/leads',
        json: {
          lead: {
            message: lead.message,
            customer: {
              name: customer.name,
              email: customer.email,
              phone: customer.phone
            },
            product: {
              name: lead.product.name
            },
            source: {
              name: lead.source.name
            }
          }
        }
      )

      nil
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
        },
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
          name: source[:name],
        },
        customer: {
          name: parsed_email['nome'],
          phone: parsed_email['telefone'].tr('^0-9', ''),
          email: parsed_email['email']
        },
        product: (parsed_email['interesse'] || ''),
        message: (parsed_email['menssage'] || parsed_email['mensagem']).gsub('-', ' ').gsub("\n", ' ').strip,
        description: parsed_email['assunto'],
      }
    end
  end

end
