﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.Product
{
    public partial class ProductCateManage : BasePage
    {
        
        protected List<ProductCateDto> cateList = new ProductBLL().GetProductCateList();
        protected void Page_Load(object sender, EventArgs e)
        {

        }
    }
}