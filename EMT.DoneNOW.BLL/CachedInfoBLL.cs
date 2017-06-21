using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.Tools;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.BLL
{
    // 缓存数据处理
    public class CachedInfoBLL
    {
        private static RedisCacheder redis = new RedisCacheder();

        public static UserInfoDto GetUserInfo(string token)
        {
            return redis.GetCache<UserInfoDto>(token);
        }

        public static void SetUserInfo(string token, UserInfoDto user, int minites)
        {
            redis.AddCache<UserInfoDto>(token, user, minites);
        }

        public static string GetToken(string refreshToken)
        {
            return redis.GetCache<string>(refreshToken);
        }

        public static void SetToken(string refreshToken, string token, int minites)
        {
            redis.AddCache<string>(refreshToken, token, minites);
        }

        public List<DictionaryEntryDto> GetDictionary(string dicname)
        {
            return null;
        }
    }
}
