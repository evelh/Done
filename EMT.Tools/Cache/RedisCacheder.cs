using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StackExchange.Redis;
using StackExchange.Redis.Extensions.Core;
using StackExchange.Redis.Extensions.Core.Configuration;
using StackExchange.Redis.Extensions.Newtonsoft;
namespace EMT.Tools
{
    public class RedisCacheder:ICacheder,IDisposable
    {
        private ConnectionMultiplexer _pool = ConnectionMultiplexer.Connect(ConnectionString);

        private ICacheClient _redisClient;
        /// <summary>
        /// 连接字符串
        /// </summary>
        private static string ConnectionString
        {
            get
            {
                return ToolsConfig.RedisConnect;
            }
        }
        public RedisCacheder()
        {
        }

        public int DB { get; set; }
        public RedisCacheder(int db)
        {
            DB = db;
        }

        private ICacheClient RedisClient
        {
            get
            {
                if (_redisClient == null)
                {
                    var serializer = new NewtonsoftSerializer();
                    _redisClient = new StackExchangeRedisCacheClient(_pool, serializer);
                }
                return _redisClient;
            }
        }

        public void AddCache<T>(string key, T value, DateTime expire)
        {
            if (value == null)
            {
                RemoveCache(key);
            }
            else
            {
                RedisClient.Add<T>(key, value, expire);
            }
        }

        public void AddCache<T>(string key, T value, int minutes)
        {
            AddCache<T>(key, value, DateTime.Now.AddMinutes(minutes));
        }

        public T Dequeue<T>(string key) where T : class
        {
            return RedisClient.ListGetFromRight<T>(key);
        }

        public void Enqueue<T>(string key, T t) where T : class
        {
            RedisClient.ListAddToLeft<T>(key, t);
        }

        public T GetCache<T>(string key)
        {
            return RedisClient.Get<T>(key);
        }
        public T GetOrAdd<T>(string key, Func<T> funcNewVal, int cacheSecs = 60)
        {
            var cKey1 = key;
            var objs = GetCache<T>(cKey1);
            if (objs == null)
            {
                objs = funcNewVal();
                if (objs != null)
                {
                    AddCache(cKey1, objs, DateTime.Now.AddSeconds(cacheSecs));
                }
            }
            return objs;

        }

        public long QueueLength(string key)
        {
            return RedisClient.Database.ListLength(key);
        }

        public void RemoveCache(string key)
        {
            RedisClient.Remove(key);
        }


        public void RemoveCacheByPrefix(string keyPrefix)
        {
            var keys = RedisClient.SearchKeys(keyPrefix + "*");
            RedisClient.RemoveAll(keys);
        }

        public void AddCache<T>(string key, T value)
        {
            if (value == null)
            {
                RemoveCache(key);
            }
            else
            {
                RedisClient.Add<T>(key, value);
            }
        }
        private static int _timeOut = 1440;
        public static int TimeOut
        {
            get
            {
                return _timeOut;
            }

            set
            {
                _timeOut = value;
            }
        }
        public T GetCache<T>(string key, int minutes, AddCache<T> addcache)
        {
            T t = GetCache<T>(key);
            if (t == null && addcache != null)
            {
                t = addcache();
                minutes = minutes > 0 ? minutes : TimeOut;
                AddCache<T>(key, t, minutes);
            }
            return t;
        }

        #region 资源清理

        public void Dispose()
        {
            ClearResource(true);
            GC.SuppressFinalize(this);//告诉GC这个对象已经不需要再次回收了
        }

        ~RedisCacheder()
        {
            ClearResource(false);
        }


        /// <summary>
        /// 清理资源
        /// </summary>
        /// <param name="isInvokeDispose"></param>
        protected virtual void ClearResource(bool isInvokeDispose)
        {
            if (!IsDisposed)
            {
                if (isInvokeDispose)
                {
                    // 释放托管资源
                    RedisClient.Dispose();
                    _pool.Dispose();
                }

                // 释放非托管资源

                IsDisposed = true;
            }
        }


        private bool IsDisposed;

        #endregion

        public T GetSessionCache<T>(string key, int sessionTime = 40)
        {
            var rs = RedisClient.Get<T>(key);
            var timespan = DateTime.Now.AddMinutes(sessionTime) - DateTime.Now;
            RedisClient.Database.KeyExpire(key, timespan);
            return rs;
        }

        public IList<string> FindKeys(string filter)
        {
            return RedisClient.SearchKeys(filter).ToList();
        }
    }
}
