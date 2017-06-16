using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace EMT.DoneNOW.WebAPI.Controllers
{
    public class Product
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Category { get; set; }
        public decimal Price { get; set; }
    }

    public class ValuesController : ApiController
    {
        // GET api/values
        public Product Get()
        {
            Product pdt = new Product
            {
                Id = 1,
                Name = "aa",
                Category = "sd",
                Price = 3.2M
            };
            var list = new List<Product> { pdt };
            return pdt;//list.AsEnumerable();
            //return new string[] { "value1", "value2" };
        }

        // GET api/values/5
        public string Get(int id)
        {
            return "value";
        }

        // POST api/values
        public void Post([FromBody]string value)
        {
        }

        // PUT api/values/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/values/5
        public void Delete(int id)
        {
        }
    }
}
