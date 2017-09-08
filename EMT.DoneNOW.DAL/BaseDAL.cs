using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using Dapper.FastCrud;
using System.Reflection;

namespace EMT.DoneNOW.DAL
{
    public abstract class BaseDAL<T> where T : class
    {
        protected DapperHelper helper = new DapperHelper();
        private const int _pageSize = 15;     // 默认查询分页大小
        public IDbConnection GetDbConn()
        {
            OrmConfiguration.DefaultDialect = SqlDialect.MySql;
            return DapperHelper.BuildConnection();
        }

        /// <summary>
        /// 获取表所有数据行
        /// </summary>
        /// <returns></returns>
        public IList<T> FindAll()
        {
            using (var db = GetDbConn())
            {
                return db.Find<T>().ToList();
            }
        }

        /// <summary>
        /// 返回列表
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="param"></param>
        /// <returns></returns>
        public List<T> FindListBySql(string sql, object param = null)
        {
            return helper.GetList<T>(sql, param);
        }

        /// <summary>
        /// 根据id查找
        /// </summary>
        /// <returns></returns>
        public T FindById(long id)
        {
            string name = typeof(T).Name;
            return FindSignleBySql<T>($"SELECT * FROM {name} WHERE id=" + id);
        }

        /// <summary>
        /// 根据客户ID返回集合
        /// </summary>
        /// <param name="account_id"></param>
        /// <returns></returns>
        public List<T> FindByAccountId(long account_id)
        {
            string name = typeof(T).Name;
            return FindListBySql<T>($"SELECT * FROM {name} WHERE account_id={account_id} and delete_time = 0 ");
        }

        /// <summary>
        /// 返回列表
        /// </summary>
        /// <param name="sql">查询字段</param>
        /// <param name="where">查询条件</param>
        /// <param name="page">查询页</param>
        /// <param name="pageSize">每页大小</param>
        /// <returns></returns>
        public List<T> FindListPage(string sql, string where, int page, int pageSize = _pageSize)
        {
            int cnt = GetCount(where);  // 总记录数
            if (cnt == 0)
                return new List<T>();
            int pageCnt = cnt / pageSize;   // 总页数
            if (cnt % pageSize != 0)
                ++pageCnt;
            if (page < 1)
                page = 1;
            if (page > pageCnt)
                page = pageCnt;
            int offset = (page - 1) * pageSize;

            string name = typeof(T).Name;
            return FindListBySql($"SELECT {sql} FROM {name} WHERE {where} LIMIT {offset},{pageSize}");
        }

        // 根据条件查询记录总数
        private int GetCount(string where)
        {
            string name = typeof(T).Name;
            object count = GetSingle($"SELECT COUNT(0) FROM {name} WHERE {where}");
            return int.Parse(count.ToString());
        }

        /// <summary>
        /// 执行一条计算查询结果语句，返回查询结果（object）。
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="param"></param>
        /// <returns></returns>
        public object GetSingle(string sql, object param = null)
        {
            return helper.GetSingle(sql, param);
        }

        /// <summary>
        /// 获取表中的记录总数
        /// </summary>
        /// <returns></returns>
        public int CountAll()
        {
            using (var db = GetDbConn())
            {
                return db.Count<T>();
            }
        }

        /// <summary>
        /// 删除表中指定的记录
        /// </summary>
        /// <returns></returns>
        public virtual bool Delete(T ett)
        {
            if (ett == null)
                return false;
            using (var db = GetDbConn())
            {
                return db.Delete(ett);
            }
        }

        /// <summary>
        /// 根据主健获取表中行对象
        /// </summary>
        /// <returns></returns>
        public virtual T Get(T ett)
        {
            if (ett == null)
                return null;
            using (var db = GetDbConn())
            {
                return db.Get<T>(ett);
            }
        }

        /// <summary>
        /// 插入数据
        /// </summary>
        public virtual void Insert(T ett)
        {
            if (ett == null)
                return;
            using (var db = GetDbConn())
            {
                db.Insert<T>(ett);
            }
        }

        /// <summary>
        /// 根据主键更改数据
        /// </summary>
        public virtual bool Update(T ett)
        {
            if (ett == null)
                return false;
            using (var db = GetDbConn())
            {
                return db.Update(ett);
            }
        }

        /// <summary>
        /// 返回列表
        /// </summary>
        /// <typeparam name="T1"></typeparam>
        /// <param name="sql"></param>
        /// <param name="param"></param>
        /// <returns></returns>
        public List<T1> FindListBySql<T1>(string sql, object param = null)
        {
            return helper.GetList<T1>(sql, param);
        }
        /// <summary>
        /// 返回单个实体
        /// </summary>
        /// <typeparam name="T1"></typeparam>
        /// <param name="sql"></param>
        /// <param name="param"></param>
        /// <returns></returns>
        public T1 FindSignleBySql<T1>(string sql, object param = null)
        {
            return helper.Single<T1>(sql, param);
        }
        /// <summary>
        /// 执行sql语句，返回影响的行数
        /// </summary>
        /// <param name="sql"></param>
        /// <returns></returns>
        public int ExecuteSQL(string sql)
        {
            return helper.ExecuteSQL(sql);
        }
        /// <summary>
        /// 执行sql语句，返回IDataReader
        /// </summary>
        /// <param name="sql"></param>
        /// <returns></returns>
        public IDataReader ExecuteReader(string sql)
        {
            return helper.ExecuteReader(sql);
        }
        public DataTable ExecuteDataTable(string sql)
        {
            return helper.ExecuteDataTable(sql);
        }
        /// <summary>
        /// 执行存储过程
        /// </summary>
        /// <typeparam name="T1"></typeparam>
        /// <param name="name"></param>
        /// <param name="param"></param>
        /// <returns></returns>
        public List<T1> ExecuteStoredProcedure<T1>(string name, object param = null)
        {
            return helper.ExecuteStoredProcedure<T1>(name, param);
        }

        /// <summary>
        /// 根据sql更新
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="param"></param>
        /// <returns></returns>
        public bool Update(string sql, object param = null)
        {
            return helper.Update(sql, param);
        }


        #region 软删除相关

        private const string delete_flag = "delete_time";

        /// <summary>
        /// 查询条件加上delete标识符
        /// </summary>
        /// <param name="where"></param>
        /// <param name="flag0">true:查询flag为0;false:查询flag大于0</param>
        /// <returns></returns>
        public string QueryStringDeleteFlag(string where, bool flag0 = true)
        {
            string flag = "";
            if (flag0)
                flag = $" {delete_flag}=0 ";
            else
                flag = $" {delete_flag}>0 ";
            if (where == null || where.Equals(""))
                return flag;
            else
                return where + $" AND {flag}";
        }

        /// <summary>
        /// 删除表中指定的记录
        /// </summary>
        /// <returns></returns>
        public bool SoftDelete(T ett,long user_id)
        {
            if (ett == null)
                return false;
            (ett as Core.SoftDeleteCore).delete_user_id = user_id;
            (ett as Core.SoftDeleteCore).delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            return Update(ett);
        }

        #endregion

        #region sequence

        /// <summary>
        /// 从数据库获取sequence
        /// </summary>
        /// <returns></returns>
        public long GetNextIdCom()
        {
            return GetNextId("seq_com");
        }

        /// <summary>
        /// 从数据库获取sequence
        /// </summary>
        /// <returns></returns>
        public long GetNextIdSys()
        {
            return GetNextId("seq_sys");
        }

        /// <summary>
        /// 从数据库获取sequence
        /// </summary>
        /// <param name="seq_name">sequence名字</param>
        /// <returns></returns>
        public long GetNextId(string seq_name)
        {
            string sql = $"SELECT f_nextval('{seq_name}')";
            object obj = helper.GetSingle(sql);
            long id = 0;
            long.TryParse(obj.ToString(), out id);
            return id;
        }

        #endregion

        /// <summary>
        /// 比较两个类中的属性值是否有变化,返回有变化的属性，并将旧的和新的值记录下来
        /// </summary>
        /// <param name="old_value">旧的值</param>
        /// <param name="new_value">新的值</param>
        /// <returns></returns>
        public string CompareValue<T1>(T1 old_value, T1 new_value)
        {
            if (old_value == null || new_value == null)
                return null;
            //  List<ObjUpdateDto> list = new List<ObjUpdateDto>();// 类型更改的类集合
            Dictionary<string, string> dict = new Dictionary<string, string>();
            Type t = typeof(T1);// 首先获取T的类
            PropertyInfo[] properties = t.GetProperties();// 获取到T中的所有的属性

            foreach (PropertyInfo p in properties)// 循环遍历所有的属性
            {
                if (!GetObjectPropertyValue(old_value, p.Name).Equals(GetObjectPropertyValue(new_value, p.Name)))// 将旧的和新的进行比较，将不同放入集合中
                {
                    dict.Add(p.Name, GetObjectPropertyValue(old_value, p.Name) + "→" + GetObjectPropertyValue(new_value, p.Name));
                }
            }
            if (dict.Count == 0)
                return "";
            return new Tools.Serialize().SerializeJson(dict);
        }
        /// <summary>
        /// 将类中所有的非空的属性和属性的值记录下来，并且返回
        /// </summary>
        /// <typeparam name="T1"></typeparam>
        /// <param name="t"></param>
        /// <returns></returns>
        public string AddValue<T1>(T1 t)
        {
            if (t == null)
                return null;
            // List<ObjAddDto> addList = new List<ObjAddDto>();
            Dictionary<string, string> dict = new Dictionary<string, string>();
            Type type = typeof(T1);
            PropertyInfo[] properties = type.GetProperties();// 获取到T中的所有的属性
            foreach (PropertyInfo p in properties)
            {
                dict.Add(p.Name, GetObjectPropertyValue(t, p.Name));
            }
            if (dict.Count == 0)
                return "";
            return new Tools.Serialize().SerializeJson(dict);
        }

        /// <summary>
        /// 获取到T模板中的属性的值
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="t"></param>
        /// <param name="propertyname"></param>
        /// <returns></returns>
        public static string GetObjectPropertyValue<T1>(T1 t, string propertyname)
        {
            // T模板类型
            Type type = typeof(T1);
            // 获得属性
            PropertyInfo property = type.GetProperty(propertyname);
            // 属性非空判断
            if (property == null) return string.Empty;
            // 获取Value
            object o = property.GetValue(t, null);
            // Value非空判断
            if (o == null) return string.Empty;
            // 返回Value
            return o.ToString();
        }
        /// <summary>
        /// 执行多个sql语句的方法
        /// </summary>
        /// <param name="param"></param>
        /// <param name="sql"></param>
        /// <returns></returns>
        public bool SQLTransaction(object param = null, params string[] sql) {
            return helper.SQLTransaction(param,sql);
        }
    }
}
