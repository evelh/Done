using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using log4net;
using System.IO;
using System.Configuration;
namespace EMT.Tools
{
    public static class Lgr
    {
        private static ILog _log = null;
        /// <summary>
        /// 获取在配置文件中的log4net配置对象
        /// </summary>
        private static ILog Log
        {
            get
            {
                return _log;
            }
        }
        /// <summary>
        /// 初始化log4net
        /// </summary>
        static Lgr()
        {
            InitLog4Net();
        }
        /// <summary>
        /// 初始化log4net
        /// </summary>
        private static void InitLog4Net()
        {
            GlobalContext.Properties["AppTag"] = ConfigurationManager.AppSettings["AppTag"].EmptyRep("AppSettings[AppTag] not exist!");
            string path = Utils.ExeAssemblyPath;
            FileInfo fiLog = new FileInfo(string.Format("{0}log4net.config", path));
            log4net.Config.XmlConfigurator.Configure(fiLog);
            _log = LogManager.GetLogger("log4netMainLogger");
        }

        #region error level
        public static void Error(object msg)
        {
            if (_log.IsErrorEnabled)
                _log.Error(msg);
        }
        public static bool IsErrorEnabled
        {
            get { return _log.IsErrorEnabled; }
        }
        public static void Error(Exception ex)
        {
            Error(ex.Message, ex);
        }
        public static void Error(object msg, Exception ex)
        {
            if (_log.IsErrorEnabled)
            {
                _log.Error(msg, ex);
                Exception exInner = ex.InnerException;
                while (exInner != null)
                {
                    _log.Error(exInner.Message, exInner);
                    exInner = exInner.InnerException;
                }
            }
        }
        #endregion 

        #region debug level 
        public static void Debug(object msg)
        {
            if (_log.IsDebugEnabled)
            {
                _log.Debug(msg);
            }
        }
        public static void Debug(string msg)
        {
            _log.Debug(msg);
        }

        public static bool IsDebugEnabled
        {
            get { return _log.IsDebugEnabled; }
        }
        #endregion
        #region info level
        public static void Info(object msg)
        {
            if (_log.IsInfoEnabled)
                _log.Info(msg);
        }
        public static bool IsInfoEnabled
        {
            get { return _log.IsInfoEnabled; }
        }

        public static void Info(string msg)
        {
            if (_log.IsInfoEnabled)
                _log.Info(msg);
        }
        # endregion
    }
}
