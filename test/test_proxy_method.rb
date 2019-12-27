require 'minitest/autorun'
require 'proxy_method'
require_relative './samples/animal'

class ProxyMethodTest < MiniTest::Test
  describe "proxying class methods" do
    it "does not allow original method name to be called" do
      exception = assert_raises StandardError do
        Turtle.create
      end

      assert_equal "Don't Create directly, use Interactor!", exception.message
    end

    it "allows proxied method name to be called" do
      assert 'created', Turtle.unproxied_create
    end

    it "does not confuse proxied class method with instance method" do
      assert_raises NoMethodError do
        Turtle.save
      end

      assert_raises NoMethodError do
        Turtle.unproxied_save
      end
    end

    it "provides default error message" do
      exception = assert_raises StandardError do
        DefaultDuck.create
      end

      assert_equal "Disabled by proxy_method", exception.message
    end

    it "allows an alternate block to be run instead of an exception" do
      assert_equal 'indirectly created!', MethodicalMeerkat.create
    end

    it "allows for multiple methods to be proxied in one call" do
      exception = assert_raises StandardError do
        MultiMonkey.create
      end

      assert_equal "Disabled by proxy_method", exception.message

      exception = assert_raises StandardError do
        MultiMonkey.destroy_all
      end

      assert_equal "Disabled by proxy_method", exception.message
    end

    it "allows multiple methods to be specified as a list of arguments" do
      exception = assert_raises StandardError do
        ListyLeopard.create
      end

      assert_equal "Disabled by proxy_method", exception.message

      exception = assert_raises StandardError do
        ListyLeopard.destroy_all
      end

      assert_equal "Disabled by proxy_method", exception.message
    end

    it "allows for a custom prefix" do
      exception = assert_raises StandardError do
        PrefixPelican.create
      end

      assert_equal "Disabled by proxy_method", exception.message

      assert 'created', PrefixPelican.pelican_create
    end

    describe "unproxied class" do
      it "allows methods to be called directly" do
        assert_equal 'created feathers', MultiMonkey.unproxied.create('feathers')

        # ensure that it doesn't affect any other classes
        exception = assert_raises StandardError do
          DefaultDuck.create('feathers')
        end

        assert_equal "Disabled by proxy_method", exception.message
      end

      it "handles arguments and blocks" do
        assert_equal 13, ArgumentativeAardvark.unproxied.blocky(6, 7){ |a, b| a + b }
      end

      it "handles custom prefixes" do
        assert_equal 'created', PrefixPelican.unproxied.create
      end
    end

    it "leaves the original proxied" do
      duck_unproxied = DefaultDuck.unproxied
      duck_proxied = DefaultDuck

      assert_equal 'created', duck_unproxied.create

      assert_raises StandardError do
        duck_proxied.create
      end
    end
  end

  describe "proxying instance methods" do
    it "does not allow original method name to be called" do
      exception = assert_raises StandardError do
        Turtle.new.save
      end

      assert_equal "Don't Save directly, use Interactor!", exception.message
    end

    it "allows proxied method name to be called" do
      assert 'saved', Turtle.new.unproxied_save
    end

    it "does not confuse proxied class method with instance method" do
      assert_raises NoMethodError do
        Turtle.new.create
      end

      assert_raises NoMethodError do
        Turtle.new.unproxied_create
      end
    end

    it "aliases proxy_method to proxy_instance_method" do
      exception = assert_raises StandardError do
        Turtle.new.update
      end

      assert_equal "Don't Update directly, use Interactor!", exception.message
    end

    it "provides default error message" do
      exception = assert_raises StandardError do
        DefaultDuck.new.save
      end

      assert_equal "Disabled by proxy_method", exception.message
    end

    it "allows an alternate block to be run instead of an exception" do
      assert_equal 'indirectly saved!', MethodicalMeerkat.new.save
    end

    it "allows multiple methods to be proxied in one call" do
      exception = assert_raises StandardError do
        MultiMonkey.new.save
      end

      assert_equal "Disabled by proxy_method", exception.message

      exception = assert_raises StandardError do
        MultiMonkey.new.update
      end

      assert_equal "Disabled by proxy_method", exception.message
    end

    it "allows multiple methods to be specified as a list of arguments" do
      exception = assert_raises StandardError do
        ListyLeopard.new.save
      end

      assert_equal "Disabled by proxy_method", exception.message

      exception = assert_raises StandardError do
        ListyLeopard.new.update
      end

      assert_equal "Disabled by proxy_method", exception.message
    end

    it "allows for a custom prefix" do
      exception = assert_raises StandardError do
        PrefixPelican.new.save
      end

      assert_equal "Disabled by proxy_method", exception.message

      assert 'saved', PrefixPelican.new.pelican_save
    end
  end

  describe "unproxied instance" do
    it "allows methods to be called directly" do
      assert_equal 'updated feathers', MultiMonkey.new.unproxied.update('feathers')

      # ensure that it doesn't affect any other instances
      exception = assert_raises StandardError do
        MultiMonkey.new.update('feathers')
      end

      assert_equal "Disabled by proxy_method", exception.message
    end

    it "handles arguments and blocks" do
      assert_equal 13, ArgumentativeAardvark.new.unproxied.blocky(6, 7){ |a, b| a + b }
    end

    it "handles custom prefixes" do
      assert_equal 'saved', PrefixPelican.new.unproxied.save
    end

    it "leaves the original proxied" do
      duck_proxied = DefaultDuck.new
      duck_unproxied = duck_proxied.unproxied

      assert_equal 'saved', duck_unproxied.save

      assert_raises StandardError do
        duck_proxied.save
      end
    end
  end
end