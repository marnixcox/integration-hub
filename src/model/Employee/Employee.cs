using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

namespace Integration.Model.Employee
{
    [JsonObject(ItemNullValueHandling = NullValueHandling.Ignore, NamingStrategyType = typeof(DefaultNamingStrategy))]
    public class Employee
    {
        public string Sender { get; set; }
        public string Receiver { get; set; }
        public DateTime? MessageDateTime { get; set; }
        public Guid MessageId { get; set; }
        public string Number { get; set; }
        public string Name { get; set; }
    }
}

