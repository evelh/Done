using Swashbuckle.Swagger;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http.Description;

namespace EMT.DoneNOW.WebAPI
{
    public class HeaderOperationFilter : IOperationFilter
    {
        //配置header token信息 参考 http://blog.sluijsveld.com/28/01/2016/CustomSwaggerUIField/
        public void Apply(Operation operation, SchemaRegistry schemaRegistry, ApiDescription apiDescription)
        {
            if (operation.parameters == null)
                operation.parameters = new List<Parameter>();
            operation.parameters.Add(new Parameter
            {
                name = "token",
                @in = "header",
                description = "access token",
                required = true,
                type = "string"
            });
            
        }
    }
}