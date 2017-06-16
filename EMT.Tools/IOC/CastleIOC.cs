using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Castle.Windsor;
using Castle.Windsor.Installer;
using System.IO;
namespace EMT.Tools
{
    public class CastleIOC:IIOC
    {
        readonly static string windsorConfigFileExt = ".IOC.config";
        static Dictionary<string, WindsorContainer> windsorMap = new Dictionary<string, WindsorContainer>();
        static readonly string filterAll = "ALL";
        static WindsorContainer curWc = null;
        static CastleIOC()
        {
            
        }

        static WindsorContainer Windsor(string cfgFileFilter = "", bool reUse = true)
        {
            string cfgFileFilterKey = string.IsNullOrWhiteSpace(cfgFileFilter) ? filterAll : cfgFileFilter;
            if (reUse && windsorMap.ContainsKey(cfgFileFilterKey))
                return windsorMap[cfgFileFilterKey];
            //需要重新创建
            string asseblyDir = Utils.ExeAssemblyPath;
            string[] cfgFiles = Directory.GetFiles(asseblyDir, "*" + windsorConfigFileExt);
            WindsorContainer wc = new WindsorContainer();
            foreach (var cf in cfgFiles)
            {
                if (cfgFileFilterKey.Equals(filterAll) || cf.Contains(cfgFileFilterKey))
                {
                    wc.Install(Configuration.FromXmlFile(cf));
                    if (Lgr.IsInfoEnabled)
                        Lgr.Info(string.Format("\r\n...Castel.Windsor Install IOC in file : {0}.", cf));
                }
            }
            if (!windsorMap.ContainsKey(cfgFileFilterKey))
            {
                windsorMap[cfgFileFilterKey] = wc;
            }
            return wc;
        }

        public T Resolve<T>()
        {
            try
            {
                return curWc.Resolve<T>();
            }
            catch (Exception ex)
            {
                Lgr.Error(ex);
            }
            return default(T);
        }

        public T Resolve<T>(string key)
        {
            try
            {
                return curWc.Resolve<T>(key);
            }
            catch (Exception ex)
            {
                Lgr.Error(ex);
            }
            return default(T);
        }

    }
}
