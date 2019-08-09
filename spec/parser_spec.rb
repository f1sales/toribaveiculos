require 'ostruct'
require "f1sales_custom/parser"
require "f1sales_custom/source"

RSpec.describe F1SalesCustom::Email::Parser do

  context 'when is about an used vechicle' do
    let(:email) do
      email = OpenStruct.new
      email.to = [email: 'website@lojateste.f1sales.org']
      email.subject = 'Contato Site - Página SEMINOVOSVOLKSWAGEN VOYAGE 1 6 MI 8V 2 - (Renata da Silva Alves)'
      email.body = "*Erro! O nome de arquivo não foi especificado.*\n\n\nContato via site\n\n*Nome:*\n\nMarcia Maria Saitow\n\n*Telefone:*\n\n(11) 9 8107-8901\n\n*Loja:*\n\nPirituba\n\n*E-mail:*\n\nmarcia.saitow@ig.com.br\n\n*Assunto:*\n\nPágina Inicial\n\n*Menssage:*\n\nO Gol favorito do Palmeiras foi do Felipe Melo de cabeça hoje !!!! Contra o\nCorinthians\n\n-----------------------------------------------------------------------\n\n*Origem da Conversão:*\n\nhttps://toribaveiculos.com.br/\n<https://u9431073.ct.sendgrid.net/wf/click?upn=-2BGANwhBshWTYRvRmQ7LUjS5MsEVmNRQhQxSoVS7sqnB-2BfAG6pQr5uxUN-2BmYegSPp_h6nWyeToXnqMsIU1A0QF8UHWrVd0iVb6LqacU2zltm44MBlIqJOAlc5nexk9dVzO9Mhu2o30CzifycbpQ6ApGc5hrtcdOnW36NwRzUH3PNtC1otx3R2VaQt5lOjnFmIEdal26cF4ahkBjHa5JhB0cR4qN-2FvQwOGsswT4Y2HzYXVP9Y-2BR79NaBEXX6jYXc6BvzB5S-2F8jc037Z3c6Mzjs1uznU4gB-2FJeuSXNRUDf1qkPw-3D>\n\n\n\n\n\n*Mensagem de e-mail confidencial.*"

      email
    end

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains website novos as source name' do
      expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[1][:name])
    end

  end

  context 'when is about new vechicle' do

    let(:email) do
      email = OpenStruct.new
      email.to = [email: 'website@lojateste.f1sales.org']
      email.subject = 'Contato Site - Página ZERO KMNOVO POLO - (Sidney)'
      email.body = "*Erro! O nome de arquivo não foi especificado.*\n\n\nContato via site\n\n*Nome:*\n\nMarcia Maria Saitow\n\n*Telefone:*\n\n(11) 9 8107-8901\n\n*Loja:*\n\nPirituba\n\n*E-mail:*\n\nmarcia.saitow@ig.com.br\n\n*Assunto:*\n\nPágina Inicial\n\n*Interesse:*\n\nZero KM - Novo Polo - 1.0\n\n*Menssage:*\n\nO Gol favorito do Palmeiras foi do Felipe Melo de cabeça hoje !!!! Contra o\nCorinthians\n\n-----------------------------------------------------------------------\n\n*Origem da Conversão:*\n\nhttps://toribaveiculos.com.br/\n<https://u9431073.ct.sendgrid.net/wf/click?upn=-2BGANwhBshWTYRvRmQ7LUjS5MsEVmNRQhQxSoVS7sqnB-2BfAG6pQr5uxUN-2BmYegSPp_h6nWyeToXnqMsIU1A0QF8UHWrVd0iVb6LqacU2zltm44MBlIqJOAlc5nexk9dVzO9Mhu2o30CzifycbpQ6ApGc5hrtcdOnW36NwRzUH3PNtC1otx3R2VaQt5lOjnFmIEdal26cF4ahkBjHa5JhB0cR4qN-2FvQwOGsswT4Y2HzYXVP9Y-2BR79NaBEXX6jYXc6BvzB5S-2F8jc037Z3c6Mzjs1uznU4gB-2FJeuSXNRUDf1qkPw-3D>\n\n\n\n\n\n*Mensagem de e-mail confidencial.*"

      email
    end

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains website novos as source name' do
      expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[0][:name])
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('Marcia Maria Saitow')
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('marcia.saitow@ig.com.br')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('11981078901')
    end

    it 'contains product' do
      expect(parsed_email[:product]).to eq('Zero KM - Novo Polo - 1.0')
    end

    it 'contains description' do
      expect(parsed_email[:description]).to eq('Página Inicial')
    end

    it 'contains message' do
      expect(parsed_email[:message]).to eq('O Gol favorito do Palmeiras foi do Felipe Melo de cabeça hoje !!!! Contra o Corinthians')
    end

  end
end
