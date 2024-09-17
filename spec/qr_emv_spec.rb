# frozen_string_literal: true

RSpec.describe QrEmv::Parser do
  let(:static_raw_string) { '00020101021127610012com.p2pqrpay0111BOPIPHMMXXX0208999644030414000019990475795204601653036085802PH5910prettywife6011Makati City6304450F' }
  let(:dynamic_raw_string) { '00020101021227830012com.p2pqrpay0111GXCHPHM2XXX02089996440303152170200000006560417DWQM4TK3JDNWFBLF452046016530360854071000.005802PH5910JE****Y D.6006Tabang610412346304AE16' }

  subject do
    described_class.new(raw_string: static_raw_string)
  end

  it "has a version number" do
    expect(QrEmv::VERSION).not_to be nil
  end

  it 'parses merchant information' do
    expect(subject.root['27']).to eq('0012com.p2pqrpay0111BOPIPHMMXXX020899964403041400001999047579')
  end

  it 'payment system' do
    expect(subject.merchant_info['00']).to eq('com.p2pqrpay')
  end

  it 'id not exists' do
    expect(subject.merchant_info['77']).to eq(nil)
  end
end
