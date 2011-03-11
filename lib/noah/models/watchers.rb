require 'digest/sha1'
module Noah
  class Watcher < Model #NYI
    # Don't trust anything in here yet
    # I'm still trying a few things
    include WatcherValidations

    attribute :pattern
    attribute :endpoint

    index :pattern
    index :endpoint

    def validate
      super
      assert_present :endpoint
      assert_present :pattern
      assert_unique [:endpoint, :pattern]
      assert_not_superset
      assert_not_subset
    end

    def name
      @name = Base64.encode64("#{pattern}|#{endpoint}").gsub("\n","")
    end

    def to_hash
      h = {:pattern => pattern, :name => name, :endpoint => endpoint, :created_at => created_at, :updated_at => updated_at}
      super.merge(h)
    end

    def self.watch_list
      arr = []
      watches = self.all.sort_by(:pattern)
      watches.each {|w| arr << w.name}
      arr
    end

    private
    # Not sure about these next two.
    # Could get around patterns changing due to namespace changes
    def path_to_pattern
    end

    def pattern_to_path
    end
  end

  class Watchers
    def self.all(options = {})
      options.empty? ? Watcher.all.sort : Watcher.find(options).sort
    end
  end
end