class Cart
  class << self
    
    def [](cart)
      redis.hget(hash, cart)
    end
    
    def []=(cart, id)
      if old = self[cart]
        redis.srem(set(old), cart)
      end
      redis.hset(hash, cart, id)
      redis.sadd(set(id), cart)
    end
    
    def destroy(id)
      redis.smembers(set(id)).each { |cart| redis.hdel(hash, cart) }
      redis.del(set(id))
    end
    
    private
    
      def redis
        $redis
      end

      def hash
        "cart_ids"
      end

      def set(id)
        "cart_items_#{id}"
      end
  end
end