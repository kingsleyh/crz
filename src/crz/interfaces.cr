module CRZ
  module Functor(A)
    abstract def map(&block : A -> B) : Functor forall B

    def replace(other : Functor(B), v : A) : Functor(A)
      map { |_| v }
    end
  end

  module Applicative(A)
    include Functor(A)

    abstract def ap(func : Applicative(A -> B)) : Applicative forall B

    def *(func : Applicative(A -> B)) : Applicative forall B
      ap(func)
    end

    def self.of(value : A) : Applicative(A) forall A
      raise "of method unimplemented"
    end
  end

  module Monad(A)
    include Applicative(A)

    abstract def bind(&block : A -> Monad(B)) : Monad forall B

    def ap(func : Applicative(A -> B)) : Applicative forall B
      func.bind do |f|
        self.map &f
      end
    end

    def map(&block : A -> B) : Monad forall B
      bind do |x|
        typeof(self).of(block.call x)
      end
    end

    def >=(block : A -> Monad(B)) : Monad forall B
      bind do |x|
        block.call(x)
      end
    end

    def >>(other : Monad(B)) : Monad forall B
      bind { |_| other }
    end

    def <<(other : Monad(B)) : Monad forall B
      bind { |v|
        other.map {|_|
          v
        }
      }
    end
  end
end
