using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.Tools
{
    public delegate T AddCache<T>();
    public interface ICacheder
    {
        /// <summary>
        /// 添加缓存
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="key"></param>
        /// <param name="t"></param>
        /// <param name="cachetime"></param>
        void AddCache<T>(string key, T value, int minutes);
        /// <summary>
        /// 添加不会过期的缓存
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="key"></param>
        /// <param name="value"></param>
        void AddCache<T>(string key, T value);
        /// <summary>
        /// 添加缓存
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="key"></param>
        /// <param name="value"></param>
        /// <param name="expire"></param>
        void AddCache<T>(string key, T value, DateTime expire);
        /// <summary>
        /// 移除缓存
        /// </summary>
        /// <param name="key"></param>
        void RemoveCache(string key);
        /// <summary>
        /// 取得缓存
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="key"></param>
        /// <returns></returns>
        T GetCache<T>(string key);
        T GetOrAdd<T>(string key, Func<T> funcNewVal, int cacheSecs = 60);
        /// <summary>
        /// 取得缓存，如果没有，则使用委托添加
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="key"></param>
        /// <param name="minutes"></param>
        /// <param name="addcache"></param>
        /// <returns></returns>
        T GetCache<T>(string key, int minutes, AddCache<T> addcache);
        /// <summary>
        /// 插入队列
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="key"></param>
        /// <param name="t"></param>
        void Enqueue<T>(string key, T t) where T : class;
        /// <summary>
        /// 从队列取出
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="key"></param>
        /// <returns></returns>
        T Dequeue<T>(string key) where T : class;
        /// <summary>
        /// 获取队列长度
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        long QueueLength(string key);
        /// <summary>
        /// 根据前缀删除缓存
        /// </summary>
        /// <param name="keyPrefix"></param>
        void RemoveCacheByPrefix(string keyPrefix);

        /// <summary>
        /// 获取缓存并重设缓存时间
        /// </summary>
        T GetSessionCache<T>(string key, int sessionTime = 40);
        /// <summary>
        /// 查询缓存key list
        /// </summary>
        /// <param name="filter"></param>
        /// <returns></returns>
        IList<string> FindKeys(string filter);

    }
}
