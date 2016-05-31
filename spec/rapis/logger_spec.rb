require 'spec_helper'

describe Rapis::TermColor do
  describe '#green' do
    it 'should be a green terminal' do
      expect(Rapis::TermColor.green('foo')).to eq "\e[32mfoo\e[0m"
    end
  end

  describe '#yellow' do
    it 'should be a yellow terminal' do
      expect(Rapis::TermColor.yellow('foo')).to eq "\e[33mfoo\e[0m"
    end
  end

  describe '#red' do
    it 'should be a yellow terminal' do
      expect(Rapis::TermColor.red('foo')).to eq "\e[31mfoo\e[0m"
    end
  end
end

describe Rapis.logger do
  it 'should be a kind of Rapis::Logger' do
    expect(Rapis.logger).to be_kind_of Rapis::Logger
  end
end

describe Rapis::Logger do
  let(:logger) do
    Rapis::Logger.instance
  end

  it 'should output log' do
    expect { logger.debug('foo') }.not_to raise_error
    expect { logger.info('foo') }.not_to raise_error
    expect { logger.warn('foo') }.not_to raise_error
    expect { logger.fatal('foo') }.not_to raise_error
    expect { logger.error('foo', 'bar') }.not_to raise_error
  end
end
