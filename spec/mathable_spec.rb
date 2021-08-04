require 'spec_helper'

RSpec.describe Mathable do
  include Mathable

  it 'can add' do
    expect(add(1, 2)).to eq(3)
  end

  it 'can subtract' do
    expect(subtract(5, 4)).to eq(1)
  end

  it 'can find average' do
    expect(compute_average(5.0, 10)).to eq(0.5)
  end

  it 'can find percentage' do
    expect(percentage(5.0, 10)).to eq(50)
  end
end
