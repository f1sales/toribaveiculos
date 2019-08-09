require "toribaveiculos/version"

require "f1sales_custom/parser"
require "f1sales_custom/source"
require "f1sales_helpers"

module Toribaveiculos
  class Error < StandardError; end
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
