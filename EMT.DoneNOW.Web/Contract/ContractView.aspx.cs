using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web.Contract
{
    public partial class ContractView : BasePage
    {
        protected ctt_contract contract = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var contract_id = Request.QueryString["id"];
                contract = new ctt_contract_dal().FindNoDeleteById(long.Parse(contract_id));
                var type = Request.QueryString["type"];
                switch (type)
                {
                    case "InternalCost":
                        viewContractIframe.Src = "../Common/SearchBodyFrame.aspx?cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTRACT_INTERNAL_COST + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.InternalCost + "&id=" + contract.id;
                        ShowTitle.Text = "内部成本-"+contract.name;
                        break;
                    case "item":
                        viewContractIframe.Style["height"] = "100%";
                        second.Style["height"] = "600";
                        viewContractIframe.Src = "../Common/SearchBodyFrame.aspx?cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RELATION_CONFIGITEM + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.Relation_ConfigItem + "&id=" + contract_id;
                        second.Src = "../Common/SearchBodyFrame.aspx?cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.NORELATION_CONFIGITEM + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.Norelation_ConfigItem + "&id=" + contract.account_id+"&contract_id="+contract.id;
                        ShowTitle.Text = "配置项-" + contract.name;
                        break;
                    case "charge":
                        viewContractIframe.Src = "../Common/SearchBodyFrame.aspx?isCheck=1&cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTRACT_CHARGE + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.Contract_Charge + "&id=" + contract.id;
                        ShowTitle.Text = "成本-" + contract.name;
                        break;
                    case "defaultCost":
                        viewContractIframe.Src = "../Common/SearchBodyFrame.aspx?cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTRACT_DEFAULT_COST + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.CONTRACT_DEFAULT_COST + "&id=" + contract.id;
                        ShowTitle.Text = "默认成本-" + contract.name;
                        break;
                    case "rate":
                        viewContractIframe.Src = "../Common/SearchBodyFrame.aspx?cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTRACT_TIME_RATE + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.CONTRACT_RATE + "&id=" + contract.id;
                        ShowTitle.Text = "预付时间系数-" + contract.name;
                        break;
                    case "udf":
                        viewContractIframe.Style["height"] = "100%";
                        second.Style["height"] = "600";
                        viewContractIframe.Src = "../Common/SearchBodyFrame.aspx?cat=" + (int)DicEnum.QUERY_CATE.CONTRACT_UDF + "&type=" + (int)QueryType.ContractUDF + "&id=" + contract.id;
                        ShowTitle.Text = "自定义字段-" + contract.name;
                        break;
                    case "block":
                        viewContractIframe.Src = "../Common/SearchBodyFrame.aspx?cat=" + (int)DicEnum.QUERY_CATE.CONTRACT_BLOCK + "&type=" + (int)QueryType.ContractBlock + "&id=" + contract.id;
                        ShowTitle.Text = "预付费用-" + contract.name;
                        break;
                    case "blockTime":
                        viewContractIframe.Src = "../Common/SearchBodyFrame.aspx?cat=" + (int)DicEnum.QUERY_CATE.CONTRACT_BLOCK_TIME + "&type=" + (int)QueryType.ContractBlockTime + "&id=" + contract.id;
                        ShowTitle.Text = "预付时间-" + contract.name;
                        break;
                    case "roleRate":
                        viewContractIframe.Src = "../Common/SearchBodyFrame.aspx?cat=" + (int)DicEnum.QUERY_CATE.CONTRACT_RATE + "&type=" + (int)QueryType.ContractRate + "&id=" + contract.id;
                        ShowTitle.Text = "费率-" + contract.name;
                        break;
                    default:
                        ShowTitle.Text = "摘要-" + contract.name;
                        viewContractIframe.Src = "ContractSummary.aspx?id=" + contract.id;
                        break;
                }
            }
            catch (Exception)
            {
                Response.End();
            }

        }
    }
}