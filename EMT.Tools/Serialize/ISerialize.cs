using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.Tools
{
    public interface ISerialize
    {
        T DeserializeJson<T>(string jsonStr);
        T DeserializeXml<T>(string xmlStr) where T : class;
        string SerializeJson(object obj);
        string SerializeXml(object obj);
        Dictionary<string, object> JsonToDictionary(string jsonData);
    }
}
