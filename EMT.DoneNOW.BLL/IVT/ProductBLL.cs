using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using static EMT.DoneNOW.DTO.DicEnum;
using System.Data.SqlClient;

namespace EMT.DoneNOW.BLL
{
    public class ProductBLL
    {
        private readonly ivt_product_dal _dal = new ivt_product_dal();
        private readonly ivt_product_vendor_dal _dal1 = new ivt_product_vendor_dal();
        ///通过id获取ivt_product产品对象
        public ivt_product GetProduct(long id)
        {
            return _dal.FindSignleBySql<ivt_product>($"select * from ivt_product where id={id} and delete_time = 0 ");
        }
        /// <summary>
        /// 获取物料代码名称
        /// </summary>
        /// <param name="cost_code_id"></param>
        /// <returns></returns>
        public string cost_code_name(long cost_code_id) {
            return new d_cost_code_dal().FindById(cost_code_id).name;
        }
        /// <summary>
        /// 获取产品供应商对象
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ivt_product_vendor GetSingelVendor(long id)
        {
            return _dal1.FindSignleBySql<ivt_product_vendor>($"select * from ivt_product_vendor where id={id} and delete_time=0");
        }
        /// <summary>
        /// 获取供应商名称
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public string GetVendorName(long id)
        {
            return new crm_account_dal().FindSignleBySql<crm_account>($"select * from crm_account where id={id} and delete_time=0").name;
        }
        /// <summary>
        /// 通过产品id,返回供应商对象集合
        /// </summary>
        /// <param name="product_id"></param>
        /// <returns></returns>
        public List<ivt_product_vendor> GetVendorList(long product_id)
        {
            return _dal1.FindListBySql<ivt_product_vendor>($"select * from ivt_product_vendor where product_id={product_id} and delete_time=0").ToList();
        }
        public Dictionary<string, object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();

            dic.Add("Item_Type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.INSTALLED_PRODUCT_CATE)));              // 默认自定义配置项
            dic.Add("Period_Type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.QUOTE_ITEM_PERIOD_TYPE)));              // 周期类型
            return dic;
        }
        /// <summary>
        /// 新增产品和相关供应商信息
        /// </summary>
        /// <param name="product">产品</param>
        /// <param name="vendordata">供应商集合</param>
        /// <param name="user_id">操作用户</param>
        /// <returns></returns>
        public ERROR_CODE InsertProductAndVendor(ivt_product product, VendorData vendordata, List<UserDefinedFieldValue> udf, long user_id) {
            //产品
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            product.id = (int)(_dal.GetNextIdCom());

            product.create_time=product.update_time= Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            product.create_user_id =product.update_user_id= user_id;
           
            //唯一性校验
            var propro = _dal.FindListBySql($"select * from ivt_product where product_name='{ product.product_name}' and delete_time=0 ");
            if (propro != null) {
                return ERROR_CODE.EXIST;
            }

            _dal.Insert(product);            
                //更新日志
                var add_log = new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = (int)user.id,
                    name = "",
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.PRODUCT,//员工
                    oper_object_id = product.id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.ADD,
                    oper_description = _dal.AddValue(product),
                    remark = "新增产品信息"
                };          // 创建日志
                new sys_oper_log_dal().Insert(add_log);       // 插入日志

                //供应商
                foreach (var ve in vendordata.VENDOR)
            {
                ivt_product_vendor veve = new ivt_product_vendor();
                if (ve.operate == 3) {
                    veve.id = (int)(_dal.GetNextIdCom());
                   veve.update_time= veve.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    veve.create_user_id = user_id;
                    veve.product_id = product.id;
                    veve.is_active = ve.is_active;
                    veve.is_default = ve.is_default;
                    veve.vendor_account_id = ve.vendor_account_id;
                    veve.vendor_cost = ve.vendor_cost;
                    veve.vendor_product_no = ve.vendor_product_no;
                    _dal1.Insert(veve);

                    var add_vendor_log = new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = (int)user.id,
                        name = "",
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.PRODUCT_VENDOR,//员工
                        oper_object_id = veve.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.ADD,
                        oper_description = _dal.AddValue(veve),
                        remark = "新增供应商信息"
                    };          // 创建日志
                    new sys_oper_log_dal().Insert(add_vendor_log);       // 插入日志
                }
            }


            #region 保存产品扩展信息          

            var udf_contact_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.PRODUCTS); // 产品的自定义字段
            var udf_con_list = udf;                                       // 传过来的产品
            new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.PRODUCTS, user_id,product.id, udf_contact_list, udf_con_list, OPER_LOG_OBJ_CATE.PRODUCT); // 保存成功即插入日志
            #endregion

            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 修改更新产品和相关供应商信息
        /// </summary>
        /// <param name="product">产品</param>
        /// <param name="vendordata">供应商集合</param>
        /// <param name="user_id">操作用户</param>
        /// <returns></returns>
        public ERROR_CODE UpdateProductAndVendor(ivt_product product, VendorData vendordata, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            //产品更新
            product.update_time= Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            product.update_user_id = user_id;

            //唯一性校验
            var propro = _dal.FindListBySql($"select * from ivt_product where product_name='{ product.product_name}' and delete_time=0 ");
            if (propro != null)
            {
                return ERROR_CODE.EXIST;
            }

            if (!_dal.Update(product)) {
                return ERROR_CODE.ERROR;
            }
            //更新日志
            var add_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = "",
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.PRODUCT,//员工
                oper_object_id = product.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.AddValue(product),
                remark = "修改产品信息"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_log);       // 插入日志
            //供应商更新
            foreach (var ve in vendordata.VENDOR)
            {
                ivt_product_vendor veve = new ivt_product_vendor();
                //删除
                if (ve.operate == 1) {
                    var de = _dal1.FindById(ve.id);
                    if (de != null) {
                        de.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        de.delete_user_id = user_id;
                        _dal1.Update(de);
                        var add_vendor_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = "",
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.PRODUCT_VENDOR,//员工
                            oper_object_id = veve.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                            oper_description = _dal.AddValue(veve),
                            remark = "删除供应商信息"
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add_vendor_log);       // 插入日志
                    }

                }

                //更新
                if (ve.operate == 2) {
                    veve = _dal1.FindById(ve.id);
                    if (veve != null) {
                        veve.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        veve.update_user_id = user_id;
                        veve.product_id = product.id;
                        veve.is_active = ve.is_active;
                        veve.is_default = ve.is_default;
                        veve.vendor_account_id = ve.vendor_account_id;
                        veve.vendor_cost = ve.vendor_cost;
                        veve.vendor_product_no = ve.vendor_product_no;
                        _dal1.Update(veve);
                        var add_vendor_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = "",
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.PRODUCT_VENDOR,//员工
                            oper_object_id = veve.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = _dal.AddValue(veve),
                            remark = "修改供应商信息"
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add_vendor_log);       // 插入日志
                    }
                }

                //新增
                if (ve.operate == 3) {
                    veve.id = (int)(_dal.GetNextIdCom());
                    veve.update_time = veve.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    veve.create_user_id = user_id;
                    veve.product_id = product.id;
                    veve.is_active = ve.is_active;
                    veve.is_default = ve.is_default;
                    veve.vendor_account_id = ve.vendor_account_id;
                    veve.vendor_cost = ve.vendor_cost;
                    veve.vendor_product_no = ve.vendor_product_no;
                    _dal1.Insert(veve);
                    var add_vendor_log = new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = (int)user.id,
                        name = "",
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.PRODUCT_VENDOR,//员工
                        oper_object_id = veve.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.ADD,
                        oper_description = _dal.AddValue(veve),
                        remark = "新增供应商信息"
                    };          // 创建日志
                    new sys_oper_log_dal().Insert(add_vendor_log);       // 插入日志
                }

            }
                return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 不存在该产品的仓库名称和id
        /// </summary>
        /// <returns></returns>
        public Dictionary<long, string> GetWarehouseDownList(long product_id)
        {
            Dictionary<long, string> dic = new Dictionary<long, string>();
            return new ivt_warehouse_dal().FindListBySql<ivt_warehouse>($"select a.* from ivt_warehouse a,ivt_warehouse_product b where a.delete_time=0 and b.delete_time=0 and a.id=b.warehouse_id and b.product_id={product_id}").ToDictionary(d => d.id, d => d.name);
        }
        /// <summary>
        /// 获取存在该产品的仓库名称和id
        /// </summary>
        /// <param name="product_id"></param>
        /// <returns></returns>
        public Dictionary<long, string> GetNoWarehouseDownList(long product_id)
        {
            Dictionary<long, string> dic = new Dictionary<long, string>();
            return new ivt_warehouse_dal().FindListBySql<ivt_warehouse>($"select a.* from ivt_warehouse a,ivt_warehouse_product b where a.delete_time=0 and b.delete_time=0 and a.id=b.warehouse_id and b.product_id!='{product_id}'").ToDictionary(d => d.id, d => d.name);
        }
        public ivt_warehouse Getwarehouse(long id) {
            return new ivt_warehouse_dal().FindSignleBySql<ivt_warehouse>($"select * from ivt_warehouse where id={id} and delete_time=0");
        }

        //public ivt_warehouse GetWarehouse(long id) {
        //    return new ivt_warehouse_dal().FindSignleBySql<ivt_warehouse>($"select * from ivt_warehouse where id={id} and delete_time=0");
        //}
        /// <summary>
        /// 通过id获取一个ivt_warehouse_product对象
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ivt_warehouse_product Getwarehouse_product(long id) {
            return new ivt_warehouse_product_dal().FindSignleBySql<ivt_warehouse_product>($"select * from ivt_warehouse_product where id={id} and delete_time=0");
        }
        /// <summary>
        /// 通过产品id和仓库id获取产品库存信息
        /// </summary>
        /// <param name="product_id"></param>
        /// <param name="warehouse_id"></param>
        /// <returns></returns>
        public ivt_warehouse_product Getwarehouse_product(long product_id, long warehouse_id) {
            return new ivt_warehouse_product_dal().FindSignleBySql<ivt_warehouse_product>($"select * from ivt_warehouse_product where product_id={product_id} and warehouse_id={warehouse_id} and delete_time=0");
        }
        /// <summary>
        /// 保存库存转移记录
        /// </summary>
        /// <param name="tran"></param>
        /// <returns></returns>
        public ERROR_CODE inventory_transfer(ivt_inventory_transfer tran,ivt_warehouse_product from_ware,ivt_warehouse_product to_ware,long user_id) {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            //转移记录
            tran.id= (int)(_dal.GetNextIdCom());
            tran.type_id = (int)TICKET.INVENTORY;
            tran.create_time = tran.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            tran.create_user_id = tran.update_user_id = user.id;

            //转出
            from_ware.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            from_ware.update_user_id = user.id;

            //转入
            to_ware.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            to_ware.update_user_id = user.id;


            //new ivt_inventory_transfer_dal().Insert(tran);
            //new ivt_warehouse_product_dal().Update(from_ware);
            //new ivt_warehouse_product_dal().Update(to_ware);

            string sql1 = $"insert into `donenow`.`ivt_inventory_transfer` (`id`, `product_id`, `transfer_from_warehouse_id`, `transfer_to_warehouse_id`,`transfer_quantity`, `notes`, `type_id`, `create_user_id`, `update_user_id`,`create_time`, `update_time`) values ('{tran.id}','{tran.product_id}','{tran.transfer_from_warehouse_id}','{tran.transfer_to_warehouse_id}','{tran.transfer_quantity}','{tran.notes}','{tran.type_id}','{tran.create_user_id}','{tran.update_user_id}','{tran.create_time}','{tran.update_time}');";
            string sql2 = $"update `ivt_warehouse_product` set `quantity` = '{from_ware.quantity}',`update_user_id` = '{from_ware.update_user_id}',`update_time` = '{from_ware.update_time}' where `id` = '{from_ware.id}'";
            string sql3 = $"update `ivt_warehouse_product` set `quantity` = '{to_ware.quantity}',`update_user_id` = '{to_ware.update_user_id}',`update_time` = '{to_ware.update_time}' where `id` = '{to_ware.id}'";
            string[] sql = {sql1,sql2,sql3};

            if (!_dal.SQLTransaction(null, sql)){
                return ERROR_CODE.ERROR;
            }          
           


            var add_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = "",
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.WAREHOUSE_PRODUCT,//
                oper_object_id = from_ware.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.AddValue(from_ware),
                remark = "修改产品库存数量信息"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_log);       // 插入日志


            var add2_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = "",
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.WAREHOUSE_PRODUCT,//
                oper_object_id = to_ware.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.AddValue(to_ware),
                remark = "修改产品库存数量信息"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add2_log);       // 插入日志


           // _dal.UpdateTran(sql);

            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        ///新增产品库存信息
        /// </summary>
        /// <param name="stock"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE InsertProductStock(ivt_warehouse_product stock,long user_id) {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            //唯一性校验
            ivt_warehouse_product_dal kk = new ivt_warehouse_product_dal();
           var re= kk.FindSignleBySql<ivt_warehouse_product>($"select * from ivt_warehouse_product where product_id={stock.product_id} and warehouse_id={stock.warehouse_id} and delete_time=0");
            if (re != null) {
                return ERROR_CODE.EXIST;
            }
            stock.id= (int)(_dal.GetNextIdCom());
            stock.create_time = stock.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            stock.create_user_id = stock.update_user_id = user_id;
            kk.Insert(stock);
            //操作日志
            var add_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = "",
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.WAREHOUSE_PRODUCT,//
                oper_object_id = stock.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(stock),
                remark = "新增产品库存信息"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_log);       // 插入日志

            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 修改产品供应商信息
        /// </summary>
        /// <param name="stock"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE UpdateProductStock(ivt_warehouse_product stock, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            stock.update_time= Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            stock.update_user_id = user.id;
            if (!(new ivt_warehouse_product_dal().Update(stock))) {
                return ERROR_CODE.ERROR;
            }
            //操作日志
            var add_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = "",
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.WAREHOUSE_PRODUCT,//
                oper_object_id = stock.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.AddValue(stock),
                remark = "修改产品库存信息"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_log);       // 插入日志
            return ERROR_CODE.SUCCESS;
        }
        public ERROR_CODE DeleteInventory(long id,long user_id) {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            ivt_warehouse_product_dal inv_dal = new ivt_warehouse_product_dal();
            var inv = inv_dal.FindSignleBySql<ivt_warehouse_product>($"select * from ivt_warehouse_product id={id} and delete_time=0");
            if (inv == null) {
                return ERROR_CODE.ERROR;
            }
            inv.delete_user_id = user_id;
            inv.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            if (!inv_dal.Update(inv)) {
                return ERROR_CODE.ERROR;
            }
            //操作日志
            var add_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = "",
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.WAREHOUSE_PRODUCT,//
                oper_object_id = inv.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                oper_description = _dal.AddValue(inv),
                remark = "删除产品库存信息"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_log);       // 插入日志

            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 产品删除
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ERROR_CODE DeleteProduct(long id,long user_id) {
            //删除前校验
            //            如果产品被配置项、工单、报价、商机、库存引用，则不能删除。
            //产品不能被删除，因为它被以下对象引用：
            //N1 对象1
            //N2 对象2
            //……
            //crm_opportunity商机
            //crm_installed_product配置项
            //ivt_warehouse_product库存
            //ctt_contract_cost


            var del = _dal.FindSignleBySql<ivt_product>($"select * from ivt_product where id={id} and delete_time=0");

            return ERROR_CODE.ERROR;
        }
    }
}
