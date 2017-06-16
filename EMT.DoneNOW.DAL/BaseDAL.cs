using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using Dapper.FastCrud;

namespace EMT.DoneNOW.DAL
{
    public abstract  class BaseDAL<T> where T:class
    {
        protected DapperHelper helper = new DapperHelper();
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
        /// 从数据库获取sequence
        /// </summary>
        /// <param name="seq_name">sequence名字</param>
        /// <returns></returns>
        public long GetNextId(string seq_name = "object_id")
        {
            string sql = $"SELECT get_next_id('{seq_name}')";
            object obj = helper.GetSingle(sql);
            long id = 0;
            long.TryParse(obj.ToString(), out id);
            return id;
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
        /// 执行sql语句
        /// </summary>
        /// <param name="sql"></param>
        /// <returns></returns>
        public int ExecuteSQL(string sql)
        {
            return helper.ExecuteSQL(sql);
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

        private const string delete_flag = "";

        /// <summary>
        /// 查询条件加上delete标识符
        /// </summary>
        /// <param name="where"></param>
        /// <param name="flag0">true:查询flag为0;false:查询flag大于0</param>
        /// <returns></returns>
        public string QueryStringDeleteFlag(string where, bool flag0)
        {
            string flag = "";
            if (flag0)
                flag = $" {delete_flag}=0 ";
            else
                flag = $" {delete_flag}>0 ";
            if (where == null || where.Equals(""))
                return flag;
            else
                return $" AND {flag}";
        }

        /// <summary>
        /// 删除表中指定的记录
        /// </summary>
        /// <returns></returns>
        public bool SoftDelete(T ett)
        {
            return Update(ett);
        }

        #endregion

    }
}
