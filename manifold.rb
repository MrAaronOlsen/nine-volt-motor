class Manifold

  attr_accessor :gravity_scalar
  attr_reader :impulse, :mtv

  def initialize(impulse, mtv)

    @impulse = impulse
    @mtv = mtv

    @gravity_scalar = 1.0

  end

end