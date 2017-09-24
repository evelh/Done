using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Contract
{
    public partial class ContractUdf : BasePage
    {
        protected DTO.UserDefinedFieldDto udf;      // 自定义字段信息
        protected long contractId;      // 合同id
        protected object udfValue;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string colName = Request.QueryString["colName"];   // 自定义字段col_comment字段
                contractId = Convert.ToInt64(Request.QueryString["contractId"]);   // 合同id
                InitValue(colName);
            }
        }

        // 初始化自定义字段值
        private void InitValue(string colName)
        {
            var bll = new UserDefinedFieldsBLL();
            var udfList = bll.GetUdf(DTO.DicEnum.UDF_CATE.CONTRACTS);
            udf = udfList.First(f => f.name.Equals(colName));
            var udfValues = bll.GetUdfValue(DTO.DicEnum.UDF_CATE.CONTRACTS, contractId, udfList);
            udfValue = udfValues.First(v => v.id == udf.id).value;

            id.Value = udf.id.ToString();
            contract_id.Value = contractId.ToString();
        }

        protected void SaveClose_Click(object sender, EventArgs e)
        {
            int udfId = int.Parse(id.Value);
            new ContractBLL().EditUdf(long.Parse(contract_id.Value), udfId, Request.Form[udfId.ToString()], Request.Form["description"], GetLoginUserId());
            var bll = new UserDefinedFieldsBLL();
            var udfList = bll.GetUdf(DTO.DicEnum.UDF_CATE.CONTRACTS);
            udf = udfList.First(f => f.id.Equals(udfId));
            Response.Write("<script>alert('修改自定义字段值成功！');window.close();self.opener.location.reload();</script>");
        }
    }
}