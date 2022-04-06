require 'webmock/rspec'
require 'ostruct'
require 'byebug'

RSpec.describe F1SalesCustom::Hooks::Lead do

  let(:lead) do
    lead = OpenStruct.new
    lead.source = source
    lead.product = product
    lead.customer = customer
    lead.message = 'prefere_ser_atendido_pela_pompeia_ou_pirituba?: pompeia'

    lead
  end

  let(:customer) do
    customer = OpenStruct.new
    customer.name = 'Marcio'
    customer.phone = '1198788899'
    customer.email = 'marcio@f1sales.com.br'

    customer
  end

  let(:product) do
    product = OpenStruct.new
    product.name = 'São Paulo - BF - novo formulario'

    product
  end

  let(:source) do
    source = OpenStruct.new
    source.name = 'Facebook - Toriba Veículos Volkswagen'

    source
  end
  
  let(:switch_source) { described_class.switch_source(lead) }
  let(:call_url) { 'https://toribapompeia.f1sales.org/public/api/v1/leads' }
  let(:lead_payload) do
    {
      lead: {
        message: lead.message,
        customer: {
          name: customer.name,
          email: customer.email,
          phone: customer.phone
        },
        product: {
          name: product.name
        },
        source: {
          name: source.name
        }
      }
    }
  end

  context 'when is not from facebook' do
    before do
      source.name = 'Webmotors'
    end

    it 'do not call torimbapompeia api' do
      switch_source
      expect(WebMock).to_not have_requested(:post, call_url).with(body: lead_payload) 
    end
  
    it 'returns source name' do
      expect(switch_source).to eq(source.name)
    end
  end

  context 'when came from facebook' do
    context 'when is to pirituba' do
      before do 
        lead.message = 'prefere_ser_atendido_pela_pompeia_ou_pirituba?: pirituba'
      end

      it 'do not call torimbapompeia api' do
        switch_source
        expect(WebMock).to_not have_requested(:post, call_url).with(body: lead_payload) 
      end

      it 'returns source name' do
        expect(switch_source).to eq(source.name)
      end
    end

    context 'when is to pompeia' do

      before do
        stub_request(:post, call_url)
          .with(body: lead_payload.to_json).to_return(status: 200, body: '', headers: {})
      end

      it 'creates the lead at the pompeia store' do
        switch_source
        expect(WebMock).to have_requested(:post, call_url).with(body: lead_payload)
      end

      it 'returns source name' do
        expect(switch_source).to be_nil
      end
    end
  end
end