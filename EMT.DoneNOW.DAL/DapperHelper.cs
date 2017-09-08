using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.Tools;
using System.Configuration;
using System.Reflection;
using System.Data;
using Dapper;
using MySql.Data.MySqlClient;
namespace EMT.DoneNOW.DAL
{
    public class DapperHelper
    {
        static DapperHelper()
        {
            Column2PropertyMapping.Init();
        }

        private static string _connstr = string.Empty;
        private static string ConnectionString
        {
            get
            {
                if(_connstr.IsNullOrEmpty())
                {
                    _connstr = ConfigurationManager.AppSettings["connection"];
                }
                return _connstr;
            }
        }

        /// <summary>
        /// 获取单个实例
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="sql"></param>
        /// <param name="param"></param>
        /// <returns></returns>
        public T Single<T>(string sql, object param = null)
        {
            using (IDbConnection connect = BuildConnection())
            {
                var list = connect.Query<T>(sql, param).ToList();
                if (list != null && list.Count > 0)
                {
                    return list[0];
                }
                return default(T);
            }
        }

        /// <summary>
        /// 执行一条计算查询结果语句，返回查询结果（object）。
        /// </summary>
        /// <param name="sql">计算查询结果语句</param>
        /// <param name="param"></param>
        /// <returns>查询结果（object）</returns>
        public object GetSingle(string sql, object param = null)
        {
            using (IDbConnection connect = BuildConnection())
            {
                object obj = connect.ExecuteScalar(sql, param);
                if ((Object.Equals(obj, null)) || (Object.Equals(obj, System.DBNull.Value)))
                {
                    return null;
                }
                return obj;
            }
        }

        /// <summary>
        /// 获取列表
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="sql"></param>
        /// <param name="param"></param>
        /// <returns></returns>
        public List<T> GetList<T>(string sql, object param = null)
        {
            using (IDbConnection connect = BuildConnection())
            {
                var list = connect.Query<T>(sql, param).ToList();
                return list;
            }
        }
        /// <summary>
        /// 执行SQL
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="param"></param>
        /// <returns></returns>
        public int ExecuteSQL(string sql, object param = null)
        {
            using (IDbConnection connect = BuildConnection())
            {
                return connect.Execute(sql, param);

            }
        }
        /// <summary>
        /// Execute parameterized SQL and return an System.Data.IDataReader
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="param"></param>
        /// <returns></returns>
        public IDataReader ExecuteReader(string sql, object param = null)
        {
            using (IDbConnection connect = BuildConnection())
            {
                return connect.ExecuteReader(sql, param);
            }
        }
        public DataTable ExecuteDataTable(string sql, object param = null)
        {
            DataTable dt = null;
            using (IDbConnection connect = BuildConnection())
            {
                var reader = connect.ExecuteReader(sql, param);
                if (reader.FieldCount>0)
                {
                    dt = new DataTable();
                    DataTable dtTmp = reader.GetSchemaTable();
                    foreach (DataRow row in dtTmp.Rows)
                    {
                        DataColumn dc = new DataColumn(row["ColumnName"].ToString(), row["DataType"] as Type);
                        dt.Columns.Add(dc);
                    }
                    object[] value = new object[reader.FieldCount];
                    while (reader.Read())
                    {
                        reader.GetValues(value);
                        dt.LoadDataRow(value, true);
                    }
                }
            }
            return dt;
        }
        /// <summary>
        /// 添加
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="param"></param>
        /// <returns></returns>
        public bool Add(string sql, object param = null)
        {
            using (IDbConnection connect = BuildConnection())
            {
                int rs = connect.Execute(sql, param);
                return rs >= 1;
            }
        }
        /// <summary>
        /// 添加并返回自增ID
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="param"></param>
        /// <returns></returns>
        public int AddAndGetIdentity(string sql, object param = null)
        {
            using (IDbConnection connect = BuildConnection())
            {
                var beginTran = connect.BeginTransaction();
                int rs = connect.Execute(sql, param, beginTran);
                if (rs > 0)
                {
                    int identity = (int)connect.Query<decimal>("select @@identity", null, beginTran).FirstOrDefault();
                    if (identity > 0)
                    {
                        beginTran.Commit();
                        return identity;
                    }
                    else
                    {
                        beginTran.Rollback();
                        return 0;
                    }
                }
                else
                {
                    beginTran.Rollback();
                    return 0;
                }
            }
        }
        /// <summary>
        /// 执行多条sql语句的方法
        /// </summary>
        /// <param name="param"></param>
        /// <param name="sql"></param>
        /// <returns></returns>
        public bool SQLTransaction(object param = null,params string[] sql)
        {
            using (IDbConnection connect = BuildConnection())
            {
                var beginTran = connect.BeginTransaction();
                try {
                    int i,n=sql.Length;
                    for(i=0;i<n;++i){
                        connect.Execute(sql[i], param, beginTran);                        
                    }
                    beginTran.Commit();
                    return true;
                }
                catch(Exception ex)
                    {
                    beginTran.Rollback();
                    return false;                    
                }               
            }
        }
        /// <summary>
        /// 用于更新数据
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="param"></param>
        /// <returns></returns>
        public bool Update(string sql, object param = null)
        {
            using (IDbConnection connect = BuildConnection())
            {
                int rs = connect.Execute(sql, param);
                return rs >= 1;
            }
        }
        /// <summary>
        /// 用于删除数据
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="param"></param>
        /// <returns></returns>
        public bool Delete(string sql, object param = null)
        {
            using (IDbConnection connect = BuildConnection())
            {
                int rs = connect.Execute(sql, param);
                return rs >= 1;
            }
        }
        /// <summary>
        /// 构建连接
        /// </summary>
        /// <returns></returns>
        public static IDbConnection BuildConnection()
        {
            IDbConnection connect = new MySqlConnection(ConnectionString);
            connect.Open();
            return connect;
        }
        /// <summary>
        /// 执行没有返回值的储存过程
        /// </summary>
        /// <param name="name"></param>
        /// <param name="param"></param>
        /// <returns></returns>
        public bool ExecuteStoredProcedureNonQuery(string name, DynamicParameters param = null)
        {
            using (IDbConnection connect = BuildConnection())
            {
                int rs = connect.Execute(name, param, null, null, CommandType.StoredProcedure);
                return rs > 0;
            }
        }
        /// <summary>
        /// 执行存储过程并返回一个列表
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="name"></param>
        /// <param name="param">DynamicParameters或OBJECT</param>
        /// <returns></returns>
        public List<T> ExecuteStoredProcedure<T>(string name, object param = null)
        {
            using (IDbConnection connect = BuildConnection())
            {
                List<T> rs = connect.Query<T>(name, param, null, true, null, CommandType.StoredProcedure).ToList();
                return rs;
            }
        }  
        /// <summary>
        /// 获取批量入库表名
        /// </summary>
        /// <param name="tableName"></param>
        /// <returns></returns>
        public string BuildDataTableName(string tableName)
        {
            return tableName;
        }
        /// <summary>
        /// 把List转换成DataTable，以方便批量入库
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="list"></param>
        /// <returns></returns>
        public DataTable BuildDataTable<T>(List<T> list)
        {
            List<PropertyInfo> propList = new List<PropertyInfo>();
            DataTable dt = new DataTable();
            Type type = typeof(T);
            dt.TableName = type.Name;
            PropertyInfo[] props = type.GetProperties();
            foreach (var prop in props)
            {
                if (ValidateProperty(prop) == false) continue;
                dt.Columns.Add(prop.Name);
                propList.Add(prop);
            }
            foreach (var item in list)
            {
                DataRow dr = dt.NewRow();
                foreach (var p in propList)
                {
                    dr[p.Name] = p.GetValue(item, null);
                }
                dt.Rows.Add(dr);
            }
            return dt;

        }

        private static bool ValidateProperty(PropertyInfo prop)
        {
            #region 检查类型是否符合要求 如果类型不是 值类型(int int? double double? 等等 [不包括枚举]) 和string 则跳过
            //如果是一个类并且类型不是string 
            if (prop.PropertyType.IsClass && prop.PropertyType != "".GetType())
            {
                //如果这个类不是Nullable (Nullable是泛型，如果不是泛型就不是Nullable 或者 如果是泛型并且不等于Nullable 那也不是基本数据类型)
                if (prop.PropertyType.IsGenericType == false || (prop.PropertyType.IsGenericType == true && prop.PropertyType.GetGenericTypeDefinition() != typeof(Nullable<>)))
                {
                    return false;
                }
            }
            //如果是枚举也跳过
            if (prop.PropertyType.IsEnum)
            {
                return false;
            }
            return true;
            #endregion
        }

    }
}
