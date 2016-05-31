require 'spec_helper'

describe Rapis::Cli do
  it 'should be successful' do
    cli = Rapis::Cli.new
    actions = double('actions')
    allow(cli).to receive(:actions).and_return(actions)

    [
      :actions,
      :create,
      :convert,
      :list,
      :export,
      :diff,
      :apply,
      :deploy
    ].each do |c|
      allow(actions).to receive(c).and_return(nil)
      expect { cli.send(c) }.not_to raise_error
    end
  end
end
